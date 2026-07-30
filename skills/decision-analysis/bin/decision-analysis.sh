#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  decision-analysis.sh init DIR GOAL_FILE CONSTRAINTS_FILE
  decision-analysis.sh add DIR "Candidate sentence."
  decision-analysis.sh score DIR ID SCORE "Rationale"
  decision-analysis.sh rank DIR
  decision-analysis.sh status DIR
  decision-analysis.sh winner DIR
USAGE
}

fail() {
  echo "decision-analysis.sh: $*" >&2
  exit 1
}

require_dir() {
  local decision_dir="$1"
  [[ -d "$decision_dir" ]] || fail "missing decision directory: $decision_dir"
}

next_id() {
  local candidates_file="$1"
  if [[ ! -s "$candidates_file" ]]; then
    echo 1
  else
    awk -F '\t' 'max < $1 { max = $1 } END { print max + 1 }' "$candidates_file"
  fi
}

cmd_init() {
  local decision_dir="$1"
  local goal_file="$2"
  local constraints_file="$3"
  [[ -f "$goal_file" ]] || fail "goal file not found: $goal_file"
  [[ -f "$constraints_file" ]] || fail "constraints file not found: $constraints_file"
  [[ ! -e "$decision_dir" ]] || fail "decision directory already exists: $decision_dir"
  mkdir -p "$decision_dir"
  cp "$goal_file" "$decision_dir/goal.md"
  cp "$constraints_file" "$decision_dir/constraints.md"
  : > "$decision_dir/candidates.tsv"
  : > "$decision_dir/scores.tsv"
  : > "$decision_dir/ranking.tsv"
  echo "Initialized decision record: $decision_dir"
}

cmd_add() {
  local decision_dir="$1"
  local sentence="$2"
  require_dir "$decision_dir"
  [[ "$sentence" == *.* || "$sentence" == *\? || "$sentence" == *! ]] ||
    fail "candidate must be a sentence ending in punctuation"
  [[ "$sentence" != *$'\n'* && "$sentence" != *$'\t'* ]] ||
    fail "candidate cannot contain tabs or newlines"

  local candidate_id
  candidate_id=$(next_id "$decision_dir/candidates.tsv")
  printf '%s\t%s\n' "$candidate_id" "$sentence" >> "$decision_dir/candidates.tsv"
  : > "$decision_dir/ranking.tsv"
  echo "Added candidate $candidate_id"
}

cmd_score() {
  local decision_dir="$1"
  local candidate_id="$2"
  local score="$3"
  local rationale="$4"
  require_dir "$decision_dir"
  [[ "$candidate_id" =~ ^[0-9]+$ ]] || fail "id must be a whole number"
  [[ "$score" =~ ^[0-9]+$ ]] || fail "score must be a whole number from 0 to 100"
  (( score >= 0 && score <= 100 )) || fail "score must be between 0 and 100"
  grep -q "^${candidate_id}"$'\t' "$decision_dir/candidates.tsv" ||
    fail "candidate $candidate_id does not exist"
  [[ "$rationale" != *$'\n'* && "$rationale" != *$'\t'* ]] ||
    fail "rationale cannot contain tabs or newlines"

  awk -F '\t' -v candidate_id="$candidate_id" '$1 != candidate_id' \
    "$decision_dir/scores.tsv" > "$decision_dir/scores.tsv.tmp"
  mv "$decision_dir/scores.tsv.tmp" "$decision_dir/scores.tsv"
  printf '%s\t%s\t%s\n' "$candidate_id" "$score" "$rationale" >> "$decision_dir/scores.tsv"
  : > "$decision_dir/ranking.tsv"
  echo "Scored candidate $candidate_id = $score"
}

cmd_rank() {
  local decision_dir="$1"
  require_dir "$decision_dir"

  local candidate_count
  local scored_count
  candidate_count=$(wc -l < "$decision_dir/candidates.tsv" | tr -d ' ')
  (( candidate_count >= 2 )) || fail "ranking requires at least two candidates"
  scored_count=$(awk -F '\t' '{ print $1 }' "$decision_dir/scores.tsv" |
    sort -n | uniq | wc -l | tr -d ' ')
  (( scored_count == candidate_count )) ||
    fail "ranking requires scores for all $candidate_count candidates; found $scored_count"

  awk -F '\t' '
    FNR == NR {
      score[$1] = $2
      rationale[$1] = $3
      next
    }
    $1 in score {
      print $1 "\t" $2 "\t" score[$1] "\t" rationale[$1]
    }
  ' "$decision_dir/scores.tsv" "$decision_dir/candidates.tsv" |
    sort -t $'\t' -k3,3nr -k1,1n > "$decision_dir/ranking.tsv"

  echo "Ranked $candidate_count candidates"
}

cmd_status() {
  local decision_dir="$1"
  require_dir "$decision_dir"
  echo "Goal:"
  sed 's/^/  /' "$decision_dir/goal.md"
  echo
  echo "Constraints:"
  sed 's/^/  /' "$decision_dir/constraints.md"
  echo
  echo "Candidates:"
  if [[ -s "$decision_dir/candidates.tsv" ]]; then
    awk -F '\t' '{ printf "  %s. %s\n", $1, $2 }' "$decision_dir/candidates.tsv"
  else
    echo "  none"
  fi
  echo
  echo "Ranking:"
  if [[ -s "$decision_dir/ranking.tsv" ]]; then
    awk -F '\t' '{ printf "  %s. score %s - %s (%s)\n", $1, $3, $2, $4 }' \
      "$decision_dir/ranking.tsv"
  else
    echo "  not generated"
  fi
}

cmd_winner() {
  local decision_dir="$1"
  require_dir "$decision_dir"
  [[ -s "$decision_dir/ranking.tsv" ]] || fail "run rank before requesting a winner"
  awk -F '\t' 'NR == 1 { printf "Winner: %s. %s (score %s - %s)\n", $1, $2, $3, $4 }' \
    "$decision_dir/ranking.tsv"
}

main() {
  [[ $# -ge 1 ]] || {
    usage
    exit 1
  }

  local command_name="$1"
  shift
  case "$command_name" in
    init) [[ $# -eq 3 ]] || { usage; exit 1; }; cmd_init "$@" ;;
    add) [[ $# -eq 2 ]] || { usage; exit 1; }; cmd_add "$@" ;;
    score) [[ $# -eq 4 ]] || { usage; exit 1; }; cmd_score "$@" ;;
    rank) [[ $# -eq 1 ]] || { usage; exit 1; }; cmd_rank "$@" ;;
    status) [[ $# -eq 1 ]] || { usage; exit 1; }; cmd_status "$@" ;;
    winner) [[ $# -eq 1 ]] || { usage; exit 1; }; cmd_winner "$@" ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"
