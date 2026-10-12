pipeline
{
    agent {
        label '1C'
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
        stage("stage") {
            bat "echo Messages from steps"
            bat "echo envString = ${envString}"

            script {
                scannerHome = tool "sonar-scanner"
            }
        }
    }
}