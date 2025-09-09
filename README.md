# Group Project - PRN212_4 - Fa25

## Mô tả dự án
Đây là dự án môn học C# với các tính năng:
- Kết nối cơ sở dữ liệu (Entity Framework Core)
- Tích hợp các tính năng AI (ML.NET)
- CI/CD với GitHub Actions và Jenkins

## Công nghệ sử dụng
- **.NET 8.0**
- **Entity Framework Core** - ORM cho database
- **ML.NET** - Machine Learning framework
- **SQL Server** - Database
- **GitHub Actions** - CI/CD
- **Jenkins** - CI/CD Pipeline

## Cấu trúc dự án
```
GroupProject/
├── GroupProject.csproj    # Project file
├── Program.cs             # Main entry point
└── ...
```

## Yêu cầu hệ thống
- .NET 8.0 SDK
- Visual Studio 2022 hoặc VS Code
- SQL Server (LocalDB hoặc Full version)
- Git

## Cài đặt và chạy
1. Clone repository:
```bash
git clone <repository-url>
cd Group-Project---PRN212_4---Fa25
```

2. Restore packages:
```bash
dotnet restore
```

3. Build project:
```bash
dotnet build
```

4. Run project:
```bash
dotnet run --project GroupProject
```

## CI/CD Pipeline
Dự án được cấu hình với:
- **GitHub Actions**: Tự động build, test và deploy
- **Jenkins**: Pipeline CI/CD nâng cao

## Đóng góp
1. Fork repository
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## License
Distributed under the MIT License. See `LICENSE` for more information.

## Liên hệ
- Project Link: [https://github.com/yourusername/Group-Project---PRN212_4---Fa25](https://github.com/yourusername/Group-Project---PRN212_4---Fa25)
