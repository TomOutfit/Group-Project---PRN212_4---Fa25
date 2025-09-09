# Script để tự động cấu hình Jenkins Job
# Chạy script này sau khi đã cài đặt Jenkins

param(
    [string]$JenkinsUrl = "http://localhost:8080",
    [string]$JenkinsUser = "admin",
    [string]$JenkinsPassword = "",
    [string]$GitHubToken = "",
    [string]$GitHubUsername = "TomOutfit"
)

Write-Host "=== Jenkins Job Setup Script ===" -ForegroundColor Green

# Kiểm tra Jenkins có chạy không
Write-Host "1. Kiểm tra Jenkins server..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $JenkinsUrl -Method Get -TimeoutSec 10
    Write-Host "Jenkins server đang chạy!" -ForegroundColor Green
} catch {
    Write-Host "Không thể kết nối đến Jenkins server tại $JenkinsUrl" -ForegroundColor Red
    Write-Host "Hãy đảm bảo Jenkins đang chạy và URL đúng!" -ForegroundColor Yellow
    exit 1
}

# Tạo credentials cho GitHub
Write-Host "2. Tạo GitHub credentials..." -ForegroundColor Yellow
$credentialsXml = @"
<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
  <scope>GLOBAL</scope>
  <id>github-token</id>
  <description>GitHub Personal Access Token</description>
  <username>$GitHubUsername</username>
  <password>$GitHubToken</password>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
"@

# Tạo job configuration
Write-Host "3. Tạo job configuration..." -ForegroundColor Yellow
$jobConfig = @"
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.45">
  <actions>
    <org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobAction plugin="pipeline-model-definition@1.8.5"/>
  </actions>
  <description>Group Project C# CI/CD Pipeline</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <jenkins.model.BuildDiscarderProperty>
      <strategy class="hudson.tasks.LogRotator">
        <daysToKeepStr>30</daysToKeepStr>
        <numToKeepStr>10</numToKeepStr>
        <artifactDaysToKeepStr>-1</artifactDaysToKeepStr>
        <artifactNumToKeepStr>-1</artifactNumToKeepStr>
      </strategy>
    </jenkins.model.BuildDiscarderProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.92">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@4.11.3">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/TomOutfit/Group-Project---PRN212_4---Fa25.git</url>
          <credentialsId>github-token</credentialsId>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="empty-list"/>
      <extensions>
        <hudson.plugins.git.extensions.impl.CleanBeforeCheckout/>
        <hudson.plugins.git.extensions.impl.CleanCheckout/>
      </extensions>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>false</lightweight>
  </definition>
  <triggers>
    <hudson.triggers.SCMTrigger>
      <spec>H/5 * * * *</spec>
    </hudson.triggers.SCMTrigger>
  </triggers>
  <disabled>false</disabled>
</flow-definition>
"@

# Lưu job config vào file
$jobConfig | Out-File -FilePath "Group-Project-Pipeline-config.xml" -Encoding UTF8
Write-Host "Đã tạo job config file: Group-Project-Pipeline-config.xml" -ForegroundColor Green

Write-Host "`n=== Hướng dẫn tiếp theo ===" -ForegroundColor Cyan
Write-Host "1. Đăng nhập vào Jenkins: $JenkinsUrl" -ForegroundColor Yellow
Write-Host "2. Vào Manage Jenkins > Manage Credentials" -ForegroundColor Yellow
Write-Host "3. Thêm credentials với ID: github-token" -ForegroundColor Yellow
Write-Host "4. Tạo job mới từ file: Group-Project-Pipeline-config.xml" -ForegroundColor Yellow
Write-Host "5. Cấu hình webhook trên GitHub" -ForegroundColor Yellow

Write-Host "`n=== Webhook URL ===" -ForegroundColor Cyan
Write-Host "GitHub Webhook URL: $JenkinsUrl/github-webhook/" -ForegroundColor Green

Write-Host "`n=== Test Job ===" -ForegroundColor Cyan
Write-Host "Sau khi cấu hình xong, test bằng cách:" -ForegroundColor Yellow
Write-Host "1. Tạo commit mới trên GitHub" -ForegroundColor Yellow
Write-Host "2. Hoặc click 'Build Now' trong Jenkins job" -ForegroundColor Yellow
