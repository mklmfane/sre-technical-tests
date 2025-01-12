# devops/sre.technical-tests

This test is designed to evaluate your skills and experience in various aspects of the role for which you applied, including Virtualization, AWS Cloud management, Continuous Integration/Continuous Deployment (CI/CD), Infrastructure as Code (IaC), among others.

This test is designed to be completed in approximately 10–12 hours for the core tasks, assuming familiarity with the required tools and concepts. 
Bonus tasks may require an additional 6–8 hours if attempted. It is recommended to plan your time accordingly.

__You are encouraged to complete the core tasks first, as they are essential for demonstrating the foundational skills required for this position. Bonus tasks are optional and intended to showcase advanced expertise.__

Tasks

  - Core tasks are self-contained and can be completed independently.
  - Bonus tasks:
    - The CI/CD pipeline assumes that the containerization task has been completed.
      I have the Jenkinsfile for CI/CD pipeline. 
    - The monitoring and performance optimization task builds on work done in the containerization and infrastructure as code sections.
      I added the file proof_of_work_exercise_1.
   
     
I found this test challenging and interesting. 

## (CORE) devops/sre.technical-tests.containerization

Containerize the provided application using Docker:
  - For the given application with a frontend (`Ariane`), a backend (`Falcon`) and a Redis (`redis`), create Dockerfiles for each component.
    - Ariane code repository: github.com/slgevens/example-ariane
    - Falcon code repository: github.com/slgevens/example-falcon
    - Redis must use port `6399`
  - Subsequently, write a Kubernetes deployment configuration to manage this multi-container application. 
    - It should include the following requirements:
        - Containers: Create Kubernetes Deployments for frontend, backend, and Redis. They should each have their own Deployment and be exposed with their own Service.
        - Networking: The frontend should communicate with the backend through a Service, and the backend should communicate with Redis in a similar manner.
        - ConfigMap/Secrets: Use a ConfigMap for any configuration that might vary between environments.
        - Persistence: Use a PersistentVolume and PersistentVolumeClaim to store data of Redis.

Deliverables:

- Dockerfiles for:
  - Ariane (frontend) is present in folder ariane
  - Falcon (backend) is present in folder falcon
  - Redis (customized to use port 6399) is present in folder redis

    I created for all the containers the file docker-compose.yaml which can be lanched by using the command `docker compose up -d` 

- Kubernetes YAML manifests

  - configmap.yaml contains all the variables and the configmap used for all the manifests files.
  - ariane_deployment.yaml contains the frontend deployment.
  - falcon_deployment.yaml contains the backend deployment.
  - redis_deployment.yaml contains the redis cache deployment

  ###This is how I tested

  I created a secret for deploying all the manifests files

  kubectl create secret docker-registry dockerhub-credentials \
    --docker-username="mydockerhub_username" \
    --docker-password="dockerhub_password" \
    --docker-server="https://index.docker.io/v1/" \
    --dry-run=client -o yaml | kubectl apply -f -
 

  FRONTEND_POD=$(kubectl get pods -n jenkins -l app=frontend -o jsonpath='{.items[0].metadata.name}')

  kubectl exec -n jenkins -it $FRONTEND_POD -- apk add --no-cache curl

  BACKEND_POD=$(kubectl get pods -n jenkins -l app=backend -o jsonpath='{.items[0].metadata.name}')

  REDIS_POD=$(kubectl get pods -n jenkins -l app=redis -o jsonpath='{.items[0].metadata.name}')

  kubectl get endpoints -n jenkins backend-service

  NAME              ENDPOINTS            AGE
  backend-service   172.16.140.99:4000   2m20s

  kubectl describe svc backend-service -n jenkins
  Name:                     backend-service
  Namespace:                jenkins
  Labels:                   <none>
  Annotations:              <none>
  Selector:                 app=backend
  Type:                     ClusterIP
  IP Family Policy:         SingleStack
  IP Families:              IPv4
  IP:                       172.17.38.162
  IPs:                      172.17.38.162
  Port:                     <unset>  4000/TCP
  TargetPort:               4000/TCP
  Endpoints:                172.16.140.99:4000
  Session Affinity:         None
  Internal Traffic Policy:  Cluster
  Events:                   <none>

  kubectl exec -n jenkins -it $FRONTEND_POD -- nslookup backend-service
  Server:		172.17.0.10
  Address:	172.17.0.10:53

  Name:	backend-service.jenkins.svc.cluster.local
  Address: 172.17.38.162
** server can't find backend-service.svc.cluster.local: NXDOMAIN
** server can't find backend-service.cluster.local: NXDOMAIN
** server can't find backend-service.cluster.local: NXDOMAIN
** server can't find backend-service.svc.cluster.local: NXDOMAIN

command terminated with exit code 1

  kubectl get pods -n kube-system -l k8s-app=kube-dns
  NAME                       READY   STATUS    RESTARTS   AGE
  coredns-6f6b679f8f-2v5wj   1/1     Running   0          12h
   coredns-6f6b679f8f-d8mlh   1/1     Running   0          12h

  REDIS_POD=$(kubectl get pods -n jenkins -l app=redis -o jsonpath='{.items[0].metadata.name}')

  kubectl exec -n jenkins -it $REDIS_POD -- netstat -tuln
  Active Internet connections (only servers)
  Proto Recv-Q Send-Q Local Address           Foreign Address         State       
  tcp        0      0 0.0.0.0:6399            0.0.0.0:*               LISTEN      
  tcp        0      0 :::6399                 :::*                    LISTEN      

  kubectl exec -n jenkins -it $BACKEND_POD -- redis-cli -h redis-service -p 6399 ping
  PONG

  kubectl exec -n jenkins -it $FRONTEND_POD -- curl backend-service:4000
  Error incrementing counter

----------------------------------------------------------------------------------------------


## General deliverables

- All scripts and configuration files submitted in a Git repository OR a zipped folder.
  The scrips and the configuration files are in the folder exercise 1
- Documentation (README files) for each section explaining:
    - Setup and usage instructions.
    - Assumptions and decisions made during implementation.
