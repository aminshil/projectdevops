cat > Jenkinsfile << 'EOF'
pipeline {
    agent any
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
        
        // Étape SonarQube Analysis du PDF (Page 20)
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar -Dsonar.coverage.exclusions="**/test/**" \
                        -Dsonar.projectKey=devops-spring-app \
                        -Dsonar.projectName=DevOps-Spring-App'
                }
            }
        }
        
        // Déploiement direct avec votre image existante
        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    kubectl set image deployment/spring-app-deployment spring-app=amineshil/student-management-backend:latest -n devops
                    kubectl rollout status deployment/spring-app-deployment --timeout=600s -n devops
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
EOF
