
pipeline {
    agent any

    environment {
        IMAGE = "devsecops-demo:${BUILD_NUMBER}"
    }

    triggers {
        githubPush()   // Requires webhook setup
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/<your-username>/ci-cd-devsecops-demo.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }

        stage('Test') {
            steps {
                sh 'chmod +x test.sh'
                sh './test.sh'
            }
            post {
                always {
                    junit 'test-results/*.xml'
                }
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                ./dependency-check/bin/dependency-check.sh \
                --project "demo" \
                --scan . \
                --format XML \
                --out security-report
                '''
            }
        }

        stage('Fail on Vulnerability') {
            steps {
                script {
                    def report = readFile('security-report/dependency-check-report.xml')
                    if (report.contains("<severity>CRITICAL</severity>")) {
                        error "Critical vulnerability found!"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Deploy DEV') {
            steps {
                sh 'chmod +x deploy.sh'
                sh './deploy.sh dev $IMAGE'
            }
        }

        stage('Deploy QA') {
            steps {
                sh './deploy.sh qa $IMAGE'
            }
        }

        stage('Deploy PROD') {
            steps {
                sh './deploy.sh prod $IMAGE'
            }
        }
    }
}
