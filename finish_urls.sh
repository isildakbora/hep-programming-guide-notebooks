#!/usr/bin/env bash
# Run Codex (with network) to fix/verify data URLs, then validate and push. Log: finish_urls.log
cd "$(dirname "$0")"
{
perl -e 'alarm 5400; exec @ARGV' codex exec --skip-git-repo-check --ephemeral -m gpt-6-sol -c model_reasoning_effort=high \
  -s workspace-write -c sandbox_workspace_write.network_access=true -C "$PWD" -o urls_report.md -- "$(cat TASK_urls.md)" </dev/null >/dev/null 2>urls.err
echo "== codex exit $?"; cat urls_report.md
echo "== git diff --stat"; git diff --stat
if python3 publish.py; then echo "== PUSHED"; else echo "== NOT PUSHED"; fi
} > finish_urls.log 2>&1
