# 🚀 Quick Start - Jenkins CI/CD Setup

## Tóm tắt nhanh

Dự án đã được cấu hình sẵn với:
- ✅ **GitHub Actions** - CI/CD tự động
- ✅ **Jenkinsfile** - Pipeline cho Jenkins
- ✅ **Webhook setup** - Tự động trigger từ GitHub

## 🎯 Mục tiêu

Khi có thay đổi trên Git → Jenkins tự động build và deploy

## 📋 Các bước thực hiện

### Bước 1: Cài đặt Jenkins (5 phút)

```powershell
# Chạy với quyền Administrator
.\scripts\install-jenkins.ps1
```

**Hoặc cài đặt thủ công:**
1. Cài đặt Java 11+
2. Download Jenkins WAR từ https://www.jenkins.io/download/
3. Chạy: `java -jar jenkins.war --httpPort=8080`
4. Truy cập: http://localhost:8080

### Bước 2: Cấu hình Jenkins (10 phút)

1. **Truy cập Jenkins**: http://localhost:8080
2. **Lấy admin password** từ console hoặc file
3. **Cài đặt suggested plugins**
4. **Tạo admin user**

### Bước 3: Tạo GitHub Token (5 phút)

1. GitHub → Settings → Developer settings → Personal access tokens
2. **Generate new token** với quyền:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `admin:repo_hook` (Full control of repository hooks)
   - ✅ `workflow` (Update GitHub Action workflows)
3. **Lưu lại token**

### Bước 4: Cấu hình Jenkins Job (10 phút)

1. **Manage Jenkins** → **Manage Credentials**
2. **Add Credentials**:
   - Kind: `Username with password`
   - Username: `your-github-username`
   - Password: `your-github-token`
   - ID: `github-token`

3. **New Item** → **Pipeline**:
   - Name: `Group-Project-Pipeline`
   - Pipeline script from SCM
   - Git: `https://github.com/TomOutfit/Group-Project---PRN212_4---Fa25.git`
   - Credentials: `github-token`
   - Script Path: `Jenkinsfile`

4. **Build Triggers**:
   - ✅ GitHub hook trigger for GITScm polling

### Bước 5: Cấu hình Webhook (5 phút)

1. GitHub → Repository → Settings → Webhooks
2. **Add webhook**:
   - Payload URL: `http://localhost:8080/github-webhook/`
   - Content type: `application/json`
   - Events: `Just the push event`

### Bước 6: Test (2 phút)

```powershell
# Test pipeline
.\scripts\test-pipeline.ps1

# Hoặc test thủ công
git add .
git commit -m "Test webhook"
git push origin main
```

## 🔧 Scripts có sẵn

| Script | Mô tả |
|--------|-------|
| `scripts/install-jenkins.ps1` | Cài đặt Jenkins tự động |
| `scripts/setup-jenkins-job.ps1` | Cấu hình Jenkins job |
| `scripts/test-pipeline.ps1` | Test pipeline |

## 📁 Files quan trọng

| File | Mô tả |
|------|-------|
| `Jenkinsfile` | Pipeline configuration |
| `.github/workflows/ci-cd.yml` | GitHub Actions |
| `jenkins-config.xml` | Jenkins job config |
| `webhook-setup.md` | Hướng dẫn webhook chi tiết |

## 🎉 Kết quả mong đợi

Sau khi cấu hình xong:

1. **Push code lên GitHub** → Jenkins tự động build
2. **Build logs** có thể xem trên Jenkins
3. **Artifacts** được lưu trữ tự động
4. **Email/Slack notifications** (tùy chọn)

## 🆘 Troubleshooting

### Lỗi thường gặp:

| Lỗi | Giải pháp |
|-----|-----------|
| Jenkins không chạy | Kiểm tra Java, port 8080 |
| Webhook không trigger | Kiểm tra URL, firewall |
| Build failed | Kiểm tra .NET SDK, Git |
| Authentication failed | Kiểm tra GitHub token |

### Logs hữu ích:
- **Jenkins logs**: `C:\Jenkins\logs\`
- **Job logs**: Jenkins → Job → Console Output
- **Webhook logs**: GitHub → Settings → Webhooks

## 📞 Hỗ trợ

Nếu gặp vấn đề:
1. Xem file `docs/jenkins-setup.md` để biết chi tiết
2. Xem file `webhook-setup.md` để cấu hình webhook
3. Chạy `scripts/test-pipeline.ps1` để debug

---

**🎯 Mục tiêu đạt được**: Mỗi khi push code lên GitHub, Jenkins sẽ tự động build và deploy!
