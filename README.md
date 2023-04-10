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
                sh 'pip install flask'
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
- set branch to be "main" not "master"
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

## need to start docker service

```
10091* 4/10/2023 12:58  ps -ef | grep docker
10093* 4/10/2023 12:59  sudo systemctl start docker.service
10094* 4/10/2023 12:59  sudo systemctl status docker.service
10095* 4/10/2023 12:59  docker images
```

## also need apparmor running???!?!?

```
10096* 4/10/2023 13:01  dpkg -l | grep apparmor
10097* 4/10/2023 13:01  sudo apt-get install apparmor
10115* 4/10/2023 13:09  sudo apt-get install apparmor-utils apparmor-profiles apparmor-profiles-extra vim-addon-manager
10116* 4/10/2023 13:09  sudo systemctl restart docker.service
10117* 4/10/2023 13:09  sudo systemctl restart apparmor.service
```

## still failing....

Are these errors in the docker container???

```
Installing collected packages: MarkupSafe, Werkzeug, zipp, typing-extensions, importlib-metadata, Jinja2, click, itsdangerous, flask
  Running setup.py install for MarkupSafe: started
    Running setup.py install for MarkupSafe: finished with status 'error'
    Complete output from command /usr/local/bin/python -u -c "import setuptools, tokenize;__file__='/tmp/pip-install-wj4iufrq/MarkupSafe/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" install --record /tmp/pip-record-qn1pq3ak/install-record.txt --single-version-externally-managed --compile:
...
...
    gcc -pthread -Wno-unused-result -Wsign-compare -DNDEBUG -g -fwrapv -O3 -Wall -fPIC -I/usr/local/include/python3.7m -c src/markupsafe/_speedups.c -o build/temp.linux-x86_64-3.7/src/markupsafe/_speedups.o
    gcc -pthread -shared build/temp.linux-x86_64-3.7/src/markupsafe/_speedups.o -L/usr/local/lib -lpython3.7m -o build/lib.linux-x86_64-3.7/markupsafe/_speedups.cpython-37m-x86_64-linux-gnu.so
    running install_lib
    creating /usr/local/lib/python3.7/site-packages/markupsafe
    error: could not create '/usr/local/lib/python3.7/site-packages/markupsafe': Permission denied
    
    ----------------------------------------
Command "/usr/local/bin/python -u -c "import setuptools, tokenize;__file__='/tmp/pip-install-wj4iufrq/MarkupSafe/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" install --record /tmp/pip-record-qn1pq3ak/install-record.txt --single-version-externally-managed --compile" failed with error code 1 in /tmp/pip-install-wj4iufrq/MarkupSafe/
You are using pip version 19.0.3, however version 23.0.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (test)
Stage "test" skipped due to earlier failure(s)
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
$ docker stop --time=1 7dd718bbc2be9b22d697629d47687e2b349af5df4941ca7cc995711d45073c2e
$ docker rm -f --volumes 7dd718bbc2be9b22d697629d47687e2b349af5df4941ca7cc995711d45073c2e
[Pipeline] // withDockerContainer
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: script returned exit code 1
Finished: FAILURE
```

## try again with ubuntu install

Thinking the problem is that `jenkins` is running as me, not as
user `jenkins`. Try the `apt-get` route to install debian/ubuntu packages...

```
10156  4/10/2023 13:48  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \\n  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
10163  4/10/2023 13:50  sudo vim  /etc/apt/sources.list.d/jenkins.list
deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/
10164  4/10/2023 13:50  sudo apt update
10165  4/10/2023 13:51  sudo apt install jenkins
10166  4/10/2023 13:51  ps -ef | grep jenk
10167  4/10/2023 13:52  java --version
10168  4/10/2023 13:52  sudo systemctl status jenkins
10169  4/10/2023 13:53  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Now go to localhost port 8080 and redo the above user creation and
plugin installs...


