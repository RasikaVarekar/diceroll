pipeline {
    agent any

    environment {
        FLUTTER_HOME = 'C:/flutter_windows_3.24.4-stable/flutter'
        GIT_HOME = 'C:/Program Files/Git/bin'
        ANDROID_SDK_ROOT = 'C:/Users/Admin/AppData/Local/Android/Sdk'
    }

    options {
        timeout(time: 20, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def gitRepoUrl = 'https://github.com/RasikaVarekar/diceroll.git'
                    checkout([$class: 'GitSCM', 
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[url: gitRepoUrl]],
                        extensions: [[$class: 'CleanBeforeCheckout']]
                    ])
                }
            }
        }

        stage('Check Git Version') {
            steps {
                bat '''
                    echo 🔍 Checking git version...
                    "C:/Program Files/Git/bin/git.exe" --version
                '''
            }
        }

        stage('Flutter Clean') {
            steps {
                bat '''
                    set PATH=C:/flutter_windows_3.24.4-stable/flutter/bin;%PATH%
                    flutter clean
                '''
            }
        }

        stage('Flutter Pub Get') {
            steps {
                bat '''
                    set PATH=C:/flutter_windows_3.24.4-stable/flutter/bin;%PATH%
                    echo ✅ Running flutter pub get...
                    flutter pub get || (echo ❌ flutter pub get failed! && exit 1)
                '''
            }
        }

        stage('Analyze Code') {
            steps {
                bat '''
                    set PATH=C:/flutter_windows_3.24.4-stable/flutter/bin;%PATH%
                    echo ✅ Analyzing code...
                    flutter analyze || (echo ❌ flutter analyze failed! && exit 1)
                '''
            }
        }

        stage('Run Tests') {
            steps {
                bat '''
                    set PATH=C:/flutter_windows_3.24.4-stable/flutter/bin;%PATH%
                    echo ✅ Running tests...
                    flutter test || (echo ❌ flutter test failed! && exit 1)
                '''
            }
        }
    }

    post {
        failure {
            echo '❌ Flutter build pipeline failed!'
        }
        success {
            echo '✅ Flutter build pipeline completed successfully!'
        }
    }
}
