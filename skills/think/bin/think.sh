#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  think.sh init DIR GOAL_FILE CONSTRAINTS_FILE
  think.sh add DIR "Candidate sentence."
  think.sh score DIR ID SCORE "Rationale"
  think.sh narrow DIR
  think.sh status DIR
  think.sh winner DIR
USAGE
}

fail() { echo "think.sh: $*" >&2; exit 1; }

require_dir() {
  local dir="$1"
  [[ -d "$dir" ]] || fail "missing THINK directory: $dir"
}

next_id() {
  local file="$1"
  if [[ ! -s "$file" ]]; then
    echo 1
  else
    awk -F '\t' 'max<$1 {max=$1} END {print max+1}' "$file"
  fi
}

iteration_number() {
  local dir="$1"
  local n
  n=$(find "$dir/iterations" -type f -name 'iteration-*.md' 2>/dev/null | wc -l | tr -d ' ')
  printf '%03d' "$((n + 1))"
}

cmd_init() {
  local dir="$1" goal_file="$2" constraints_file="$3"
  [[ -f "$goal_file" ]] || fail "goal file not found: $goal_file"
  [[ -f "$constraints_file" ]] || fail "constraints file not found: $constraints_file"
  mkdir -p "$dir/iterations"
  cp "$goal_file" "$dir/goal.md"
  cp "$constraints_file" "$dir/constraints.md"
  : > "$dir/candidates.tsv"
  : > "$dir/active.tsv"
  : > "$dir/scores.tsv"
  : > "$dir/eliminated.tsv"
  echo "Initialized THINK workspace: $dir"
}

cmd_add() {
  local dir="$1" sentence="$2"
  require_dir "$dir"
  [[ "$sentence" == *.* || "$sentence" == *\? || "$sentence" == *! ]] || fail "candidate must be a sentence ending in punctuation"
  [[ "$sentence" != *$'\n'* && "$sentence" != *$'\t'* ]] || fail "candidate cannot contain tabs or newlines"
  local id
  id=$(next_id "$dir/candidates.tsv")
  printf '%s\t%s\n' "$id" "$sentence" >> "$dir/candidates.tsv"
  printf '%s\t%s\n' "$id" "$sentence" >> "$dir/active.tsv"
  echo "Added candidate $id"
}

cmd_score() {
  local dir="$1" id="$2" score="$3" rationale="$4"
  require_dir "$dir"
  [[ "$id" =~ ^[0-9]+$ ]] || fail "id must be a whole number"
  [[ "$score" =~ ^[0-9]+$ ]] || fail "score must be a whole number 0-100"
  (( score >= 0 && score <= 100 )) || fail "score must be between 0 and 100"
  grep -q "^${id}"$'\t' "$dir/active.tsv" || fail "candidate $id is not active"
  [[ "$rationale" != *$'\n'* && "$rationale" != *$'\t'* ]] || fail "rationale cannot contain tabs or newlines"

  local iter
  iter=$(iteration_number "$dir")
  awk -F '\t' -v id="$id" -v iter="$iter" '!(($1==iter) && ($2==id))' "$dir/scores.tsv" > "$dir/scores.tsv.tmp"
  mv "$dir/scores.tsv.tmp" "$dir/scores.tsv"
  printf '%s\t%s\t%s\t%s\n' "$iter" "$id" "$score" "$rationale" >> "$dir/scores.tsv"
  echo "Scored candidate $id = $score"
}

cmd_narrow() {
  local dir="$1"
  require_dir "$dir"
  local count keep iter
  count=$(wc -l < "$dir/active.tsv" | tr -d ' ')
  (( count > 0 )) || fail "no active candidates"
  if (( count == 1 )); then
    echo "Only one candidate remains; nothing to narrow."
    return 0
  fi
  keep=$(( (count + 1) / 2 ))
  iter=$(iteration_number "$dir")

  local scored_count
  scored_count=$(awk -F '\t' -v iter="$iter" '$1==iter {print $2}' "$dir/scores.tsv" | sort -n | uniq | wc -l | tr -d ' ')
  (( scored_count == count )) || fail "iteration $iter requires scores for all $count active candidates; found $scored_count"

  awk -F '\t' -v iter="$iter" '
    FNR == NR {
      if ($1 == iter) {
        score[$2] = $3
        rationale[$2] = $4
      }
      next
    }
    $1 in score {
      print $1 "\t" $2 "\t" score[$1] "\t" rationale[$1]
    }
  ' "$dir/scores.tsv" "$dir/active.tsv" > "$dir/.joined.tsv"

  sort -t $'\t' -k3,3nr -k1,1n "$dir/.joined.tsv" > "$dir/.ranked.tsv"
  head -n "$keep" "$dir/.ranked.tsv" | awk -F '\t' '{print $1"\t"$2}' > "$dir/active.tsv.tmp"
  tail -n +$((keep + 1)) "$dir/.ranked.tsv" | awk -F '\t' -v iter="$iter" '{print iter"\t"$1"\t"$2"\t"$3"\t"$4}' >> "$dir/eliminated.tsv"
  mv "$dir/active.tsv.tmp" "$dir/active.tsv"

  local note="$dir/iterations/iteration-${iter}.md"
  {
    echo "# THINK iteration $iter"
    echo
    echo "Active candidates before narrowing: $count"
    echo "Candidates kept: $keep"
    echo
    echo "## Ranking"
    awk -F '\t' '{printf "- %s: score %s - %s (%s)\n", $1, $3, $2, $4}' "$dir/.ranked.tsv"
    echo
    echo "Looping back to refine the list."
  } > "$note"

  rm -f "$dir/.joined.tsv" "$dir/.ranked.tsv"
  echo "Narrowed $count candidates to $keep using iteration $iter"
}

cmd_status() {
  local dir="$1"
  require_dir "$dir"
  echo "Goal:"
  sed 's/^/  /' "$dir/goal.md"
  echo
  echo "Constraints:"
  sed 's/^/  /' "$dir/constraints.md"
  echo
  echo "Active candidates:"
  if [[ -s "$dir/active.tsv" ]]; then
    awk -F '\t' '{printf "  %s. %s\n", $1, $2}' "$dir/active.tsv"
  else
    echo "  none"
  fi
}

cmd_winner() {
  local dir="$1"
  require_dir "$dir"
  local count
  count=$(wc -l < "$dir/active.tsv" | tr -d ' ')
  (( count == 1 )) || fail "winner requires exactly one active candidate; found $count"
  awk -F '\t' '{printf "Winner: %s. %s\n", $1, $2}' "$dir/active.tsv"
}

main() {
  [[ $# -ge 1 ]] || { usage; exit 1; }
  local cmd="$1"; shift
  case "$cmd" in
    init) [[ $# -eq 3 ]] || { usage; exit 1; }; cmd_init "$@" ;;
    add) [[ $# -eq 2 ]] || { usage; exit 1; }; cmd_add "$@" ;;
    score) [[ $# -eq 4 ]] || { usage; exit 1; }; cmd_score "$@" ;;
    narrow) [[ $# -eq 1 ]] || { usage; exit 1; }; cmd_narrow "$@" ;;
    status) [[ $# -eq 1 ]] || { usage; exit 1; }; cmd_status "$@" ;;
    winner) [[ $# -eq 1 ]] || { usage; exit 1; }; cmd_winner "$@" ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"
