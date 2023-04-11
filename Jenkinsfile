pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                sh 'python3 --version'
                sh 'apt-get -y python3-pip'
                sh 'ls -al /'
                sh 'id'
                sh 'ls -al /usr/local'
                sh 'pip3 install pip3 --upgrade'
                sh 'pip3 install flask'
                sh 'pip3 install xmlrunner'
                sh 'pip3 install gunicorn'
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
