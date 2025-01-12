pipeline {
    agent any

    stages {
        stage('Authenticate to AWS') {
            steps {
                script {
                    echo 'Authenticating to AWS...'
                    
                    // Use Jenkins credentials for AWS authentication required to have aws credentials plugin
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_ACCESS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        	export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
                        	export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
                        	export AWS_DEFAULT_REGION=eu-west-1

                        	echo "AWS Account ID: $AWS_ACCOUNT_ID"
                        
                        	# Confirm AWS authentication
                        	aws sts get-caller-identity
                        '''
                    }
                }
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    // Requires to install terraform plugin in jenkins
                    echo 'Initializing Terraform...'
                    sh '''
                       terraform init
                    '''
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    // Requires to install terraform plugin in jenkins 
                    echo 'Running Terraform Plan...'
                    sh '''
                       terraform plan -var-file="terraform_vars.tfvars" -out=tfplan
                    '''
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    // Requires to install terraform plugin in jenkins
                    echo 'Applying Terraform Plan...'
                    sh '''
                       terraform apply -var-file="terraform_vars.tfvars" -auto-approve -out=tfplan
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
