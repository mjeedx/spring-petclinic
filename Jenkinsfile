pipeline {
    agent { label 'ubuntu' }
    
    environment {
        TAG = "$BRANCH_NAME"+"."+"$BUILD_NUMBER"
    }
    
    stages {
        stage("Build JARtifact") {
            steps {             
                sh './mvnw package'
                sh 'mkdir docker'
                sh 'mv Dockerfile docker/'
                sh 'mv target/*.jar docker/main.jar'
            }            
        }
        stage("Build_image") {
            steps {
                
                dir ('docker') {
                    sh 'docker build -t petclinic:$BUILD_NUMBER .'
                    sh 'docker tag petclinic:$BUILD_NUMBER 178258651770.dkr.ecr.eu-central-1.amazonaws.com/petclinic:$TAG'
                }
                echo 'Keep going!'
            }
        }
        stage("Push image to ECR") {
            steps {
                //when { tag "release-*" }  //Deploy only if tag is relese-*
                script {
                    docker.withRegistry('https://178258651770.dkr.ecr.eu-central-1.amazonaws.com', 'ecr:eu-central-1:jenkins') {
                        docker.image('178258651770.dkr.ecr.eu-central-1.amazonaws.com/petclinic' + ':$TAG').push()
                    }
                }
                sh 'docker image prune -a -f'
            }
        }
        stage("Deploy to ECS") {
            steps {
                sh 'echo now you are in'
                sh 'pwd'
                ansiblePlaybook(
                    playbook: 'ansible/deploy_ecs.yml',
                    extras: '-e Work_env=Production'
                )
            
            }
        
        
        }
    }

}

