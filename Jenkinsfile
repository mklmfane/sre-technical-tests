pipeline {
    agent { label 'node01' }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    git branch: 'master',
                        url: 'https://github.com/mklmfane/sre-technical-tests.git'
                    sh '''
                        echo "Checking repository contents after cloning:"
                        ls -l
                    '''
                }
            }
        } 

        stage('Debug File Check') {
            steps {
                script {
                    dir('/home/vagrant/workspace/jenkis-test') {
                    sh '''
                        echo "Current directory contents:"
                        ls -l
                    
                        echo "Checking if docker-compose.yml exists..."
                    
                        docker compose version
                    
                        if [ ! -f docker-compose.yml ]; then
                            echo "docker-compose.yml not found in the current directory!"
                            pwd
                            ls -l
                            exit 1
                        fi
                    '''
                }
                }
            }
        }

        stage('Clean Up Existing Containers') {
            steps {
                script {
                    sh '''
                        echo "Stopping and removing all running containers..."
                        docker ps -q | xargs -r docker stop
                        docker ps -aq | xargs -r docker rm
                        
                        echo "Cleaning up unused resources..."
                        docker network prune -f
                        docker volume prune -f
                    '''
                }
            }
        }

        stage('Launch Docker Compose') {
            steps {
                script {
                    dir('/home/vagrant/workspace/jenkis-test') {
                        sh '''
                            pwd
                            ls
                            echo "Checking docker-compose.yml..."
                            if [ ! -f docker-compose.yml ]; then
                                echo "Error: docker-compose.yml not found!"
                                exit 1
                            fi
                            
                            cat docker-compose.yml
        
                            echo "Launching Docker Compose..."
                            docker compose up -d || { echo "Docker Compose launch failed!"; exit 1; }
                        '''
                    }
                }
            }
        }

       
       stage('Validate Docker Login') {
         steps {
            script {
                sh '''
                    echo "Checking Docker login status..."
                    if ! docker info >/dev/null 2>&1; then
                        echo "Logging into Docker Hub..."
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || {
                        echo "Docker login failed!"
                        exit 1
                    }
                    else
                        echo "Docker is already logged in."
                    fi
                '''
         }
        }
        }
                

       stage('Login to DockerHub to tag and push docker images to my dockerhub registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh '''
                        set -e
        
                        # Ensure Docker config directory exists
                        mkdir -p ~/.docker
        
                        # Create or update Docker config with credsStore set to 'pass'
                        echo '{}' | jq '.credsStore = "pass"' > ~/.docker/config.json
        
                        # Check if Docker is already logged in
                        if docker --config ~/.docker info > /dev/null 2>&1; then
                            echo "Docker is already logged in."
                        else
                            echo "Logging into Docker Hub..."
                            echo "$DOCKER_PASSWORD" | docker --config ~/.docker login -u "$DOCKER_USERNAME" --password-stdin || {
                                echo "Docker login failed! Check your credentials."
                                exit 1
                            }
                        fi
        
                        echo "Docker login succeeded."
        
                        # Tag and push each image
                        for image in jenkis-test-ariane jenkis-test-falcon jenkis-test-redis; do
                            docker tag $image:latest $DOCKER_USERNAME/$image:latest
        
                            # Push images with retries
                            for attempt in $(seq 1 3); do
                                echo "Attempting to push $DOCKER_USERNAME/$image:latest (Attempt $attempt)"
                                docker push $DOCKER_USERNAME/$image:latest && break || sleep 5
                                if [ "$attempt" -eq 3 ]; then
                                    echo "Failed to push $DOCKER_USERNAME/$image:latest after 3 attempts. Exiting..."
                                    exit 1
                                fi
                            done
                        done
        
                        echo "All images pushed successfully."
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
  namespace: jenkins
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
                        curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl
                        chmod +x ./kubectl
                        
                        ./kubectl apply -f configmap.yaml || {
                            echo "Failed to kubernetes configmap!"
                            exit 1
                        }
                        
                        ./kubectl apply -f persistent_volume.yaml || {
                            echo "Persistent volumes were successfully created"
                            exit 1
                        }
                        
                        ./kubectl apply -f ariane_deployment.yaml || {
                            echo "Failed to apply Frontend deployment!"
                            exit 1
                        }
                        
                        ./kubectl apply -f falcon_deployment.yaml || {
                            echo "Failed to apply Backend deployment!"
                            exit 1
                        }
                        
                        ./kubectl apply -f redis_deployment.yaml || {
                            echo "Failed to apply Backend deployment!"
                            exit 1
                        }
                        '''
                    }
                }
            }
        }
    }
}
