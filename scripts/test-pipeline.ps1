# Script để test Jenkins pipeline
# Chạy script này để test pipeline sau khi cấu hình xong

param(
    [string]$JenkinsUrl = "http://localhost:8080",
    [string]$JobName = "Group-Project-Pipeline"
)

Write-Host "=== Jenkins Pipeline Test Script ===" -ForegroundColor Green

# 1. Kiểm tra Jenkins server
Write-Host "1. Kiểm tra Jenkins server..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $JenkinsUrl -Method Get -TimeoutSec 10
    Write-Host "✅ Jenkins server đang chạy!" -ForegroundColor Green
} catch {
    Write-Host "❌ Không thể kết nối đến Jenkins server!" -ForegroundColor Red
    Write-Host "Hãy đảm bảo Jenkins đang chạy tại $JenkinsUrl" -ForegroundColor Yellow
    exit 1
}

# 2. Kiểm tra job có tồn tại không
Write-Host "2. Kiểm tra job '$JobName'..." -ForegroundColor Yellow
try {
    $jobUrl = "$JenkinsUrl/job/$JobName/"
    $response = Invoke-WebRequest -Uri $jobUrl -Method Get -TimeoutSec 10
    Write-Host "✅ Job '$JobName' tồn tại!" -ForegroundColor Green
} catch {
    Write-Host "❌ Job '$JobName' không tồn tại!" -ForegroundColor Red
    Write-Host "Hãy tạo job trước khi test!" -ForegroundColor Yellow
    exit 1
}

# 3. Trigger build
Write-Host "3. Triggering build..." -ForegroundColor Yellow
try {
    $buildUrl = "$JenkinsUrl/job/$JobName/build"
    $response = Invoke-WebRequest -Uri $buildUrl -Method Post -TimeoutSec 30
    Write-Host "✅ Build đã được trigger!" -ForegroundColor Green
} catch {
    Write-Host "❌ Không thể trigger build!" -ForegroundColor Red
    Write-Host "Lỗi: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 4. Chờ build hoàn thành và kiểm tra kết quả
Write-Host "4. Chờ build hoàn thành..." -ForegroundColor Yellow
$maxWaitTime = 300 # 5 phút
$waitTime = 0
$buildCompleted = $false

while ($waitTime -lt $maxWaitTime -and -not $buildCompleted) {
    Start-Sleep -Seconds 10
    $waitTime += 10
    
    try {
        $jobUrl = "$JenkinsUrl/job/$JobName/api/json"
        $response = Invoke-WebRequest -Uri $jobUrl -Method Get -TimeoutSec 10
        $jobData = $response.Content | ConvertFrom-Json
        
        if ($jobData.lastBuild -and $jobData.lastBuild.number) {
            $buildNumber = $jobData.lastBuild.number
            $buildUrl = "$JenkinsUrl/job/$JobName/$buildNumber/api/json"
            $buildResponse = Invoke-WebRequest -Uri $buildUrl -Method Get -TimeoutSec 10
            $buildData = $buildResponse.Content | ConvertFrom-Json
            
            if ($buildData.building -eq $false) {
                $buildCompleted = $true
                $buildResult = $buildData.result
                
                if ($buildResult -eq "SUCCESS") {
                    Write-Host "✅ Build thành công! (Build #$buildNumber)" -ForegroundColor Green
                } elseif ($buildResult -eq "FAILURE") {
                    Write-Host "❌ Build thất bại! (Build #$buildNumber)" -ForegroundColor Red
                } else {
                    Write-Host "⚠️ Build hoàn thành với kết quả: $buildResult (Build #$buildNumber)" -ForegroundColor Yellow
                }
            } else {
                Write-Host "⏳ Build đang chạy... (Build #$buildNumber) - Đã chờ $waitTime giây" -ForegroundColor Cyan
            }
        }
    } catch {
        Write-Host "⚠️ Không thể kiểm tra trạng thái build: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

if (-not $buildCompleted) {
    Write-Host "⏰ Timeout! Build chưa hoàn thành sau $maxWaitTime giây" -ForegroundColor Yellow
}

# 5. Hiển thị thông tin build
Write-Host "`n=== Thông tin Build ===" -ForegroundColor Cyan
Write-Host "Job URL: $JenkinsUrl/job/$JobName/" -ForegroundColor Yellow
Write-Host "Console Output: $JenkinsUrl/job/$JobName/lastBuild/console" -ForegroundColor Yellow

# 6. Test webhook (nếu có)
Write-Host "`n=== Test Webhook ===" -ForegroundColor Cyan
Write-Host "Để test webhook, tạo một commit mới trên GitHub:" -ForegroundColor Yellow
Write-Host "1. git add ." -ForegroundColor Cyan
Write-Host "2. git commit -m 'Test webhook'" -ForegroundColor Cyan
Write-Host "3. git push origin main" -ForegroundColor Cyan
Write-Host "4. Kiểm tra Jenkins có tự động build không" -ForegroundColor Cyan

Write-Host "`n=== Hoàn tất! ===" -ForegroundColor Green
