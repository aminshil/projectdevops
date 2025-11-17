pipeline {
    agent any

    stages {

        // Page 18 → GIT
        stage('GIT') {
            steps {
                echo "Cloning project from GitHub..."
                checkout scm  // or change to Git URL if needed
            }
        }

        // Page 19 → mvn clean
        stage('MVN CLEAN') {
            steps {
                sh 'mvn clean'
            }
        }

        // Page 19 → mvn compile
        stage('MVN COMPILE') {
            steps {
                sh 'mvn compile'
            }
        }

        // Page 20–21 → sonar:sonar
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''
                        mvn sonar:sonar \
                        -Dsonar.projectKey=devops-spring-app \
                        -Dsonar.projectName=DevOps-Spring-App
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "🎉 SonarQube analysis completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}

