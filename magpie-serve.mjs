#!/usr/bin/env node
// magpie-serve.mjs — tiny localhost write endpoint for magpie decisions.
//
// The mirror server is read-only by design (it serves private repos), so it
// can't take writes. This sidecar is the ONLY writer of decisions.json: it
// appends one entry (append-only) and regenerates worklist.json by running
// refresh-worklist.mjs — the same fold the CLI uses, so there is one source
// of truth. Bound to 127.0.0.1 only: single-user, local, no auth needed.
//
// Usage: magpie-serve.mjs   (port via MAGPIE_PORT, default 5446)

import { createServer } from 'http'
import { readFileSync, writeFileSync } from 'fs'
import { execFile } from 'child_process'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const dir = dirname(fileURLToPath(import.meta.url))
const DECISIONS = join(dir, 'decisions.json')
const WORKLIST = join(dir, 'worklist.json')
const REFRESH = join(dir, 'refresh-worklist.mjs')
const PORT = Number(process.env.MAGPIE_PORT) || 5446

const ACTIONS = new Set(['accepted', 'rejected', 'done'])
const PRIORITIES = new Set(['pin', 'later', 'normal']) // 'normal' clears a prior pin/later

function cors (res) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')
}

const refresh = () => new Promise((resolve, reject) =>
  execFile(process.execPath, [REFRESH], err => err ? reject(err) : resolve()))

createServer((req, res) => {
  cors(res)
  if (req.method === 'OPTIONS') { res.writeHead(204); return res.end() }
  if (req.method === 'GET' && req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' })
    return res.end('{"ok":true}')
  }
  if (req.method === 'POST' && req.url === '/decision') {
    let body = ''
    req.on('data', c => { body += c; if (body.length > 100000) req.destroy() })
    req.on('end', async () => {
      try {
        const d = JSON.parse(body)
        if (!d.id || typeof d.id !== 'string') throw new Error('id required')
        if (d.action && !ACTIONS.has(d.action)) throw new Error('bad action')
        if (d.priority && !PRIORITIES.has(d.priority)) throw new Error('bad priority')
        if (!d.action && !d.priority) throw new Error('action or priority required')
        const entry = { ts: new Date().toISOString(), id: d.id }
        if (d.repo) entry.repo = String(d.repo).slice(0, 200)
        if (d.action) entry.action = d.action
        if (d.priority) entry.priority = d.priority
        if (d.note) entry.note = String(d.note).slice(0, 500)
        const arr = JSON.parse(readFileSync(DECISIONS, 'utf8'))
        arr.push(entry)
        writeFileSync(DECISIONS, JSON.stringify(arr, null, 1) + '\n')
        await refresh()
        res.writeHead(200, { 'Content-Type': 'application/json' })
        res.end(readFileSync(WORKLIST, 'utf8'))
      } catch (e) {
        res.writeHead(400, { 'Content-Type': 'application/json' })
        res.end(JSON.stringify({ error: String(e && e.message || e) }))
      }
    })
    return
  }
  res.writeHead(404); res.end()
}).listen(PORT, '127.0.0.1', () => console.log('magpie-serve on http://127.0.0.1:' + PORT))
