---
name: magpie
description: Survey a local GitHub mirror, score every repo, and maintain a ranked worklist of things worth working on. Use when asked to survey repos, refresh the worklist, pick something to work on, or record an accept/reject decision.
---

# magpie

Magpie flies over a mirror of GitHub repos, picks out the shiny things —
work that is small, real, and valuable — and keeps a ranked worklist a
human can accept or reject. Every decision is remembered, so the picking
gets better over time.

Magpie **points, it does not dig**: it proposes work, it never executes
destructive actions, and code changes it recommends are made as branches
and pull requests by whoever accepts the item — never direct pushes.

## Where things live

Two layers, deliberately separate:

**1. The ledger (this repo)** — versioned, pushed, and served over HTTP
from the mirror (e.g. `http://localhost:5445/melvincarvalho/magpie/`):

```
worklist.json          # current ranked shortlist (the product)
surveys/YYYY-MM-DD.json # full scored output of each survey run
decisions.jsonl        # append-only human verdicts — the taste dataset
scores.json            # cached per-repo signals, diffed between runs
```

**2. The scratchpad (per repo)** — `<repo>/.git/magpie.json` inside each
mirrored repo. Files under `.git/` are never tracked, committed, or
pushed, so any repo can be annotated — including org repos the user
doesn't own — with zero risk of leaking upstream. The web server refuses
dotfile paths, so this layer is filesystem-only working state: last
survey time, computed signals, raw findings. It is a cache; it may be
lost when a clone is deleted. Anything durable belongs in the ledger.

The mirror itself defaults to `~/remote/github.com/<owner>/<repo>`,
maintained by gh-sync (see the productivity repo). Repo directory mtimes
equal the repo's last push time — that is the freshness signal, no API
calls needed. The full inventory is one fetch: the JSON embedded in
`<script id="data">` at the mirror root's `index.html`.

## Schemas

Worklist entry (`worklist.json` is `{ "generated": iso8601, "items": [...] }`):

```json
{
  "id": "jspod-seed-clobber",
  "repo": "JavaScriptSolidServer/jspod",
  "pitch": "seedPodFiles overwrites user index.html on every start — small fix, real users affected",
  "kind": "bug",
  "effort": "small",
  "score": 87,
  "signals": { "pushedDays": 3, "stars": 41, "openIssues": 7 },
  "seeAlso": [
    "http://localhost:5445/JavaScriptSolidServer/jspod/",
    "https://github.com/JavaScriptSolidServer/jspod"
  ]
}
```

`kind`: bug | feature | docs | cleanup | security | archive-candidate.
`effort`: small | medium | large. Prefer small.

Decision line (`decisions.jsonl`, append-only, one JSON object per line):

```json
{"ts":"2026-07-08T18:00:00Z","id":"jspod-seed-clobber","repo":"JavaScriptSolidServer/jspod","action":"accepted","note":"good catch, fixing today"}
```

`action`: accepted | rejected | done | later. Never rewrite or delete
lines; corrections are new lines.

Per-repo scratchpad (`.git/magpie.json`):

```json
{"surveyed":"2026-07-08T18:00:00Z","signals":{...},"findings":[...],"seeAlso":["https://github.com/<owner>/<repo>"]}
```

## Survey procedure

1. **Read taste first.** Load every line of `decisions.jsonl`. Rejected
   patterns (e.g. "README polish on dead repos") must not resurface;
   accepted patterns tell you what scores high.
2. **Inventory.** Read the mirror index JSON for the repo list and
   freshness. Do not hit the GitHub API for what the mirror already knows.
3. **Score.** Value ≈ (people affected × fix impact) / effort. Real
   signals: recent pushes, stars/forks, open issues, failing CI, TODO and
   FIXME density, broken links in READMEs, missing licenses, security
   smells. Staleness alone is NOT a finding — an untouched-for-8-years
   repo nobody uses scores near zero.
4. **Dig only where promising.** Read code in the top candidates, at
   filesystem speed, straight from the mirror. Write findings to each
   repo's `.git/magpie.json`.
5. **Write the ledger.** Full output to `surveys/<date>.json`; the top
   ~10 as `worklist.json` — each item's pitch one sentence, concrete, and
   checkable. Commit both with message `survey YYYY-MM-DD`.
6. **Budget.** A survey is read-only and bounded: stop at the configured
   number of deep reads (default 25 repos) rather than sweeping everything
   nightly; rotate cohorts between runs so the whole estate gets covered
   over time. Log what was skipped.

## Hard rules

- Propose, never execute: deletions, archivals, and force-pushes are
  worklist items for a human, not actions.
- Code changes happen on branches, delivered as PRs. Never push to a
  default branch.
- Never commit or push anything under `.git/`. Never commit magpie
  metadata into a surveyed repo's working tree.
- The mirror is read-only ground truth. Never modify surveyed repos
  during a survey.
- Respect privacy: repos marked private in the mirror must never be
  referenced in a ledger that is pushed to a public remote.
- `decisions.jsonl` is append-only, forever.
