pipeline {
    agent any
    environment {
        // Set your AWS credentials here
        AWS_DEFAULT_REGION = credentials('REGION')
        AWS_ECR_REPO = credentials('ECR_REPO')
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        
        // Define backend and frontend repositories
        BACKEND_REPO = 'backend'
        FRONTEND_REPO = 'frontend'
    }
    stages {
        stage("Docker Login") {
            steps {
                script {
                    // Authenticate Docker with AWS ECR
                    sh "aws ecr-public get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_REPO}"
                }
            }
        }
        stage("Git Checkout") {
            steps {
                // Cleanup Workspace before checkout
                cleanWs()
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/pranay0706/TWSThreeTierAppChallenge']])
            }
        }
        stage("Remove Existing Docker Images") {
            steps {
                script {
                    // Remove existing Docker images
                    sh 'docker rmi -f $(docker images -q)'
                }
            }
        }
        stage("Build Docker Images") {
            steps {
                script {
                    // Change to the backend directory and build the Docker image
                    dir(BACKEND_REPO) {
                        sh "docker build -t ${BACKEND_REPO}:latest ."
                    }

                    // Change to the frontend directory and build the Docker image
                    dir(FRONTEND_REPO) {
                        sh "docker build -t ${FRONTEND_REPO}:latest ."
                    }
                }
            }
        }
        stage("Tag Docker Images") {
            steps {
                script {
                    // Tag backend-tier Docker images
                    sh "docker tag ${BACKEND_REPO}:latest ${AWS_ECR_REPO}/${BACKEND_REPO}:latest"

                    // Tag frontend-tier Docker images
                    sh "docker tag ${FRONTEND_REPO}:latest ${AWS_ECR_REPO}/${FRONTEND_REPO}:latest"
                }
            }
        }
        stage("Push Docker Images to AWS ECR") {
            steps {
                script {
                    // Push backend-tier Docker images to AWS ECR
                    sh "docker push ${AWS_ECR_REPO}/${BACKEND_REPO}:latest"

                    // Push frontend-tier Docker images to AWS ECR
                    sh "docker push ${AWS_ECR_REPO}/${FRONTEND_REPO}:latest"
                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('terraform-jenkins-eks'){
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('terraform-jenkins-eks'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('terraform-jenkins-eks'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the Infra using Terraform'){
            steps{
                script{
                    dir('terraform-jenkins-eks'){
                        sh 'terraform plan'
                    }
                    input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }
        stage('Creating/Destroying an EKS Cluster'){
            steps{
                script{
                    dir('terraform-jenkins-eks') {
                        sh 'terraform $action --auto-approve'
                    }
                }
            }
        }
    }
}