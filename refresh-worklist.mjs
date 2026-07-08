#!/usr/bin/env node
// magpie refresh-worklist — reconcile the worklist against decisions.
//
// The worklist is the latest survey's ranked findings MINUS anything with a
// terminal decision (done | rejected). Accepted-but-not-done items stay (they
// are in flight); "later" items drop to the bottom. Run after recording
// decisions, or after a survey.
//
// Usage: refresh-worklist.mjs [magpie-dir]   (default: this script's dir)

import { readFileSync, writeFileSync, readdirSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'

const dir = process.argv[2] || dirname(fileURLToPath(import.meta.url))
const TOP = 12

// newest survey by filename (surveys/YYYY-MM-DD.json sorts lexically = chronologically)
const surveyDir = join(dir, 'surveys')
const latest = readdirSync(surveyDir).filter(f => f.endsWith('.json')).sort().pop()
if (!latest) { console.error('no surveys found'); process.exit(1) }
const survey = JSON.parse(readFileSync(join(surveyDir, latest), 'utf8'))

// fold decisions.json into the latest verdict per finding id
const verdict = new Map()
let decisions = []
try { decisions = JSON.parse(readFileSync(join(dir, 'decisions.json'), 'utf8')) } catch {}
for (const d of decisions) {
  if (d && d.id && d.action) verdict.set(d.id, d.action)
}

const TERMINAL = new Set(['done', 'rejected'])
const live = survey.findings.filter(f => !TERMINAL.has(verdict.get(f.id)))
// "later" sinks below undecided/accepted while keeping score order within each tier
const tier = f => (verdict.get(f.id) === 'later' ? 1 : 0)
live.sort((a, b) => tier(a) - tier(b) || b.score - a.score)

const counts = { done: 0, rejected: 0, accepted: 0, later: 0 }
for (const a of verdict.values()) if (a in counts) counts[a]++

const item = f => ({
  id: f.id, repo: f.repo, pitch: f.pitch, kind: f.kind, effort: f.effort,
  score: f.score, status: verdict.get(f.id) || 'open',
  evidence: f.evidence, confidence: f.confidence, seeAlso: f.seeAlso
})
const worklist = {
  generated: survey.generated,
  refreshed: true,
  note: 'All live survey findings (done/rejected removed), ranked. "headline" is how many the Worklist tab shows; the rest are under All. Accept/reject via decisions.json, then re-run refresh-worklist.mjs.',
  resolved: counts,
  headline: TOP,
  total: survey.findings.length,
  items: live.map(item) // full live set; the UI slices `headline` for the Worklist tab
}
writeFileSync(join(dir, 'worklist.json'), JSON.stringify(worklist, null, 1))
console.log(`worklist: ${live.length} live of ${survey.findings.length} findings ` +
  `(done ${counts.done}, rejected ${counts.rejected}, accepted ${counts.accepted}, later ${counts.later}); ` +
  `headline ${TOP}, all ${live.length} written`)
