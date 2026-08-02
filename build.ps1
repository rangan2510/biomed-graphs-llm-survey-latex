# build.ps1 -- compile main.pdf and supplementary.pdf, then clean up.
#
# Usage, from the repository root:
#   .\build.ps1              compile both documents
#   .\build.ps1 -Main        compile only main.pdf
#   .\build.ps1 -Supp        compile only supplementary.pdf
#   .\build.ps1 -Svg         also regenerate the editable SVG figures
#   .\build.ps1 -KeepLogs    leave the .log files behind for debugging
#
# Requires Docker Desktop running, with the texlive/texlive image available.
# Nothing is installed on the host; TeX runs entirely inside the container.

[CmdletBinding()]
param(
    [switch]$Main,
    [switch]$Supp,
    [switch]$Svg,
    [switch]$KeepLogs
)

$ErrorActionPreference = 'Stop'
$root  = $PSScriptRoot
$image = 'texlive/texlive:latest'

# With neither -Main nor -Supp given, build both.
if (-not $Main -and -not $Supp) { $Main = $true; $Supp = $true }

function Invoke-Tex($shellCommand) {
    docker run --rm -v "${root}:/workdir" -w /workdir $image sh -c $shellCommand
}

function Test-Prerequisites {
    try { docker info *> $null }
    catch { throw 'Docker does not appear to be running. Start Docker Desktop and retry.' }

    $found = docker image ls --format '{{.Repository}}:{{.Tag}}' | Select-String -SimpleMatch $image
    if (-not $found) {
        Write-Host "Pulling $image (first run only, this takes a while)..." -ForegroundColor Yellow
        docker pull $image | Out-Null
    }
}

function Build-Document($name, $useBiber) {
    Write-Host "Building $name.pdf..." -ForegroundColor Cyan

    # pdflatex, then biber if the document has a bibliography, then two more
    # passes so that references, labels, and citations all settle.
    $steps = if ($useBiber) {
        "pdflatex -interaction=nonstopmode $name.tex >/dev/null 2>&1; " +
        "biber $name >/dev/null 2>&1; " +
        "pdflatex -interaction=nonstopmode $name.tex >/dev/null 2>&1; " +
        "pdflatex -interaction=nonstopmode $name.tex >/dev/null 2>&1"
    } else {
        "pdflatex -interaction=nonstopmode $name.tex >/dev/null 2>&1; " +
        "pdflatex -interaction=nonstopmode $name.tex >/dev/null 2>&1"
    }

    Invoke-Tex $steps

    $log = Join-Path $root "$name.log"
    if (-not (Test-Path $log)) { throw "$name failed before producing a log. Check the .tex syntax." }

    $logText = Get-Content $log -Raw

    # Hard errors first.
    $errors = Select-String -Path $log -Pattern '^!' | ForEach-Object { $_.Line }
    if ($errors) {
        Write-Host "  ERRORS in $name.tex:" -ForegroundColor Red
        $errors | Select-Object -Unique | ForEach-Object { Write-Host "    $_" -ForegroundColor Red }
    }

    # Then the warnings that usually matter.
    if ($logText -match 'There were undefined references') {
        Write-Host '  Warning: undefined references or citations remain.' -ForegroundColor Yellow
        Select-String -Path $log -Pattern 'undefined on input' |
            ForEach-Object { $_.Line } | Select-Object -Unique -First 10 |
            ForEach-Object { Write-Host "    $_" -ForegroundColor DarkYellow }
    }
    if ($logText -match 'Float too large') {
        Write-Host '  Warning: a float is too large for its page.' -ForegroundColor Yellow
    }

    # Page count, straight from the log.
    if ($logText -match 'Output written on .*\((\d+) pages?, (\d+) bytes\)') {
        $pages = $Matches[1]
        $kb    = [math]::Round([int]$Matches[2] / 1024)
        $colour = if ($errors) { 'Yellow' } else { 'Green' }
        Write-Host "  $name.pdf: $pages pages, $kb KB" -ForegroundColor $colour
    } else {
        Write-Host "  $name.pdf was not produced." -ForegroundColor Red
    }
}

function Build-Svg {
    Write-Host 'Regenerating SVG figures...' -ForegroundColor Cyan
    # The script is stored with CRLF endings on Windows; strip them for sh.
    Invoke-Tex "sed -i 's/\r`$//' figures/build-svg.sh; sh figures/build-svg.sh" |
        ForEach-Object { Write-Host "  $_" }
}

function Remove-Artifacts {
    $patterns = @(
        '*.aux','*.bbl','*.bcf','*.blg','*.fdb_latexmk','*.fls',
        '*.out','*.run.xml','*.synctex.gz','*.toc'
    )
    if (-not $KeepLogs) { $patterns += '*.log' }

    foreach ($p in $patterns) {
        Get-ChildItem -Path $root -Filter $p -File -ErrorAction SilentlyContinue |
            Remove-Item -Force -ErrorAction SilentlyContinue
    }
    # The SVG build leaves its own intermediates behind.
    Get-ChildItem -Path (Join-Path $root 'figures\svg') -Include '*.aux','*.log','*.dvi','*.tex' `
        -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

# ---------------------------------------------------------------- run

Push-Location $root
try {
    Test-Prerequisites

    if ($Main) { Build-Document -name 'main'          -useBiber $true  }
    if ($Supp) { Build-Document -name 'supplementary' -useBiber $false }
    if ($Svg)  { Build-Svg }

    Remove-Artifacts
    Write-Host 'Done.' -ForegroundColor Green
}
finally {
    Pop-Location
}
