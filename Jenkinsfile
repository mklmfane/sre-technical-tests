pipeline {
    agent { label 'node01' }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', 
                    url: 'https://github.com/mklmfane/sre-technical-tests.git'
            }
        }

        stage('Launch Docker Compose') {
            steps {
                script {
                    dir('sre-technical-tests') {
                        sh '''
                            sudo chmod 666 /var/run/docker.sock
                            sudo usermod -aG docker vagrant
                            docker compose up -d
                        '''
                    }
                }
            }
        }

        stage('Initialize pass store') {
            steps {
                script {
                    sh '''
                      if ! gpg --list-keys | grep -q "AB4DAA5051BD73D7D0CEE1B1BB10C55A69E70712"; then
                          echo "GPG key not found! Please add the key."
                          exit 1
                      fi
                      if ! pass init "AB4DAA5051BD73D7D0CEE1B1BB10C55A69E70712"; then
                          echo "Pass store initialization failed!"
                          exit 1
                      fi
                    '''
                }
            }
        }

       stage('Login to DockerHub') {
        steps {
            withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                script {
                    sh '''
                    # Debug: Check GPG keys
                    echo "Listing GPG keys:"
                    gpg --list-keys

                    # Debug: List pass store contents
                    echo "Listing pass store contents:"
                    pass ls || {
                        echo "Pass store is not initialized! Exiting..."
                        exit 1
                    }

                    # Ensure Docker config directory exists
                    mkdir -p ~/.docker

                    # Use jq to create a valid Docker config JSON
                    echo '{}' | jq '.credsStore = "pass"' > ~/.docker/config.json

                    # Debug: Ensure the Docker config is valid
                    echo "Current Docker config:"
                    cat ~/.docker/config.json

                    # Attempt Docker login
                    echo "$DOCKER_PASSWORD" | docker --config ~/.docker login -u "$DOCKER_USERNAME" --password-stdin || {
                        echo "Docker login failed! Check your credentials."
                        exit 1
                    }

                    echo "Docker login succeeded."
                    '''
                }
              }
            }
        }


        stage('Create Docker Secret for Kubernetes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh '''
                        # Create Docker config JSON and encode it in base64
                        echo -n '{"auths":{"https://index.docker.io/v1/":{"username":"'"$DOCKER_USERNAME"'","password":"'"$DOCKER_PASSWORD"'","email":"mirceaconstantin58@gmail.com"}}}' | base64 -w 0 > ../dockerconfigjson_base64

                        # Check if the file was created successfully
                        if [ ! -s ../dockerconfigjson_base64 ]; then
                            echo "Error: Docker config JSON base64 file not created!"
                            exit 1
                        fi

                        # Generate Kubernetes Secret manifest
                        cat <<EOF > ../docker_secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: regcred
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: $(cat ../dockerconfigjson_base64)
EOF

                        # Apply Kubernetes Secret
                        kubectl apply -f ../docker_secrets.yaml || {
                            echo "Failed to apply Kubernetes secret!"
                            exit 1
                        }
                        '''
                    }
                }
            }
        }

        stage('First exercise') {
            steps {
                withKubeCredentials(kubectlCredentials: [[
                    caCertificate: '', 
                    clusterName: 'kubernetes', 
                    contextName: '', 
                    credentialsId: 'SECRET_TOKEN', 
                    namespace: 'jenkins', 
                    serverUrl: 'https://10.0.0.10:6443'
                ]]) {
                    script {
                        sh '''
                        curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl
                        chmod +x ./kubectl
                        ./kubectl apply -f ariane_deployment.yaml || {
                            echo "Failed to apply Kubernetes deployment!"
                            exit 1
                        }
                        '''
                    }
                }
            }
        }
    }
}