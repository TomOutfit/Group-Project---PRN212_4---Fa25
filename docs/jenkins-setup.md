# Hướng dẫn cài đặt và cấu hình Jenkins

## 1. Cài đặt Jenkins

### Trên Windows:

#### Phương pháp 1: Sử dụng Java và Jenkins WAR
```bash
# 1. Cài đặt Java 11 hoặc 17
# Download từ: https://adoptium.net/

# 2. Download Jenkins WAR file
# Từ: https://www.jenkins.io/download/

# 3. Chạy Jenkins
java -jar jenkins.war --httpPort=8080
```

#### Phương pháp 2: Sử dụng Docker
```bash
# 1. Cài đặt Docker Desktop
# 2. Chạy Jenkins container
docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

#### Phương pháp 3: Sử dụng Chocolatey
```powershell
# Cài đặt Chocolatey nếu chưa có
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Cài đặt Jenkins
choco install jenkins
```

## 2. Cấu hình Jenkins ban đầu

1. Truy cập: http://localhost:8080
2. Lấy initial admin password từ console hoặc file:
   - Windows: `C:\Users\{username}\.jenkins\secrets\initialAdminPassword`
   - Docker: `docker exec -it <container_id> cat /var/jenkins_home/secrets/initialAdminPassword`

3. Cài đặt suggested plugins
4. Tạo admin user
5. Cấu hình Jenkins URL

## 3. Cài đặt plugins cần thiết

Vào **Manage Jenkins > Manage Plugins** và cài đặt:

- **Git Plugin** - Tích hợp Git
- **GitHub Plugin** - Tích hợp GitHub
- **GitHub Pull Request Builder** - Build PR
- **Pipeline Plugin** - Hỗ trợ Pipeline
- **Blue Ocean** - Giao diện đẹp hơn
- **Docker Pipeline** - Hỗ trợ Docker
- **.NET SDK Plugin** - Hỗ trợ .NET

## 4. Cấu hình Git và GitHub

### Cấu hình Git:
1. Vào **Manage Jenkins > Global Tool Configuration**
2. Tìm **Git** section
3. Thêm Git installation path (thường là `git` nếu đã cài đặt)

### Cấu hình GitHub:
1. Vào **Manage Jenkins > Configure System**
2. Tìm **GitHub** section
3. Thêm GitHub server:
   - Name: `GitHub`
   - API URL: `https://api.github.com`
   - Credentials: Tạo Personal Access Token

## 5. Tạo Personal Access Token

1. Vào GitHub > Settings > Developer settings > Personal access tokens
2. Tạo token mới với quyền:
   - `repo` (Full control of private repositories)
   - `admin:repo_hook` (Full control of repository hooks)
   - `admin:org_hook` (Full control of organization hooks)

## 6. Cấu hình Credentials

1. Vào **Manage Jenkins > Manage Credentials**
2. Thêm credentials:
   - Kind: `Username with password`
   - Username: GitHub username
   - Password: Personal Access Token
   - ID: `github-token`

## 7. Tạo Job Pipeline

1. **New Item** > **Pipeline**
2. Tên: `Group-Project-Pipeline`
3. Cấu hình:
   - **Pipeline script from SCM**
   - **SCM**: Git
   - **Repository URL**: `https://github.com/TomOutfit/Group-Project---PRN212_4---Fa25.git`
   - **Credentials**: Chọn credentials đã tạo
   - **Branch**: `*/main`
   - **Script Path**: `Jenkinsfile`

## 8. Cấu hình Webhook (Tự động trigger)

### Trên GitHub:
1. Vào repository > Settings > Webhooks
2. Add webhook:
   - **Payload URL**: `http://your-jenkins-server:8080/github-webhook/`
   - **Content type**: `application/json`
   - **Events**: Chọn `Just the push event`
   - **Active**: ✓

### Trên Jenkins:
1. Vào job > Configure
2. **Build Triggers** > ✓ **GitHub hook trigger for GITScm polling**
3. **Poll SCM** > Schedule: `H/5 * * * *` (check mỗi 5 phút)

## 9. Test Pipeline

1. Tạo commit mới trên GitHub
2. Kiểm tra Jenkins có tự động build không
3. Xem logs trong **Console Output**

## 10. Troubleshooting

### Lỗi thường gặp:
- **Git not found**: Cài đặt Git và cấu hình PATH
- **Permission denied**: Kiểm tra credentials
- **Webhook not working**: Kiểm tra firewall và URL
- **Build fails**: Kiểm tra .NET SDK có cài đặt không

### Logs hữu ích:
- Jenkins logs: `C:\Users\{username}\.jenkins\logs\`
- Job logs: Trong job > Console Output
