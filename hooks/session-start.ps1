$plugin = if ($env:CLAUDE_PLUGIN_ROOT) { $env:CLAUDE_PLUGIN_ROOT } else { Split-Path -Parent $PSScriptRoot }
$root = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }

[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
[Console]::Out.Write([System.IO.File]::ReadAllText((Join-Path $plugin 'hooks/core.md')))

$runner = Join-Path $plugin 'bin/ult-run.ps1'
Write-Output "Quiet runner: powershell -NoProfile -ExecutionPolicy Bypass -File `"$runner`" '<command>'"
if (Test-Path -LiteralPath (Join-Path $root 'docs/map/README.md')) {
  Write-Output "Feature map: docs/map/README.md"
} else {
  Write-Output "No feature map in this repo. Run /ult:setup once to create it and record the check commands."
}
if (Test-Path -LiteralPath (Join-Path $root '.ult/task.md')) {
  Write-Output "Unfinished task: .ult/task.md. Read it before anything else and continue from the first unticked slice."
}
if (Test-Path -LiteralPath (Join-Path $root '.ult/grill.md')) {
  Write-Output "Unfinished interview: .ult/grill.md. Its first line names the skill; run that skill to resume from the first Open line."
}
exit 0
