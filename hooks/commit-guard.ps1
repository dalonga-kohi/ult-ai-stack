# The marker words are split so this file passes its own check.
$projectDir = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { '.' }
try { Set-Location -LiteralPath $projectDir -ErrorAction Stop } catch { exit 0 }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { exit 0 }
git rev-parse --git-dir *> $null
if ($LASTEXITCODE -ne 0) { exit 0 }

$payload = if ([Console]::IsInputRedirected) { [Console]::In.ReadToEnd() } else { '' }
if ($payload -match '--no-verify') {
  [Console]::Error.WriteLine("ult commit guard: --no-verify skips the repo's own hooks. Fix what the hook reports and commit without it.")
  exit 2
}

$diff = @(git diff --cached -U0 --no-color -- . ':(exclude)*.md' 2>$null)
if ($diff.Count -eq 0) { $diff = @(git diff HEAD -U0 --no-color -- . ':(exclude)*.md' 2>$null) }
if ($diff.Count -eq 0) { exit 0 }

$markers = '(^|[^A-Za-z])(TO' + 'DO|FIX' + 'ME|HA' + 'CK|X' + 'XX)([^A-Za-z]|$)'
$suppressions = '@ts-ig' + 'nore|@ts-expect-er' + 'ror|@ts-noch' + 'eck|eslint-dis' + 'able|#\[al' + 'low\(|//\s*nol' + 'int|type:\s*ig' + 'nore|#\s*no' + 'qa'
$pattern = "$markers|$suppressions"

$file = ''
$hits = New-Object System.Collections.Generic.List[string]
foreach ($line in $diff) {
  if ($line.StartsWith('+++ ')) { $file = $line.Substring(6); continue }
  if (-not $line.StartsWith('+')) { continue }
  $added = $line.Substring(1)
  if ($added -cmatch $pattern -and $added -notmatch '#[0-9]+|issues/[0-9]+') { $hits.Add("${file}: $added") }
}
if ($hits.Count -eq 0) { exit 0 }

[Console]::Error.WriteLine("ult commit guard: this commit adds deferral markers or suppressions:")
$hits | Select-Object -First 20 | ForEach-Object { [Console]::Error.WriteLine($_) }
[Console]::Error.WriteLine("Fix the cause, or open an issue (gh issue create) and reference its number on that line. Then commit again.")
exit 2
