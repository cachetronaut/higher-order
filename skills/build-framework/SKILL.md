---
name: build-framework
description: Use before designing, decomposing, or reviewing any agent, automation, MCP tool, or multi-step backend process.
---

# Contract-First — Define the JSON Before Building
## Purpose

>IMPORTANT: YOU MUST organize the work as contracts before choosing tools, recipes, or prompts. 
- Every agent or automation is to have a contract-based, JSON flow. 
- Each step is a function with the following shape: expected input → process → expected output. 
- Implementation follows the contracts diligently.

## Apply the contract-first loop internally

Walk these checks before any work. They structure reasoning and should be reflected in technical design documents when asked, but are not the immediate user-facing format.
### 1 — Output contract first

- Name the concrete JSON the step must produce for its consumer. 
- Prefer an outcome shape over an activity.

>Ask: who reads this output, and what decision or write does it unlock? If the consumer is unclear, stop and name them.
### 2 — Input contract second

- Name the exact JSON the step requires. 
- Mark each field `MUST` / `SHOULD` / `COULD` / `WONT`. 
- Keep administrative scalars separate from evidence-wrapped values so a failed read is clearly distinguishable from an absent value.

>Ask: what must be present to run safely, and what does a silent result mean (absent fact vs unread vs not attempted).
### 3 — Process between the contracts

- Describe only the transform that turns the input contract into the output contract. 
- Prefer deterministic logic based on data in hand. 
- Retrieve additional data only when the logic cannot decide. 
- Use a model only for free-text interpretation; scripts and rules emit the verdict, the model decides among allowed fields and does not invent ladder words.

>Ask: what is pure (same JSON in → same JSON out), and what is an external effect that must be recorded?
### 4 — Envelope every step

- Wrap request and response in one versioned envelope; minimum response shape:

```json
{
	"contractVersion": "1.0",
	"componentId": "FUN-007",
	"requestId": "req_…",
	"runId": "run_…",
	"status": "succeeded",
	"result": {},
	"errors": [],
	"trace": {
		"startedAtUtc": "…",
		"completedAtUtc": "…",
		"policyVersions": {},
		"steps": []
	}
}
```

- `status` is `succeeded`, `partial`, or `failed`. 
- Errors carry `code`, `message`, and `retryable`. 
- Never hide failure inside a pass. 
- Number components consistently (`FUN-NNN`, matching `SKL-NNN` / `API-NNN` when those adapters exist). 
- Function owns data and decisions; skill owns selection and presentation; endpoint owns HTTP.
### 5 — Preflight is Step 0

- Before any body work, define a preflight contract: well-formed ids, in-scope or adjudicable state, auth, and required sources available. 
- Preflight failure is a hard gate and returns a structured reject or hand-back; it does not continue on to write.
### 6 — READ → PROCESS → WRITE as step kinds

- Decompose the end-to-end flow into ordered step functions. Prefer this spine:
	1. `PROCESS` — pure or mostly pure transform against the contracts; record evidence.
	2. `READ` — fetch and shape inputs; no domain verdict; no side-effecting write.
	3. `WRITE` — only after contracts and gates succeed; never on exception or doubt.
- Each step publishes its own input and output contracts.  
- Compose by joining child envelopes; retain every child terminal state.  
- Do not omit a failed child or coerce it into a pass.  
- Stay on the happy lane (cheap deterministic checks) and escalate only when more work is required—never the reverse.
	- Escalations should be made in order of highest probable outcome
	- Risk thresholds should be established when it is safe to jump to a less probably step vs. exiting cleanly for human review

>Keep each step LEAN; load per-step references and schemas on demand and only if required.
### 7 — Exceptions are contract outcomes

- Any error, unread source, ambiguity, or doubt maps to a declared outcome:
	- `failed`
	- `partial`
	- `unavailable`
	- `unknown`
	- `must_read`
	- `human_exception`
- When the pipeline can write, exception paths do not write; they defer to humans to decide what, when, where, and how to write. 
- Incomplete work must not be confused for completed work.
### 8 — Contracts drive tests and scorecards

- Schemas plus positive and negative examples are the test oracle. 
- Validate payloads; never coerce. 
- Replay against decided cases before claiming Done. 
- Score each run per step against a human-completed baseline:

|Result|Score|
|---|---|
|Matches expected|1|
|Wrong|0|
|Ambiguous|0.5|
|Missing capability|exclude from denominator|
## Checklist before building

- [ ]  Hard stops / gates
- [ ]  Input JSON named; silence and unread distinguished
- [ ]  Output JSON named, versioned, and owned by a single clear consumer
- [ ]  Process is input→output only; side effects recorded
- [ ]  Envelope fields and status vocabulary fixed
- [ ]  Steps ordered READ → PROCESS → WRITE; happy lane first
- [ ]  Exceptions are declared outcomes routed to a human when needed
- [ ]  Schema + positive and negative examples exist
- [ ]  Scorecard and replay set defined before claiming Done
## Coordinate with related skills

- Complete `pause-framework` and `success-criteria` first when those skills apply. 
- Contract-first supplies the JSON completion contract those frameworks leave open. 
- Follow repository `DESIGN.md` / `CONTRACTS.md` for domain rules; cite them—do not copy thresholds or IDs into code.
