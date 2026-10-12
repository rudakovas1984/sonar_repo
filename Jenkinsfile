pipeline
{
    agent {
        label '1С'
    }

    environment {
        envString = 'true'
    }

    post {
        always {
            allure commandline: 'allure', includeProperties: false, jdk: '', resultPolicy: 'LEAVE_AS_IS', results: [[path: 'build/reports/syntax-check/allure'], [path: 'build/reports/smoke/allure']]
            junit allowEmptyResults: true, 'build/reports/syntax-check/junit.xml'
            junit allowEmptyResults: true, 'build/reports/smoke/junit/*.xml'
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
                bat "vrunner validate syntax-check --ibconnection \"/F C:\\repo\\sonar_repo\\build\\ib\""
            }
        }
        stage("Smoke tests") {
            steps {
                script {
                    try {
                        bat "chcp 65001"
                        bat "xrunner xunit"
                    }
                    catch(Exception Exc) {
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }
    }
}