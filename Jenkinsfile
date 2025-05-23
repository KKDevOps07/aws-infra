pipeline {
    agent any

    environment {
        TERRAFORM_VERSION = "1.6.6"
        TERRAFORM_ZIP = "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
        AWS_REGION = "us-west-2"
        PATH = "${env.HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/KKDevOps07/aws-infra.git'
            }
        }

        stage('Check unzip') {
            steps {
                sh '''
                    if command -v unzip > /dev/null; then
                        echo "✅ unzip is already installed."
                    else
                        echo "❌ unzip is not installed. Trying to install..."
                        sudo apt-get update && sudo apt-get install -y unzip
                    fi
                '''
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                    if ! command -v terraform >/dev/null 2>&1; then
                        echo "Terraform not found. Installing..."
                        curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIP}
                        rm -rf terraform_bin
                        unzip -o ${TERRAFORM_ZIP} -d terraform_bin
                        mkdir -p $HOME/bin
                        mv terraform_bin/terraform $HOME/bin/
                        rm -rf terraform_bin ${TERRAFORM_ZIP}
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
                    sh 'terraform fmt'         // Auto-format to avoid pipeline failure
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    withCredentials([
                        string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    withCredentials([
                        string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    withCredentials([
                        string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
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