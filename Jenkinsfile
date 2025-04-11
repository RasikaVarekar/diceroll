pipeline {
    agent any

    environment {
        FLUTTER_HOME = 'C:/flutter_windows_3.24.4-stable/flutter'
        JAVA_HOME = 'C:/Program Files/Java/jdk-17'
        ANDROID_SDK_ROOT = 'C:/Users/Admin/AppData/Local/Android/Sdk'
        IMAGE_NAME = 'rasikavarekar1403/flutter-diceroll'
        DOCKER_HOME = 'C:/Program Files/Docker/Docker/resources/bin'
        DOCKERHUB_CREDENTIALS = credentials('8c658dd0-a24f-419e-9ea6-dc6d1a7e2740')

        PATH = "${DOCKER_HOME};${FLUTTER_HOME}/bin;${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin;${ANDROID_SDK_ROOT}/platform-tools;${JAVA_HOME}/bin;${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/RasikaVarekar/diceroll.git', branch: 'main'
            }
        }

        stage('Flutter Version') {
            steps {
                bat 'flutter --version'
            }
        }

        stage('Flutter Doctor') {
            steps {
                bat 'flutter doctor -v'
            }
        }

        stage('Accept Android Licenses') {
            steps {
                bat '"%ANDROID_SDK_ROOT%\\cmdline-tools\\latest\\bin\\sdkmanager.bat" --licenses < NUL'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'flutter pub get'
            }
        }

        stage('Analyze Code') {
            steps {
                script {
                    def result = bat(script: 'flutter analyze', returnStatus: true)
                    if (result != 0) {
                        echo "Flutter analyze finished with warnings."
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                bat 'flutter test'
            }
        }

        stage('Build Release APK') {
            steps {
                bat 'flutter clean'
                bat 'flutter build apk --release'
            }
        }

        stage('Docker Build & Push') {
            when {
                expression {
                    fileExists('build/app/outputs/flutter-apk/app-release.apk')
                }
            }
            steps {
                script {
                    // Create Dockerfile dynamically
                    writeFile file: 'Dockerfile', text: '''
                    FROM nginx:alpine
                    WORKDIR /usr/share/nginx/html
                    COPY build/app/outputs/flutter-apk/app-release.apk .
                    RUN echo "<html><body><h2>Dice Roll App</h2><a href='app-release.apk' download>Download APK</a></body></html>" > index.html
                    EXPOSE 80
                    CMD ["nginx", "-g", "daemon off;"]
                    '''.stripIndent()

                    withCredentials([usernamePassword(
                        credentialsId: '8c658dd0-a24f-419e-9ea6-dc6d1a7e2740',
                        usernameVariable: 'DOCKER_HUB_USER',
                        passwordVariable: 'DOCKER_HUB_PASSWORD'
                    )]) {
                        def tag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                        bat "docker build -t ${env.IMAGE_NAME}:latest ."
                        bat "docker tag ${env.IMAGE_NAME}:latest ${tag}"
                        bat "docker login -u %DOCKER_HUB_USER% -p %DOCKER_HUB_PASSWORD%"
                        bat "docker push ${env.IMAGE_NAME}:latest"
                        bat "docker push ${tag}"
                    }

                    echo "✅ Docker image build & push successful!"
                }
            }
        }
    }

    post {
        always {
            echo '📦 Pipeline execution complete.'
        }
        success {
            echo '✅ Flutter build pipeline completed successfully!'
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
        }
        failure {
            echo '❌ Flutter build pipeline failed!'
        }
    }
}
