#!/usr/bin/env bash
# ============================================================
# magpie — archive-actions.sh   (generated 2026-07-09)
# Reviewable command list to reduce the GitHub footprint.
# Source of truth: melvincarvalho/magpie/archive-review.json
#
# SAFETY: DRY-RUN by default — prints what it WOULD do, changes nothing.
#   ./archive-actions.sh                 # dry run (safe, default)
#   ./archive-actions.sh --go            # run BUCKET 1 (archive, reversible)
#   ./archive-actions.sh --go --delete   # also run BUCKET 2 (DELETE, permanent)
# BUCKET 3 (transfer/leave) is never auto-run — manual, see notes at bottom.
#
# Requires: gh auth status  (GitHub CLI, authenticated; delete needs delete_repo scope)
# Archiving is reversible: gh repo unarchive owner/repo. Deleting is NOT.
# ============================================================
set -uo pipefail
RUN=0; DODEL=0
for a in "$@"; do [ "$a" = "--go" ] && RUN=1; [ "$a" = "--delete" ] && DODEL=1; done
arch(){ if [ "$RUN" = 1 ]; then gh repo archive "$1" --yes; else echo "DRY archive : $1"; fi; }
del(){ if [ "$RUN" = 1 ] && [ "$DODEL" = 1 ]; then gh repo delete "$1" --yes; else echo "DRY DELETE  : $1  (needs --go --delete)"; fi; }
echo
echo "=== BUCKET 1: ARCHIVE — 93 repos, reversible (default action) ==="
arch "bitcoincc/bitcoin.cc"   # empty stub for a bitcoin/lightning website
arch "daoever/daoever"   # empty 'daoever' stub repo
arch "gitpay/sales"   # empty gitpay sales placeholder repo
arch "linkeddata/gold-misc"   # deployment/ops scripts for the gold linked-data server
arch "linkeddata/solid-app-set-archive"   # graveyard for panes removed from solid-app-set
arch "mark-book/bookmark-pane"   # empty stub for a solid-panes bookmark applet
arch "melbotz/melbot_20220705"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220706"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220707"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220708"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220709"   # dated daily snapshot of melbot (npm-published)
arch "melbotz/melbot_20220710"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220711"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220712"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220713"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220714"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220715"   # dated daily snapshot of melbot
arch "melbotz/melbot_20220716"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220717"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220718"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220719"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220720"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220721"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220722"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220723"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220724"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220725"   # dated daily snapshot of melbot autonomous agent
arch "melbotz/melbot_20220726"   # dated daily snapshot of melbot autonomous agent
arch "melvincarvalho/bots"   # empty 'solid bots' stub repo
arch "melvincarvalho/chat"   # standalone RDF chat-log viewer (chat.html)
arch "melvincarvalho/docs"   # empty generic docs placeholder
arch "melvincarvalho/elgg"   # 2010 single-commit GNU Social/Elgg test-instance code dump
arch "melvincarvalho/extractors"   # 'solid extractors' README stub
arch "melvincarvalho/inbox"   # 'solid inbox' README stub
arch "melvincarvalho/klaranet"   # Personal customized Hubot bot deployment
arch "melvincarvalho/markbot"   # Prototype IRC bot that rewards users with crypto
arch "melvincarvalho/rdf-libraries"   # throwaway experiment for testing RDF libraries
arch "melvincarvalho/rwwcoin"   # Placeholder README for a test read-write-web coin
arch "melvincarvalho/scaffold"   # vendored AdminLTE (admin-lte) admin template snapshot
arch "melvincarvalho/search"   # 'solid search' README stub
arch "melvincarvalho/searx"   # empty placeholder for a searx app
arch "melvincarvalho/solid.community"   # empty stub for solid.community utils
arch "play-grounds/bitmark"   # bitmark playground experiment stub
arch "play-grounds/liquid"   # liquid playground experiment stub
arch "play-grounds/slidev"   # slidev playground experiment stub
arch "play-grounds/tailwind"   # tailwind playground experiment stub
arch "play-grounds/vite"   # empty Vite playground scaffold (README+LICENSE only, 1 commit)
arch "project-bitmark/code-of-conduct"   # boilerplate community code-of-conduct doc
arch "project-bitmark/documents"   # Repository of project PDFs and documents
arch "project-bitmark/quickapi"   # PHP cached API to dump bitmark daemon data
arch "quantumpayments/ads"   # empty 'ads with payments' stub
arch "quantumpayments/bash"   # bash/.bashrc hooks to trigger payments from the shell prompt
arch "quantumpayments/bitmark"   # placeholder for bitmark integration
arch "quantumpayments/bubble"   # shell-script ledger rebalancing experiment
arch "quantumpayments/gitpay"   # placeholder for paying over git
arch "quantumpayments/hook"   # bash snippet to run a hook after a payment
arch "quantumpayments/inartes"   # placeholder for art payments
arch "quantumpayments/interledger"   # placeholder repo for interledger payments
arch "quantumpayments/master_slave"   # notes on master/slave data replication for wallets
arch "quantumpayments/monitor"   # empty payments-trigger experiment stub
arch "quantumpayments/mysql"   # empty 'trigger payment from mysql' stub
arch "quantumpayments/paymentchannel"   # placeholder for off-ledger payment channels
arch "quantumpayments/paywall"   # empty 'pay for access' paywall stub
arch "quantumpayments/points"   # points-system concept note (README only)
arch "quantumpayments/quantumpayments.org"   # placeholder for the quantumpayments website
arch "quantumpayments/taskify"   # placeholder for task payments
arch "rww-apps/helloworld"   # Hello-world read-write-web demo app
arch "solid-community/scripts"   # one-off pod maintenance shell script
arch "solid-live/app"   # empty stub for Solid Live as an app
arch "solid-live/code-of-conduct"   # boilerplate community code-of-conduct doc
arch "solid-live/extension"   # empty stub for a Solid Live browser extension
arch "solid-live/invites"   # placeholder repo for solid-live invites with a gitter badge
arch "solid/communication"   # Solid communication/social-media strategy notes
arch "solid/education"   # Solid education/course materials collation repo
arch "solid/research-topics"   # curated list of Solid research topics with PDFs
arch "solidpayorg/node-lnbits"   # stub CLI tool for lnbits
arch "spux/docs"   # boilerplate Docusaurus/Vercel example site
arch "spux/info"   # empty 'info and docs' stub
arch "spux/realtime"   # empty 'realtime' stub
arch "spux/spux-util"   # empty 'spux util' stub
arch "taskify/taskify-bots"   # empty placeholder for Taskify bots
arch "taskify/taskify-data"   # empty placeholder for a Taskify data server
arch "taskify/taskify-drivers"   # empty placeholder for Taskify drivers/integrations
arch "taskify/taskify-hub"   # empty placeholder for a Taskify search portal/hub
arch "unhosted/design"   # static design-asset dump (PSDs, stickers, t-shirts) for the unhosted m
arch "unhosted/dns-scripts"   # Shell scripts to manage DNS zones for un.ht
arch "unhosted/gd-proxy"   # Google Docs proxy server (node)
arch "unhosted/nsupdate-proxy"   # Node.js nsupdate proxy for un.ht DNS
arch "unhosted/remoteCouch"   # nodejs proxy in front of a CouchDB instance
arch "unhosted/unht-diagrams"   # Dia diagram files for un.ht signup flow
arch "webcredits/wc_api"   # empty placeholder for a webcredits API
arch "webcredits/wc_authentication"   # empty webcredits WebID/TLS auth stub
arch "wondersearch/wondersearch"   # empty stub for a wondersearch JS module
echo
echo "=== BUCKET 2: DELETE — 15 repos, PERMANENT (empty 1-2 commit stubs only) ==="
del "DesignIssues/designissues"   # commits=2 files=1 — pointer stub linking to the canonical W3C DesignIssues 
del "dacse/dacse.org"   # commits=1 files=2 — empty stub for the dacse.org website
del "linkeddata/goturtle"   # commits=1 files=1 — single-file Turtle EBNF grammar snapshot
del "linkeddata/widgets-acl"   # commits=2 files=2 — Solid ACL management widget experiment
del "melvincarvalho/brain"   # commits=1 files=3 — empty stub for brain-wallet misc
del "melvincarvalho/lget"   # commits=1 files=2 — empty 'linked data get' stub (README+LICENSE only)
del "melvincarvalho/newmachine"   # commits=2 files=1 — personal new-machine setup checklist
del "melvincarvalho/react-brain"   # commits=1 files=1 — react brain-wallet experiment
del "melvincarvalho/solid-ipfs"   # commits=1 files=2 — empty stub for solid/ipfs integration experiment
del "melvincarvalho/watch"   # commits=1 files=2 — empty stub for watch interaction code
del "project-bitmark/muwa-core"   # commits=1 files=1 — empty muwa-core stub
del "quantumpayments/lightning"   # commits=1 files=1 — empty stub for a lightning network implementation
del "solid-live/WorldWideWeb"   # commits=1 files=2 — empty aspirational 'browser' stub (README only)
del "solidpayorg/brain"   # commits=1 files=2 — empty stub for brain-wallet utils
del "spux/spux-todomvc"   # commits=1 files=2 — empty TodoMVC-in-Spux demo scaffold
echo
echo "=== BUCKET 3: TRANSFER / LEAVE — 3 repos, MANUAL (others code / not solely yours) ==="
# linkeddata/midichlorian — externally authored (Amy Guy), live homepage apps.rhiaro.co.uk
#   TRANSFER to rhiaro:  gh api -X POST repos/linkeddata/midichlorian/transfer -f new_owner=rhiaro
# w3c-social/social-web — W3C-affiliated org, "unofficial" WG tracker — org decision, not solely yours
#   LEAVE as-is (org-level decision), or remove yourself as owner.
# spux/me — ambiguous account ownership — confirm you control the spux account first
#   VERIFY you control this account/org before any action.
echo
echo "Dry run complete. Re-run with --go to archive, --go --delete to also delete."
