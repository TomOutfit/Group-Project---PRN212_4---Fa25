# Jenkins Installation Script - Simple Version
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
    try {
        Invoke-WebRequest -Uri $jenkinsUrl -OutFile $jenkinsWar
        Write-Host "Download hoàn tất!" -ForegroundColor Green
    } catch {
        Write-Host "Lỗi download Jenkins: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Thử download thủ công từ: $jenkinsUrl" -ForegroundColor Yellow
    }
} else {
    Write-Host "Jenkins WAR file đã tồn tại!" -ForegroundColor Green
}

# 4. Cài đặt Git (nếu chưa có)
Write-Host "4. Kiểm tra Git..." -ForegroundColor Yellow
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

# 5. Cài đặt .NET SDK (nếu chưa có)
Write-Host "5. Kiểm tra .NET SDK..." -ForegroundColor Yellow
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
Write-Host "1. Mở Command Prompt hoặc PowerShell" -ForegroundColor Cyan
Write-Host "2. Chạy lệnh: java -jar $jenkinsWar --httpPort=8080" -ForegroundColor Cyan
Write-Host "3. Truy cập: http://localhost:8080" -ForegroundColor Cyan
Write-Host "`nLưu ý: Lưu lại initial admin password khi Jenkins khởi động lần đầu!" -ForegroundColor Red
