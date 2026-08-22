<#
.SYNOPSIS
    Compiles every chapter headlessly with vvvvc. The pack's real test.

.DESCRIPTION
    This is the check that matters most here, because a content pack has nothing else: no unit
    tests, no assembly, only patches. And it is a genuine INTEGRATION test - every chapter uses
    several libraries at once, so a signature change in any of them shows up here and nowhere else.
    Three real defects in VL.Mapsui were found this way on 2026-08-16, none of them by its own 212
    unit tests.

    Two things have to be supplied and they are different:

      1. `--package-repositories` -- how vvvv finds a PACKAGE FOLDER, i.e. <sibling>\dist\.
         Point it at dist\, not dist\feed\, or vvvvc says "Missing package: VL.Mapsui".
      2. a NuGet SOURCE for restore -- vvvvc emits a .csproj with a PackageReference and runs a
         normal restore. That needs <sibling>\dist\feed\, the folder with the .nupkg in it.

    Supplying one and not the other produces a confident error about the other. Both lists come
    from Get-PackageRepositories.ps1, which is the only place they are written down.

    EXIT 0 MEANS THE DOCUMENT PARSED, not that the nodes resolved. An unimported type is dropped in
    silence and its links go with it. Read the generated C# afterwards - that is the second half of
    this check, and skipping it is how a chapter ships with half its graph missing.

.EXAMPLE
    .\tools\Compile-HelpPatches.ps1 -OutputDirectory D:\tmp\compile
#>
param(
    [string]$OutputDirectory,
    [string]$Patch = '*'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path $PSScriptRoot -Parent
$Vvvvc    = 'C:\Program Files\vvvv\vvvv_gamma_7.4-win-x64\vvvvc.exe'

if (-not (Test-Path $Vvvvc)) {
    Write-Host "vvvvc not found at $Vvvvc" -ForegroundColor Red
    exit 1
}

$paths = & (Join-Path $PSScriptRoot 'Get-PackageRepositories.ps1')
if ($paths.Missing.Count -gt 0) {
    Write-Host "missing package repositories:" -ForegroundColor Red
    $paths.Missing | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    exit 1
}
if ($paths.Feeds.Count -eq 0) {
    Write-Host "no dist\feed in any sibling - run their pack.ps1 first" -ForegroundColor Red
    exit 1
}

if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path ([IO.Path]::GetTempPath()) "vl-overworld-compile-$PID"
}
New-Item -ItemType Directory $OutputDirectory -Force | Out-Null

# Restore walks up from the generated .csproj and finds this.
$sources = @()
for ($i = 0; $i -lt $paths.Feeds.Count; $i++) {
    $sources += "    <add key=""sibling-$i"" value=""$($paths.Feeds[$i])"" />"
}
$config = @"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
$($sources -join "`n")
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
  </packageSources>
</configuration>
"@
$config | Set-Content (Join-Path $OutputDirectory 'NuGet.config') -Encoding utf8

$chapters = @(Get-ChildItem (Join-Path $RepoRoot 'help') -Recurse -File -Filter *.vl |
              Where-Object { $_.BaseName -like $Patch })
if ($chapters.Count -eq 0) {
    Write-Host "no chapter matches '$Patch'" -ForegroundColor Red
    exit 1
}

Write-Host "compiling $($chapters.Count) chapter(s) -> $OutputDirectory`n"

$repositories = $paths.Repositories -join ';'
$failed = @()

foreach ($c in $chapters) {
    $dir = Join-Path $OutputDirectory ($c.BaseName -replace '[^\w]', '_')
    $log = & $Vvvvc $c.FullName --output-directory $dir --package-repositories $repositories 2>&1
    $code = $LASTEXITCODE

    if ($code -eq 0) {
        Write-Host ("  ok    {0}" -f $c.Name) -ForegroundColor DarkGray
    } else {
        Write-Host ("  FAIL  {0}  (exit {1})" -f $c.Name, $code) -ForegroundColor Red
        @($log) | Select-Object -Last 6 | ForEach-Object { Write-Host "          $_" -ForegroundColor DarkRed }
        $failed += $c.Name
    }
}

Write-Host ''
if ($failed.Count -gt 0) {
    Write-Host "FAIL - $($failed.Count) chapter(s) did not compile: $($failed -join ', ')" -ForegroundColor Red
    exit 1
}
Write-Host "PASS - every chapter compiles." -ForegroundColor Green
Write-Host "  exit 0 means the document PARSED. Read the generated C# in $OutputDirectory to see" -ForegroundColor Yellow
Write-Host "  that the nodes RESOLVED - an unimported type is dropped in silence." -ForegroundColor Yellow
