pipeline {
    agent { 
        docker { 
            image 'python:3.10.7-alpine'
            args '-e HOME=/tmp/home'
        } 
    }
    stages {
        stage('build') {
            steps {
                sh 'python --version'
                sh 'ls -al /'
                sh 'id'
                sh 'ls -al /usr/local'
                sh 'pip install pip --upgrade'
                sh 'pip install flask'
                sh 'pip install xmlrunner'
            }
        }
        stage('test') {
            steps {
                sh 'python test.py'
            }
            post {
                always {junit 'test-reports/*.xml'}
            }
        }
    }
}
