# magpie

> Surveys a local GitHub mirror and picks the shiny things worth working on.

Magpie flies over a mirror of your repos (see
[gh-sync](https://github.com/melvincarvalho/productivity)), scores what it
finds, and keeps a ranked worklist you accept or reject. Decisions are
remembered forever — the picking learns your taste.

Magpie points, it doesn't dig: it proposes work; humans (or agents you
authorise) do it, on branches, as PRs.

## The convention

Everything is defined in [SKILL.md](SKILL.md) — data layout, schemas,
survey procedure, and hard rules. Drop it in your agent's skill directory
and any capable agent can run a survey or record decisions.

## Ledger

- `worklist.json` — the current ranked shortlist
- `surveys/` — full output of every survey run
- `decisions.jsonl` — append-only human verdicts (the taste dataset)

## Install

```sh
npm install getmagpie
```

Status: v0.0.1 — the convention and constants; the survey CLI is next.

## License

MIT
