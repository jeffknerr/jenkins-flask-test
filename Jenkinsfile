pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                sh 'python3 --version'
                sh 'sudo apt-get -y install python3-pip'
                sh 'ls -al /'
                sh 'id'
                sh 'ls -al /usr/local'
                sh 'sudo pip3 install pip3 --upgrade'
                sh 'sudo pip3 install flask'
                sh 'sudo pip3 install xmlrunner'
                sh 'sudo pip3 install gunicorn'
                sh 'sudo apt-get -y install nginx'
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
                sudo chmod +x .scripts/nginx.sh
                sudo ./scripts/nginx.sh
                '''
            }
        }
    }
}
