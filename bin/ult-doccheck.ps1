param([string]$Dir = 'docs/map')

$root = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }
Set-Location -LiteralPath $root
if (-not (Test-Path -LiteralPath $Dir -PathType Container)) {
  Write-Output "SKIP no $Dir"
  exit 0
}

$script:checked = 0
$script:broken = 0
function Broke([string]$Text) {
  Write-Output "BROKEN $Text"
  $script:broken++
}

function Test-DocPath([string]$Span) {
  if ($Span -match '[\s<>*{}$:|()=,]') { return $false }
  if ($Span -match '^(/|~|\.ult/|-)') { return $false }
  return $Span.Contains('/')
}

$base = (Resolve-Path -LiteralPath $root).Path
$files = Get-ChildItem -LiteralPath $Dir -Filter *.md -Recurse -File | Sort-Object FullName
foreach ($item in $files) {
  $f = $item.FullName.Substring($base.Length).TrimStart('\', '/') -replace '\\', '/'
  $n = 0
  $fence = $false
  foreach ($line in [System.IO.File]::ReadAllLines($item.FullName)) {
    $n++
    if ($line.StartsWith('```')) { $fence = -not $fence; continue }
    if ($fence) { continue }
    $file = ''
    $end = 0
    foreach ($m in [regex]::Matches($line, '`([^`]+)`')) {
      $gap = $line.Substring($end, $m.Index - $end)
      $end = $m.Index + $m.Length
      $span = $m.Groups[1].Value
      if ($file -and $gap -eq ' ' -and $span -match '^[A-Za-z_][A-Za-z0-9_]*$') {
        $script:checked++
        if (-not (Select-String -LiteralPath $file -SimpleMatch -CaseSensitive -Pattern $span -Quiet)) {
          Broke "${f}:$n ``$span`` not found in ``$file``"
        }
        $file = ''
        continue
      }
      $file = ''
      if (Test-DocPath $span) {
        $script:checked++
        $p = $span.TrimEnd('/')
        if (-not (Test-Path -LiteralPath $p)) {
          Broke "${f}:$n missing path ``$span``"
        } elseif (Test-Path -LiteralPath $p -PathType Leaf) {
          $file = $span
        }
      }
    }
    foreach ($m in [regex]::Matches($line, '\]\(([^)]+)\)')) {
      $target = ($m.Groups[1].Value -split '#')[0]
      if (-not $target -or $target.Contains(':')) { continue }
      $script:checked++
      if (-not (Test-Path -LiteralPath (Join-Path $item.DirectoryName $target))) {
        Broke "${f}:$n missing link ``$target``"
      }
    }
  }
}

if ($script:broken -eq 0) {
  Write-Output "PASS $($script:checked) pointers in $Dir"
  exit 0
}
Write-Output "FAIL $($script:broken) of $($script:checked) pointers in $Dir are broken"
exit 1
