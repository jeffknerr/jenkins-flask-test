pipeline {
    agent any
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
                sh 'pip install gunicorn'
                sh 'apt-get -y install nginx'
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
        stage('deploy') {
            steps {
                sh '''
                chmod +x .scripts/nginx.sh
                ./scripts/nginx.sh
                '''
            }
        }
    }
}
