# Jenkins Installation Script for Windows
# Chạy script này với quyền Administrator

Write-Host "=== Jenkins Installation Script ===" -ForegroundColor Green

# Kiểm tra quyền Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Script cần chạy với quyền Administrator!" -ForegroundColor Red
    Write-Host "Click chuột phải vào PowerShell và chọn 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# 1. Cài đặt Java (nếu chưa có)
Write-Host "1. Kiểm tra Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    if ($javaVersion) {
        Write-Host "Java đã được cài đặt: $javaVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "Java chưa được cài đặt. Đang cài đặt..." -ForegroundColor Yellow
    
    # Cài đặt Chocolatey nếu chưa có
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Cài đặt Chocolatey..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    # Cài đặt Java
    choco install openjdk11 -y
    refreshenv
}

# 2. Tạo thư mục Jenkins
Write-Host "2. Tạo thư mục Jenkins..." -ForegroundColor Yellow
$jenkinsHome = "C:\Jenkins"
if (!(Test-Path $jenkinsHome)) {
    New-Item -ItemType Directory -Path $jenkinsHome -Force
    Write-Host "Đã tạo thư mục: $jenkinsHome" -ForegroundColor Green
}

# 3. Download Jenkins WAR file
Write-Host "3. Download Jenkins..." -ForegroundColor Yellow
$jenkinsUrl = "https://get.jenkins.io/war-stable/latest/jenkins.war"
$jenkinsWar = "$jenkinsHome\jenkins.war"

if (!(Test-Path $jenkinsWar)) {
    Write-Host "Đang download Jenkins WAR file..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $jenkinsUrl -OutFile $jenkinsWar
    Write-Host "Download hoàn tất!" -ForegroundColor Green
} else {
    Write-Host "Jenkins WAR file đã tồn tại!" -ForegroundColor Green
}

# 4. Tạo batch file để chạy Jenkins
Write-Host "4. Tạo startup script..." -ForegroundColor Yellow
$startScript = @"
@echo off
echo Starting Jenkins...
set JENKINS_HOME=$jenkinsHome
java -jar "$jenkinsWar" --httpPort=8080 --httpListenAddress=0.0.0.0
pause
"@

$startScript | Out-File -FilePath "$jenkinsHome\start-jenkins.bat" -Encoding ASCII
Write-Host "Đã tạo startup script: $jenkinsHome\start-jenkins.bat" -ForegroundColor Green

# 5. Tạo Windows Service (tùy chọn)
Write-Host "5. Tạo Windows Service..." -ForegroundColor Yellow
$serviceScript = @"
@echo off
echo Installing Jenkins as Windows Service...
sc create "Jenkins" binPath= "java -jar $jenkinsWar --httpPort=8080" start= auto
sc description "Jenkins" "Jenkins CI Server"
sc start "Jenkins"
echo Jenkins service installed and started!
pause
"@

$serviceScript | Out-File -FilePath "$jenkinsHome\install-service.bat" -Encoding ASCII
Write-Host "Đã tạo service script: $jenkinsHome\install-service.bat" -ForegroundColor Green

# 6. Cài đặt Git (nếu chưa có)
Write-Host "6. Kiểm tra Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    if ($gitVersion) {
        Write-Host "Git đã được cài đặt: $gitVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "Git chưa được cài đặt. Đang cài đặt..." -ForegroundColor Yellow
    choco install git -y
    refreshenv
}

# 7. Cài đặt .NET SDK (nếu chưa có)
Write-Host "7. Kiểm tra .NET SDK..." -ForegroundColor Yellow
try {
    $dotnetVersion = dotnet --version 2>&1
    if ($dotnetVersion) {
        Write-Host ".NET SDK đã được cài đặt: $dotnetVersion" -ForegroundColor Green
    }
} catch {
    Write-Host ".NET SDK chưa được cài đặt. Đang cài đặt..." -ForegroundColor Yellow
    choco install dotnet-sdk -y
    refreshenv
}

Write-Host "`n=== Cài đặt hoàn tất! ===" -ForegroundColor Green
Write-Host "Để chạy Jenkins:" -ForegroundColor Yellow
Write-Host "1. Chạy file: $jenkinsHome\start-jenkins.bat" -ForegroundColor Cyan
Write-Host "2. Hoặc cài đặt service: $jenkinsHome\install-service.bat" -ForegroundColor Cyan
Write-Host "3. Truy cập: http://localhost:8080" -ForegroundColor Cyan
Write-Host "`nLưu ý: Lưu lại initial admin password khi Jenkins khởi động lần đầu!" -ForegroundColor Red
