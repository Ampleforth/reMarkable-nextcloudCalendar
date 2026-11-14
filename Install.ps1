# SPDX-License-Identifier: GPL-3.0-only
param(
    [Parameter(Mandatory=$true)][ValidateSet('armv7','aarch64')][string]$Architecture,
    [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9_.@:-]+$')][string]$Target
)
$ErrorActionPreference = 'Stop'
if ($Target.StartsWith('-')) { throw 'Invalid SSH target.' }
$expected = if ($Architecture -eq 'armv7') { 'armv7l' } else { 'aarch64' }
$bundle = Join-Path $PSScriptRoot "$Architecture/nextcloud-calendar"
if (!(Test-Path "$bundle/backend/entry")) { throw 'Extract the complete matching download first.' }
if ((Get-Content "$bundle/architecture" -Raw).Trim() -ne $expected) { throw 'Bundle architecture mismatch.' }
foreach ($tool in @('ssh','scp','tar')) { if (!(Get-Command $tool -ErrorAction SilentlyContinue)) { throw "Install $tool first; see INSTALL.md." } }
$localStage = Join-Path ([IO.Path]::GetTempPath()) ('calendar-install-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $localStage | Out-Null
try {
    $archive = Join-Path $localStage 'app.tar.gz'
    & tar -czf $archive -C (Join-Path $PSScriptRoot $Architecture) nextcloud-calendar
    if ($LASTEXITCODE -ne 0) { throw 'Could not create upload archive.' }
    $remoteStage = (& ssh $Target 'mktemp -d /home/root/calendar-install.XXXXXX')
    if ($LASTEXITCODE -ne 0) { throw 'SSH connection failed.' }
    $remoteStage = "$remoteStage".Trim()
    if ($remoteStage -notmatch '^/home/root/calendar-install\.[A-Za-z0-9]+$') { throw 'Could not establish a clean SSH connection.' }
    & scp $archive (Join-Path $PSScriptRoot 'install-device.sh') "${Target}:${remoteStage}/"
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Retrying with legacy SCP for tablet SSH compatibility.'
        & scp -O $archive (Join-Path $PSScriptRoot 'install-device.sh') "${Target}:${remoteStage}/"
        if ($LASTEXITCODE -ne 0) { throw 'Upload failed.' }
    }
    & ssh $Target sh "$remoteStage/install-device.sh" "$remoteStage/app.tar.gz" $expected
    if ($LASTEXITCODE -ne 0) { throw 'Tablet installation failed. Read the message above.' }
} finally {
    Remove-Item -LiteralPath $localStage -Recurse -Force
}
