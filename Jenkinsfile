pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "aminshil/devops-app:${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps { 
                checkout scm 
            }
        }
        
        stage('Build & Test') {
            steps { 
                sh 'mvn clean compile'
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar \
                        -Dsonar.projectKey=devops-spring-app \
                        -Dsonar.projectName=DevOps-Spring-App'
                }
            }
        }
        
        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    kubectl set image deployment/spring-app-deployment spring-app=${DOCKER_IMAGE} -n devops
                    kubectl rollout status deployment/spring-app-deployment -n devops
                """
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        success {
            echo '🎉 Pipeline completed successfully!'
        }
    }
}
