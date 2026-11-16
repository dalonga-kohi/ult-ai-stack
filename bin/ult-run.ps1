param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Command)

if (-not $Command) {
  [Console]::Error.WriteLine("usage: ult-run.ps1 <command>   (one quoted string runs as PowerShell)")
  exit 64
}

$base = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }
$dir = Join-Path (Join-Path $base '.ult') 'logs'
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$log = Join-Path $dir ("{0}-{1}.log" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $PID)
Get-ChildItem -Path $dir -Filter *.log | Sort-Object LastWriteTime -Descending | Select-Object -Skip 19 | Remove-Item -Force
$tail = if ($env:ULT_TAIL) { [int]$env:ULT_TAIL } else { 40 }

if ($Command.Count -eq 1) {
  $body = $Command[0]
} else {
  $body = '& ' + (($Command | ForEach-Object { "'" + ($_ -replace "'", "''") + "'" }) -join ' ')
}

$child = @"
`$ProgressPreference = 'SilentlyContinue'
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding(`$false)
`$global:LASTEXITCODE = 0
`$global:ultErrors = 0
try {
  & {
$body
  } *>&1 | ForEach-Object {
    if (`$_ -is [System.Management.Automation.ErrorRecord] -and `$_.FullyQualifiedErrorId -notlike 'NativeCommandError*') { `$global:ultErrors++ }
    "`$_"
  }
} catch {
  "`$_"
  exit 1
}
if (`$LASTEXITCODE) { exit `$LASTEXITCODE }
if (`$global:ultErrors) { exit 1 }
exit 0
"@

$encoded = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($child))
$shell = (Get-Process -Id $PID).Path
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
$writer = New-Object System.IO.StreamWriter($log, $false, (New-Object System.Text.UTF8Encoding($false)))
$watch = [System.Diagnostics.Stopwatch]::StartNew()
try {
  & $shell -NoProfile -OutputFormat Text -EncodedCommand $encoded 2>&1 | ForEach-Object { $writer.WriteLine("$_") }
  $code = $LASTEXITCODE
} finally {
  $writer.Dispose()
}
$took = [int]$watch.Elapsed.TotalSeconds
$lines = @(Get-Content -LiteralPath $log).Count

if ($code -eq 0) {
  Write-Output "PASS ${took}s, $lines lines of output in $log"
} else {
  Write-Output "FAIL exit $code, ${took}s. Last $tail of $lines lines (full log: $log):"
  Get-Content -LiteralPath $log -Tail $tail
}
exit $code
