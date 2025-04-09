pipeline {
    agent any

    environment {
        FLUTTER_HOME = 'C:/flutter_windows_3.24.4-stable/flutter'
        JAVA_HOME = 'C:/Program Files/Java/jdk-17'
        ANDROID_SDK_ROOT = 'C:/Users/Admin/AppData/Local/Android/Sdk'

        PATH = "${FLUTTER_HOME}/bin;${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin;${ANDROID_SDK_ROOT}/platform-tools;${JAVA_HOME}/bin;${env.PATH}"
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
    }

    post {
        always {
            echo '📦 Pipeline execution complete.'
        }
        success {
            echo '✅ Flutter build pipeline completed successfully!'

            // Archive the built APK
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
        }
        failure {
            echo '❌ Flutter build pipeline failed!'
        }
    }
}
