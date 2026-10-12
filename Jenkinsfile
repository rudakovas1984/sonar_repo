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
            bat "echo always"
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
                bat "chcp 65001\n vrunner infobase init --src \"C:\\jenkins\\template\\dev.dt\" --ibconnection \"/F C:\\repo\\sonar_repo\\build\\ib\"\n vrunner cf load --ibconnection \"/F C:\\repo\\sonar_repo\\build\\ib\" \"C:\\repo\\sonar_repo\\src\""
            }
        }
    }
}