[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ProfilePath = (Join-Path $env:APPDATA 'foobar2000-v2'),
    [switch]$ValidateOnly
)
$ErrorActionPreference = 'Stop'
$bundleRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$profileRoot = [IO.Path]::GetFullPath($ProfilePath).TrimEnd('\', '/')
if ($profileRoot -eq [IO.Path]::GetPathRoot($profileRoot).TrimEnd('\', '/') -or $profileRoot -eq $bundleRoot) {
    throw 'Choose a foobar2000 profile directory, not a drive root or the bundle directory.'
}
$hashPath = Join-Path $bundleRoot 'FILE-HASHES.json'
if (-not (Test-Path -LiteralPath $hashPath)) { throw 'FILE-HASHES.json is missing. Extract the complete release ZIP.' }
$hashes = Get-Content -LiteralPath $hashPath -Raw | ConvertFrom-Json
foreach ($entry in $hashes) {
    $candidate = [IO.Path]::GetFullPath((Join-Path $bundleRoot $entry.path))
    if (-not $candidate.StartsWith($bundleRoot + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Invalid manifest path.' }
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) { throw "Missing file: $($entry.path)" }
    if ((Get-FileHash -LiteralPath $candidate -Algorithm SHA256).Hash -ne $entry.sha256) { throw "Hash mismatch: $($entry.path)" }
}
Write-Host "Validated $($hashes.Count) bundle files."
if ($ValidateOnly) { return }
if (Get-Process -Name foobar2000 -ErrorAction SilentlyContinue) { throw 'Close all foobar2000 instances before installing.' }
if (-not $PSCmdlet.ShouldProcess($profileRoot, 'Back up and install the Eole x64 theme and components')) { return }
$backupRoot = Join-Path $profileRoot ('eole-install-backups\' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
$relativeFolders = @('themes\eole', 'milkdrop2')
$relativeFolders += Get-ChildItem -LiteralPath (Join-Path $bundleRoot 'user-components-x64') -Directory | ForEach-Object { 'user-components-x64\' + $_.Name }
foreach ($relative in $relativeFolders) {
    $sourceFolder = Join-Path $bundleRoot $relative
    $targetFolder = Join-Path $profileRoot $relative
    if (Test-Path -LiteralPath $targetFolder) {
        $backupParent = Split-Path -Parent (Join-Path $backupRoot $relative)
        New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
        Copy-Item -LiteralPath $targetFolder -Destination $backupParent -Recurse -Force
    }
    $targetParent = Split-Path -Parent $targetFolder
    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    Copy-Item -LiteralPath $sourceFolder -Destination $targetParent -Recurse -Force
}
# Only this version marker is replaced; preserve all other user Eole settings.
$settingsFolder = Join-Path $profileRoot 'wsh-data\eole-settings'
New-Item -ItemType Directory -Path $settingsFolder -Force | Out-Null
$oldMarkers = @(Get-ChildItem -LiteralPath $settingsFolder -Filter 'THEMEVERSION_*' -File)
if ($oldMarkers.Count) {
    $markerBackup = Join-Path $backupRoot 'wsh-data\eole-settings'
    New-Item -ItemType Directory -Path $markerBackup -Force | Out-Null
    foreach ($marker in $oldMarkers) {
        Copy-Item -LiteralPath $marker.FullName -Destination $markerBackup -Force
        Remove-Item -LiteralPath $marker.FullName
    }
}
Copy-Item -LiteralPath (Join-Path $bundleRoot 'wsh-data\eole-settings\THEMEVERSION_1.2.3b24') -Destination $settingsFolder -Force
Write-Host "Installed Eole x64 in $profileRoot"
Write-Host "Backup: $backupRoot"
Write-Host 'Next: start foobar2000, select Columns UI, then import themes\eole\columnsUI_eole_x64.fcl.'
