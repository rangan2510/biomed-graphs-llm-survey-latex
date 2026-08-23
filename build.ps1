# build.ps1 -- compile main.pdf and supplementary.pdf, then clean up.
#
# Usage, from the repository root:
#   .\build.ps1              compile both documents (clean, no revision colour)
#   .\build.ps1 -Main        compile only main.pdf
#   .\build.ps1 -Supp        compile only supplementary.pdf
#   .\build.ps1 -Marked      also write *-revised-marked.pdf with \rev{} in blue
#   .\build.ps1 -Svg         also regenerate the editable SVG figures
#   .\build.ps1 -KeepLogs    leave the .log files behind for debugging
#
# The clean and marked copies come from the same sources. \rev{} is a no-op
# unless \REVMARKED is defined, which -Marked does on the command line, so the
# two PDFs can never drift apart.
#
# Requires Docker Desktop running, with the texlive/texlive image available.
# Nothing is installed on the host; TeX runs entirely inside the container.

[CmdletBinding()]
param(
    [switch]$Main,
    [switch]$Supp,
    [switch]$Marked,
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
    # Suppress native stderr redirection in PowerShell to avoid tripping $ErrorActionPreference = 'Stop'
    $null = cmd /c "docker info >nul 2>&1"
    if ($LASTEXITCODE -ne 0) {
        throw 'Docker does not appear to be running. Start Docker Desktop and retry.'
    }

    $found = docker image ls --format '{{.Repository}}:{{.Tag}}' | Select-String -SimpleMatch $image
    if (-not $found) {
        Write-Host "Pulling $image (first run only, this takes a while)..." -ForegroundColor Yellow
        docker pull $image | Out-Null
    }
}

function Build-Document($name, $useBiber, $jobname = $null, $marked = $false) {
    if (-not $jobname) { $jobname = $name }
    Write-Host "Building $jobname.pdf..." -ForegroundColor Cyan

    # -Marked defines \REVMARKED before the document is read, which switches
    # \rev{} from a no-op to blue text. Writing to a different -jobname keeps
    # the clean and marked outputs side by side.
    $input = if ($marked) { "'\def\REVMARKED{}\input{$name.tex}'" } else { "$name.tex" }
    $tex   = "pdflatex -interaction=nonstopmode -jobname=$jobname $input"

    # pdflatex, then biber if the document has a bibliography, then two more
    # passes so that references, labels, and citations all settle.
    $steps = if ($useBiber) {
        "$tex >/dev/null 2>&1; biber $jobname >/dev/null 2>&1; " +
        "$tex >/dev/null 2>&1; $tex >/dev/null 2>&1"
    } else {
        "$tex >/dev/null 2>&1; $tex >/dev/null 2>&1"
    }

    Invoke-Tex $steps

    $log = Join-Path $root "$jobname.log"
    if (-not (Test-Path $log)) { throw "$jobname failed before producing a log. Check the .tex syntax." }

    $logText = Get-Content $log -Raw

    # Hard errors first.
    $errors = Select-String -Path $log -Pattern '^!' | ForEach-Object { $_.Line }
    if ($errors) {
        Write-Host "  ERRORS in $jobname.tex:" -ForegroundColor Red
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
        Write-Host "  $jobname.pdf: $pages pages, $kb KB" -ForegroundColor $colour
    } else {
        Write-Host "  $jobname.pdf was not produced." -ForegroundColor Red
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

    if ($Marked) {
        if ($Main) {
            Build-Document -name 'main' -useBiber $true `
                -jobname 'main-revised-marked' -marked $true
        }
        if ($Supp) {
            Build-Document -name 'supplementary' -useBiber $false `
                -jobname 'supplementary-revised-marked' -marked $true
        }
    }

    if ($Svg)  { Build-Svg }

    Remove-Artifacts
    Write-Host 'Done.' -ForegroundColor Green
}
finally {
    Pop-Location
}
