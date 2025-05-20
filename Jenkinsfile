pipeline {
    agent any

    environment {
        TERRAFORM_VERSION = "1.6.6"
        TERRAFORM_ZIP = "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
        AWS_REGION = "us-"  // Set your AWS region here as plain text
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/KKDevOps07/aws-infra.git'
            }
        }
        stages ('Check unzip') {
            steps {
                sh 'which unzip || sudo apt-get update && sudo apt-get install -y unzip'
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                   if ! command -v terraform >/dev/null 2>&1; then
                       echo "Terraform not found. Installing..."
                       curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIP}
                       unzip ${TERRAFORM_ZIP}
                       sudo mv terraform /usr/local/bin/
                       rm ${TERRAFORM_ZIP}
                   else
                       echo "Terraform is already installed."
                   fi
                   terraform version
                '''
            }
        }

        stage('Terraform Format & Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform fmt -check'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Infrastructure provisioned successfully!'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}