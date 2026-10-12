pipeline {
    agent {
        label '1С'
    }

    environment {
        envString = 'true'
    }

    post {
        always {
            junit allowEmptyResults: true, testResults: 'build/reports/syntax-check/junit.xml'
            junit allowEmptyResults: true, testResults: 'build/reports/smoke/junit/*.xml'
            allure commandline: 'allure', includeProperties: false, jdk: '',
                   resultPolicy: 'LEAVE_AS_IS',
                   results: [
                       [path: 'build/reports/syntax-check/allure'],
                       [path: 'build/reports/smoke/allure']
                   ]
        }
        failure {
            bat "echo failure"
        }
        success {
            bat "echo success"
        }
    }

    stages {
        stage("Build test base") {
            steps {
                bat "chcp 65001"
                bat "vrunner infobase init --src \"C:\\jenkins\\template\\dev.dt\" --ibconnection \"/F C:\\repo\\sonar_repo\\build\\ib\""
                bat "vrunner cf load --ibconnection \"/F C:\\repo\\sonar_repo\\build\\ib\" \"C:\\repo\\sonar_repo\\src\""
            }
        }

        stage("Syntax check") {
            steps {
                bat "chcp 65001"
                bat "vrunner validate syntax-check --ibconnection \"/F C:\\repo\\sonar_repo\\build\\ib\" --report-format junit --report-format allure --report-path \"C:\\repo\\sonar_repo\\build\\reports\\syntax-check\""
            }
        }

        stage("Smoke tests") {
            steps {
                script {
                    try {
                        bat "chcp 65001"
                        bat "xrunner xunit --report-format junit --report-format allure --report-path \"C:\\repo\\sonar_repo\\build\\reports\\smoke\""
                    } catch (Exception Exc) {
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }
    }
}