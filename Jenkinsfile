pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "aminshil/devops-app:${env.BUILD_NUMBER}"
    }
    stages {
        // Étape GIT du PDF (Page 18)
        stage('GIT') {
            steps {
                echo "Getting Project from Git"
                checkout scm 
            }
        }
        
        // Étape MVN CLEAN du PDF (Page 19)
        stage('MVN CLEAN') {
            steps {
                sh 'mvn clean -DskipTests'
            }
        }
        
        // Étape MVN COMPILE du PDF (Page 19) 
        stage('MVN COMPILE') {
            steps {
                sh 'mvn compile -DskipTests'
            }
        }
        
        // Étape SonarQube Analysis du PDF (Page 20) - IMPORTANT: Garder sans skipTests
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar -Dsonar.coverage.exclusions="**/test/**" \
                        -Dsonar.projectKey=devops-spring-app \
                        -Dsonar.projectName=DevOps-Spring-App'
                }
            }
        }
        
        // Étapes supplémentaires pour le déploiement
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
