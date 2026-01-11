pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t fastapi-ml-skeleton:${BUILD_NUMBER} .'
                    sh 'docker tag fastapi-ml-skeleton:${BUILD_NUMBER} fastapi-ml-skeleton:latest'
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                        kubectl create namespace staging --dry-run=client -o yaml | kubectl apply -f -
                        helm upgrade --install fastapi-ml ./helm/fastapi-ml \
                          -n staging \
                          --set image.tag=${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Verify') {
            steps {
                script {
                    sh 'kubectl -n staging get pods'
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline succeeded!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
