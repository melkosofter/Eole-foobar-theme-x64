[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$themeTools = Join-Path (Split-Path -Parent $PSScriptRoot) 'themes\eole\tools'
$compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
if (-not (Test-Path -LiteralPath $compiler)) { throw '.NET Framework 4.x x64 C# compiler is required.' }
& $compiler /nologo /target:winexe /platform:x64 /optimize+ "/out:$themeTools\EoleBorder.exe" "$themeTools\EoleBorder.cs"
if ($LASTEXITCODE -ne 0) { throw 'C# build failed.' }
Write-Host "Built $themeTools\EoleBorder.exe"
