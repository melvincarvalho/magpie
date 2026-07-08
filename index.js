// magpie — surveys a local GitHub mirror and picks the shiny things
// worth working on. The convention lives in SKILL.md; this module
// exports the shared constants and will grow the survey/decision API.

export const VERSION = '0.0.1'

export const LEDGER = {
  worklist: 'worklist.json',
  surveys: 'surveys/',
  decisions: 'decisions.jsonl',
  scores: 'scores.json'
}

export const SCRATCHPAD = '.git/magpie.json'

export const KINDS = ['bug', 'feature', 'docs', 'cleanup', 'security', 'archive-candidate']
export const ACTIONS = ['accepted', 'rejected', 'done', 'later']
