$ErrorActionPreference = 'Stop'

$requiredTools = @(
    'iverilog',
    'vvp',
    'gtkwave'
)

$missing = @()
$found = @()

foreach ($tool in $requiredTools) {
    $cmd = Get-Command $tool -ErrorAction SilentlyContinue
    if ($null -eq $cmd) {
        $missing += $tool
    } else {
        $found += [PSCustomObject]@{
            Tool = $tool
            Path = $cmd.Source
        }
    }
}

Write-Host ''
Write-Host 'Dependency Check Results' -ForegroundColor Cyan
Write-Host '------------------------'

if ($found.Count -gt 0) {
    Write-Host 'Found tools:' -ForegroundColor Green
    $found | Format-Table -AutoSize
}

if ($missing.Count -gt 0) {
    Write-Host 'Missing tools:' -ForegroundColor Red
    $missing | ForEach-Object { Write-Host "- $_" }
    Write-Host ''
    Write-Host 'Install Icarus Verilog (includes iverilog and vvp) and GTKWave.' -ForegroundColor Yellow
    exit 1
}

Write-Host 'All required tools are installed.' -ForegroundColor Green
exit 0
