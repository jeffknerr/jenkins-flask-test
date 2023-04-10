# jenkins-flask-test
simple demo/learning to use jenkins

- https://www.jenkins.io/doc/pipeline/tour/hello-world/
- https://pkuwwt.github.io/programming/2020-03-16-jenkins-continuous-integration-testing-for-flask/

## downloaded jenkins.war file to /local
```
10013  4/10/2023 11:53  cd /local
10016  4/10/2023 11:55  jarsigner -verify -verbose jenkins.war
10017  4/10/2023 11:58  sha256sum jenkins.war
```

## ran war file, set up user, installed plugins (Docker Pipeline)
```
java -jar jenkins.war --httpPort=8080
browse to http://localhost:8080
```


## make a dummy repo, cloned it, added app stuff
```
10040  4/10/2023 12:22  cd repos
10042  4/10/2023 12:24  git clone git@github.com:jeffknerr/jenkins-flask-test.git
10043  4/10/2023 12:25  cd jenkins-flask-test
10045  4/10/2023 12:25  vim README.md
10047  4/10/2023 12:25  vim app.py
10048  4/10/2023 12:26  vim test.py
10050  4/10/2023 12:27  python3 -m venv venv
10051  4/10/2023 12:27  source ./venv/bin/activate
10052  4/10/2023 12:27  pip install flask
10053  4/10/2023 12:28  python3 test.py
.
----------------------------------------------------------------------
Ran 1 test in 0.012s

OK
```

## added Jenkinsfile

```
pipeline {
    agent { docker { image 'python:3.7.2' } }
    stages {
        stage('build') {
            steps {
                sh 'pip install flask
            }
        }
        stage('test') {
            steps {
                sh 'python test.py'
            }
        }
    }
}
```

## already installed jenkins above

## added Pipeline

- Pipeline script from SCM
- SCP set to Git with url: https://github.com/jeffknerr/jenkins-flask-test
- save

## test report xml stuff??

in test.py

```
if __name__ == '__main__':
    import xmlrunner
    runner = xmlrunner.XMLTestRunner(output='test-reports')
    unittest.main(testRunner=runner)
```

in Jenkinsfile

```
        stage('test') {
            steps {
                sh 'python test.py'
            }
            post {
                always {junit 'test-reports/*.xml'}
```
