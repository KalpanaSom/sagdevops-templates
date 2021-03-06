// curl -X POST -F "jenkinsfile=<Jenkinsfile.builder" http://ccbvtauto.eur.ad.sag:8080/pipeline-model-converter/validate

def buildAndTest(release) {
    sh """
    . ./${release}.env
    docker-compose build cc
    
    cd templates/sag-spm-config
    docker-compose run --rm provision
    docker-compose build
    cd ../..
    
    docker-compose push cc
    """
}

pipeline {
    agent {
        label 'docker'
    }
    environment {
        CC_TAG = '10.3'
    }
    stages {
        stage('Build') {
            parallel {
                stage('10.3') {
                    steps {
                        buildAndTest('10.3')
                    }
                }
                stage('10.2') {
                    steps {
                        buildAndTest('10.2')
                    }
                }
                stage('10.1') {
                    steps {
                        buildAndTest('10.1')
                    }
                }                                                
            }            
        }
    }
}
