# ==============================================================================
# FOKUSKONTEN 1-CLICK ZERO-DEPENDENCY SMART INSTALLER
# SKU: ID1A81 | Software: LogistikCargoPro (Software Ekspedisi Muatan Truk)
# Distribusi Resmi: https://fokuskonten.my.id
# Hak Cipta (c) 2026 FokusKonten Official. Seluruh Hak Cipta Dilindungi.
# ==============================================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "Stop"

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "         FOKUSKONTEN OFFICIAL - SMART INSTANT INSTALLER          " -ForegroundColor Yellow
Write-Host "   Aplikasi   : LogistikCargoPro (Software Ekspedisi Muatan Truk)                        " -ForegroundColor White
Write-Host "   SKU        : ID1A81                                        " -ForegroundColor White
Write-Host "   Distribusi : https://fokuskonten.my.id                        " -ForegroundColor Gray
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$installDir = "$env:LOCALAPPDATA\FokusKonten\LogistikCargoPro"
$releaseUrl = "https://github.com/fokuskonten/id1a81-logistikcargopro/releases/download/v1.0.0/logistikcargopro_standalone.zip"
$tempZip = "$env:TEMP\logistikcargopro_standalone.zip"

if (-not (Test-Path "$installDir\launch.bat")) {
    Write-Host "[1/3] Mengunduh paket mandiri LogistikCargoPro dari GitHub CDN..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $releaseUrl -OutFile $tempZip -UseBasicParsing
    
    Write-Host "[2/3] Memasang ke direktori lokal tanpa dependensi..." -ForegroundColor Cyan
    if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }
    Expand-Archive -Path $tempZip -DestinationPath $installDir -Force
    if (Test-Path $tempZip) { Remove-Item $tempZip -Force }
} else {
    Write-Host "[1/3] Paket mandiri LogistikCargoPro sudah terpasang di komputer Anda." -ForegroundColor Green
    Write-Host "[2/3] Memperbarui pintasan desktop..." -ForegroundColor Cyan
}

# 3. Buat Desktop Shortcut Resmi
Write-Host "[3/3] Menyiapkan pintasan resmi di Desktop Windows..." -ForegroundColor Cyan
$wsh = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcut = $wsh.CreateShortcut("$desktop\LogistikCargoPro.lnk")
$shortcut.TargetPath = "$installDir\launch.vbs"
$shortcut.WorkingDirectory = $installDir
$shortcut.Description = "LogistikCargoPro - Software Resmi FokusKonten"
if (Test-Path "$installDir\app\favicon.ico") {
    $shortcut.IconLocation = "$installDir\app\favicon.ico"
} elseif (Test-Path "$installDir\icon.ico") {
    $shortcut.IconLocation = "$installDir\icon.ico"
}
$shortcut.Save()

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "   PEMASANGAN SELESAI 100%! APLIKASI MENYALA DI LAYAR ANDA...    " -ForegroundColor Green
Write-Host "   Kredensial Default: admin / admin                             " -ForegroundColor Yellow
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""

if (Test-Path "$installDir\launch.vbs") {
    Start-Process "$installDir\launch.vbs"
}
