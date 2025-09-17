pipeline {
    agent any
    
    environment {
        DOTNET_VERSION = '8.0'
        BUILD_CONFIGURATION = 'Release'
        PROJECT_NAME = 'FoodBook_PRN212_Group4_Fa25'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Check Repository') {
            steps {
                script {
                    sh '''
                        echo "FoodBook Project - PRN212 Group4 Fa25"
                        echo "Repository structure:"
                        ls -la
                        echo ""
                        echo "Checking for .NET projects..."
                        find . -name "*.sln" -o -name "*.csproj" | head -10
                    '''
                }
            }
        }
        
        stage('Setup .NET') {
            when {
                anyOf {
                    changeset "**/*.sln"
                    changeset "**/*.csproj"
                    changeset "**/*.cs"
                }
            }
            steps {
                script {
                    sh '''
                        if ! command -v dotnet &> /dev/null; then
                            echo "Installing .NET SDK..."
                            curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version 8.0.0
                            export PATH="$HOME/.dotnet:$PATH"
                        fi
                        dotnet --version
                    '''
                }
            }
        }
        
        stage('Build .NET Projects') {
            when {
                anyOf {
                    changeset "**/*.sln"
                    changeset "**/*.csproj"
                    changeset "**/*.cs"
                }
            }
            steps {
                script {
                    sh '''
                        if [ -f "*.sln" ]; then
                            echo "Found solution file, building..."
                            dotnet restore *.sln
                            dotnet build *.sln --configuration Release
                        elif [ -f "*.csproj" ]; then
                            echo "Found project file, building..."
                            dotnet restore *.csproj
                            dotnet build *.csproj --configuration Release
                        else
                            echo "No .NET projects found, skipping build"
                        fi
                    '''
                }
            }
        }
        
        stage('Test .NET Projects') {
            when {
                anyOf {
                    changeset "**/*.sln"
                    changeset "**/*.csproj"
                    changeset "**/*.cs"
                }
            }
            steps {
                script {
                    sh '''
                        if [ -d "*Tests" ] || [ -f "*Tests.csproj" ]; then
                            echo "Running tests..."
                            dotnet test --configuration Release --verbosity normal
                        else
                            echo "No test projects found, skipping tests"
                        fi
                    '''
                }
            }
        }
        
        stage('Publish .NET Projects') {
            when {
                anyOf {
                    changeset "**/*.sln"
                    changeset "**/*.csproj"
                    changeset "**/*.cs"
                }
            }
            steps {
                script {
                    sh '''
                        if [ -f "*.sln" ]; then
                            echo "Publishing solution..."
                            dotnet publish *.sln --configuration Release --output ./publish
                        elif [ -f "*.csproj" ]; then
                            echo "Publishing project..."
                            dotnet publish *.csproj --configuration Release --output ./publish
                        else
                            echo "No .NET projects to publish"
                        fi
                    '''
                }
            }
        }
        
        stage('Archive Artifacts') {
            when {
                anyOf {
                    changeset "**/*.sln"
                    changeset "**/*.csproj"
                    changeset "**/*.cs"
                }
            }
            steps {
                archiveArtifacts artifacts: 'publish/**/*', fingerprint: true, allowEmptyArchive: true
            }
        }
        
        stage('Repository Status') {
            steps {
                script {
                    sh '''
                        echo "✅ FoodBook Project is clean and ready for development"
                        echo "📁 Current structure:"
                        ls -la
                        echo ""
                        echo "🚀 To start developing FoodBook:"
                        echo "1. Create your .NET project"
                        echo "2. Add your FoodBook source code"
                        echo "3. CI/CD will automatically build and deploy"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}