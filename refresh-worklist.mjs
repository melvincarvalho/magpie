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

// Fold decisions.json into two independent axes per finding:
//   action   = lifecycle (accepted | rejected | done)   -> filtering + status
//   priority = ordering  (pin | later)                  -> which tier it sorts into
// They are orthogonal: pinning something does not change its lifecycle status.
const verdict = new Map()
const priority = new Map()
let decisions = []
try { decisions = JSON.parse(readFileSync(join(dir, 'decisions.json'), 'utf8')) } catch {}
for (const d of decisions) {
  if (!d || !d.id) continue
  if (d.action) verdict.set(d.id, d.action)
  if (d.priority) priority.set(d.id, d.priority)
}

const TERMINAL = new Set(['done', 'rejected'])
const live = survey.findings.filter(f => !TERMINAL.has(verdict.get(f.id)))
// pin floats to the top, later sinks to the bottom; score orders within each tier
const PRI = { pin: 0, later: 2 }
const tier = f => (PRI[priority.get(f.id)] ?? 1)
live.sort((a, b) => tier(a) - tier(b) || b.score - a.score)

const counts = { done: 0, rejected: 0, accepted: 0 }
for (const a of verdict.values()) if (a in counts) counts[a]++
const pri = { pin: 0, later: 0 }
for (const p of priority.values()) if (p in pri) pri[p]++

const item = f => ({
  id: f.id, repo: f.repo, pitch: f.pitch, kind: f.kind, effort: f.effort,
  score: f.score, status: verdict.get(f.id) || 'open',
  priority: priority.get(f.id) || null,
  evidence: f.evidence, confidence: f.confidence, seeAlso: f.seeAlso
})
const worklist = {
  generated: survey.generated,
  refreshed: true,
  note: 'All live survey findings (done/rejected removed), ranked. "headline" is how many the Worklist tab shows; the rest are under All. Accept/reject via decisions.json, then re-run refresh-worklist.mjs.',
  resolved: counts,
  pinned: pri.pin,
  deferred: pri.later,
  headline: TOP,
  total: survey.findings.length,
  items: live.map(item) // full live set; the UI slices `headline` for the Worklist tab
}
writeFileSync(join(dir, 'worklist.json'), JSON.stringify(worklist, null, 1))
console.log(`worklist: ${live.length} live of ${survey.findings.length} findings ` +
  `(done ${counts.done}, rejected ${counts.rejected}, accepted ${counts.accepted}; ` +
  `pinned ${pri.pin}, later ${pri.later}); headline ${TOP}, all ${live.length} written`)
