#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Single entry point for all checks — any language, any framework.
# Agents and CI only ever call this script; they never call npm, composer,
# pip, cargo… directly. The architect fills in the functions below during
# Foundation, using the matching rule pack in docs/stack-rules/.
#
# Usage:  bash scripts/check.sh [install|lint|types|test|build|all]
#         ("all" = lint + types + test + build; run "install" first)
# Windows: run from Git Bash or WSL.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail
cd "$(dirname "$0")/.."

# Set to true once the stack is approved and every command below is filled in.
# While false, all commands skip (so CI stays green before Foundation).
CONFIGURED=false

# ── Fill these in (examples in docs/stack-rules/<pack>.md) ───────────────────
install() { todo install; }
lint()    { todo lint; }
types()   { todo types; }
test_()   { todo test; }
build()   { todo build; }
# ─────────────────────────────────────────────────────────────────────────────

# A command that is not filled in fails once CONFIGURED=true.
todo() { echo "✗ '$1' is not configured — the architect must set it in scripts/check.sh (see docs/stack.md)."; return 1; }

# Use for a command that genuinely doesn't apply, with the reason.
# Every skip must also be listed under "Skipped commands" in docs/stack.md.
skip() { echo "– '$1' skipped: $2"; }

step() { echo; echo "▶ $1"; }

if [ "$CONFIGURED" != "true" ]; then
  echo "Stack not set up yet (CONFIGURED=false in scripts/check.sh) — skipping '${1:-all}'."
  exit 0
fi

case "${1:-all}" in
  install) step install; install ;;
  lint)    step lint;    lint ;;
  types)   step types;   types ;;
  test)    step test;    test_ ;;
  build)   step build;   build ;;
  all)     step lint;  lint
           step types; types
           step test;  test_
           step build; build
           echo; echo "✓ all checks passed" ;;
  *) echo "Usage: bash scripts/check.sh [install|lint|types|test|build|all]"; exit 2 ;;
esac
