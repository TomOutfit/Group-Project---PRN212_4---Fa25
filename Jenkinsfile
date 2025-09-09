pipeline {
    agent any
    
    environment {
        DOTNET_VERSION = '8.0'
        BUILD_CONFIGURATION = 'Release'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup .NET') {
            steps {
                script {
                    // Install .NET SDK if not available
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
        
        stage('Restore Dependencies') {
            steps {
                sh 'dotnet restore GroupProject.sln'
            }
        }
        
        stage('Build') {
            steps {
                sh "dotnet build GroupProject.sln --configuration ${BUILD_CONFIGURATION} --no-restore"
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Run tests if any exist
                    sh '''
                        if [ -d "GroupProject.Tests" ]; then
                            dotnet test --configuration ${BUILD_CONFIGURATION} --no-build --verbosity normal
                        else
                            echo "No test project found, skipping tests"
                        fi
                    '''
                }
            }
        }
        
        stage('Publish') {
            steps {
                sh "dotnet publish GroupProject/GroupProject.csproj --configuration ${BUILD_CONFIGURATION} --output ./publish --no-build"
            }
        }
        
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'publish/**/*', fingerprint: true
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "Deploying to production environment..."
                    // Add your deployment steps here
                    // Example: copy files to server, run deployment scripts, etc.
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
