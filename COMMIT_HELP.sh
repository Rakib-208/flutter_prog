# 1) See the staged diff for main.dart
git --no-pager diff --staged -- lib/main.dart

# 2) If a previous git commit process is hung, cancel it with Ctrl+C in the terminal.

# 3) List hook files to see if a pre-commit hook exists
ls -la .git/hooks

# 4) Inspect the pre-commit hook if present (PowerShell or Bash)
# PowerShell:
Get-Content .git/hooks/pre-commit -ErrorAction SilentlyContinue
# Bash:
cat .git/hooks/pre-commit 2>/dev/null || true

# 5) Try committing while bypassing hooks (fast way if hooks hang)
git commit --no-verify -m "Remove default comments from main.dart"

# 6) If the commit still hangs, run with trace to get debug output.
# Bash:
GIT_TRACE=1 GIT_TRACE_PACKET=1 GIT_TRACE_PACK_ACCESS=1 git commit -m "Remove default comments from main.dart"
# PowerShell:
$env:GIT_TRACE=1; $env:GIT_TRACE_PACKET=1; $env:GIT_TRACE_PACK_ACCESS=1; git commit -m "Remove default comments from main.dart"

# 7) If commit succeeds, push:
git push

# 8) If problems persist, gather repo diagnostics:
git count-objects -vH
# On Windows (PowerShell) to see .git size:
Get-ChildItem -Recurse .git | Measure-Object -Property Length -Sum

# 9) See running git processes (if suspected stuck process)
# Bash:
ps aux | grep git
# PowerShell:
Get-Process *git* -ErrorAction SilentlyContinue
