# Cấu hình Webhook GitHub cho Jenkins

## Bước 1: Tạo Personal Access Token trên GitHub

1. Đăng nhập vào GitHub
2. Vào **Settings** > **Developer settings** > **Personal access tokens** > **Tokens (classic)**
3. Click **Generate new token (classic)**
4. Cấu hình:
   - **Note**: `Jenkins CI/CD Token`
   - **Expiration**: `No expiration` (hoặc chọn thời gian phù hợp)
   - **Scopes**: Chọn các quyền sau:
     - ✅ `repo` (Full control of private repositories)
     - ✅ `admin:repo_hook` (Full control of repository hooks)
     - ✅ `admin:org_hook` (Full control of organization hooks)
     - ✅ `workflow` (Update GitHub Action workflows)

5. Click **Generate token**
6. **Lưu lại token này** (chỉ hiển thị 1 lần)

## Bước 2: Cấu hình Jenkins

### 2.1. Thêm Credentials
1. Truy cập Jenkins: `http://localhost:8080`
2. Vào **Manage Jenkins** > **Manage Credentials**
3. Chọn domain **Global** > **Add Credentials**
4. Cấu hình:
   - **Kind**: `Username with password`
   - **Username**: `your-github-username`
   - **Password**: `your-personal-access-token`
   - **ID**: `github-token`
   - **Description**: `GitHub Personal Access Token`

### 2.2. Cấu hình GitHub Server
1. Vào **Manage Jenkins** > **Configure System**
2. Tìm section **GitHub**
3. Click **Add GitHub Server**
4. Cấu hình:
   - **Name**: `GitHub`
   - **API URL**: `https://api.github.com`
   - **Credentials**: Chọn `github-token` đã tạo
   - ✅ **Manage hooks**

### 2.3. Cấu hình Git
1. Vào **Manage Jenkins** > **Global Tool Configuration**
2. Tìm section **Git**
3. Thêm Git installation:
   - **Name**: `Default`
   - **Path to Git executable**: `git` (hoặc đường dẫn đầy đủ)

## Bước 3: Tạo Jenkins Job

### 3.1. Tạo Pipeline Job
1. Click **New Item**
2. Nhập tên: `Group-Project-Pipeline`
3. Chọn **Pipeline** > **OK**

### 3.2. Cấu hình Job
1. **General**:
   - ✅ **GitHub project**
   - **Project url**: `https://github.com/TomOutfit/Group-Project---PRN212_4---Fa25`

2. **Build Triggers**:
   - ✅ **GitHub hook trigger for GITScm polling**
   - ✅ **Poll SCM** với schedule: `H/5 * * * *`

3. **Pipeline**:
   - **Definition**: `Pipeline script from SCM`
   - **SCM**: `Git`
   - **Repository URL**: `https://github.com/TomOutfit/Group-Project---PRN212_4---Fa25.git`
   - **Credentials**: `github-token`
   - **Branch Specifier**: `*/main`
   - **Script Path**: `Jenkinsfile`

4. Click **Save**

## Bước 4: Cấu hình Webhook trên GitHub

### 4.1. Thêm Webhook
1. Vào repository: `https://github.com/TomOutfit/Group-Project---PRN212_4---Fa25`
2. Vào **Settings** > **Webhooks**
3. Click **Add webhook**

### 4.2. Cấu hình Webhook
- **Payload URL**: `http://your-jenkins-ip:8080/github-webhook/`
  - Nếu Jenkins chạy local: `http://localhost:8080/github-webhook/`
  - Nếu Jenkins chạy trên server: `http://your-server-ip:8080/github-webhook/`
- **Content type**: `application/json`
- **Secret**: (để trống)
- **Which events**: Chọn **Just the push event**
- **Active**: ✅

4. Click **Add webhook**

## Bước 5: Test Webhook

### 5.1. Test từ GitHub
1. Tạo một commit mới trên GitHub
2. Vào **Settings** > **Webhooks**
3. Click vào webhook vừa tạo
4. Xem **Recent Deliveries** để kiểm tra webhook có hoạt động không

### 5.2. Test từ Jenkins
1. Vào Jenkins job: `Group-Project-Pipeline`
2. Click **Build Now**
3. Xem **Console Output** để kiểm tra build có thành công không

## Bước 6: Troubleshooting

### Lỗi thường gặp:

#### 1. Webhook không trigger
- Kiểm tra URL webhook có đúng không
- Kiểm tra Jenkins có chạy không
- Kiểm tra firewall có chặn port 8080 không

#### 2. Authentication failed
- Kiểm tra Personal Access Token có đúng không
- Kiểm tra token có đủ quyền không
- Kiểm tra credentials trong Jenkins

#### 3. Git clone failed
- Kiểm tra Git có cài đặt không
- Kiểm tra repository URL có đúng không
- Kiểm tra credentials có quyền truy cập repository không

#### 4. Build failed
- Kiểm tra .NET SDK có cài đặt không
- Kiểm tra Jenkinsfile có đúng syntax không
- Xem Console Output để tìm lỗi cụ thể

### Logs hữu ích:
- **Jenkins logs**: `C:\Jenkins\logs\`
- **Job logs**: Trong job > Console Output
- **Webhook logs**: GitHub > Settings > Webhooks > Recent Deliveries

## Bước 7: Cấu hình nâng cao

### 7.1. Email notifications
1. Cài đặt plugin **Email Extension**
2. Cấu hình SMTP trong **Manage Jenkins** > **Configure System**
3. Thêm post-build action **Email Notification**

### 7.2. Slack notifications
1. Cài đặt plugin **Slack Notification**
2. Cấu hình Slack workspace
3. Thêm post-build action **Slack Notifications**

### 7.3. Docker integration
1. Cài đặt plugin **Docker Pipeline**
2. Cấu hình Docker trong Jenkinsfile
3. Sử dụng Docker containers cho build

## Kết quả mong đợi

Sau khi cấu hình xong:
- ✅ Mỗi khi push code lên GitHub, Jenkins sẽ tự động build
- ✅ Build logs có thể xem trên Jenkins web interface
- ✅ Artifacts được lưu trữ và có thể download
- ✅ Email/Slack notifications khi build thành công/thất bại
