# devops/sre.technical-tests

This test is designed to evaluate your skills and experience in various aspects of the role for which you applied, including Virtualization, AWS Cloud management, Continuous Integration/Continuous Deployment (CI/CD), Infrastructure as Code (IaC), among others.

This test is designed to be completed in approximately 10–12 hours for the core tasks, assuming familiarity with the required tools and concepts. 
Bonus tasks may require an additional 6–8 hours if attempted. It is recommended to plan your time accordingly.

__You are encouraged to complete the core tasks first, as they are essential for demonstrating the foundational skills required for this position. Bonus tasks are optional and intended to showcase advanced expertise.__

Tasks

  - Core tasks are self-contained and can be completed independently.
  - Bonus tasks:
    - The CI/CD pipeline assumes that the containerization task has been completed.
    - The monitoring and performance optimization task builds on work done in the containerization and infrastructure as code sections.

We hope you find this test challenging and interesting. 

Good luck!

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
  - Ariane (frontend)
  - Falcon (backend)
  - Redis (customized to use port 6399)
- Kubernetes YAML manifests


## (CORE) devops/sre.technical-tests.provisioning

Using the following yaml data structure and the provisioning tool of your choice (Ansible, Puppet, Salt, etc...), define the following tasks:

```yaml
---
user_accounts:
  jane.doe:
    name: Jane DOE
    mail: jane.doe@example.com
    position: Software Engineer
    office: London
    login: jane.doe
    passwd: Bv3h!p2DqP%Q
    groups: ["sudo", "developers"]
    ssh_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1C4os6Tq2z5Z3DywAfPO6r6kVWQ8mYeXYxz2XJHwIWmJ1FI/JD/Z7/F1RMIo+dFWuEJ3ODT/MwtSox+bcbD09Rf0Ex33PLO6dsWeRrT6CVXf7j/Gs2P8WQv/N1MdaLJfjKnDUH6pAxPpE7XqO4+FOuz3zHKRQyPgzDUp5IV4OgxtNHJXSmIkNg4bdfF+JDk9OTvrZHg3W37zCVhrg=="
  john.smith:
    name: John SMITH
    mail: john.smith@example.com
    position: Systems Administrator
    office: New York
    login: john.smith
    passwd: Zm9c&NvV7LbA
    groups: ["sudo", "it"]
    ssh_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqseVTHgNcmBbdfXZUoWJSxs9hcC3Ao4EzXKiJ6OFTS8EbJSrBzKJqU7TLsTnGzR8BOl6pOEx6PmMt6LQqqqX2lToB4Ml6qYzM69Z4F8W79fEJ5MpGfdKUXOnKIl1Tg4nOEBZldUxEAYddShlCSrnJddvBfNz93OqmPAK3Rq1xlSlyB6FdOIeoI4rGO8UHyXyIuFP6P1BPXwWfsXn8SJd7GoJIN8AmBXmR=="
  alice.williams:
    name: Alice WILLIAMS
    mail: alice.williams@example.com
    position: DevOps Engineer
    office: Berlin
    login: alice.williams
    passwd: Tq7d#3BpO1pN
    groups: ["sudo", "infra"]
    ssh_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqrsZ5FVNl3hj9ZkXVzO7dAOXfBqhJsOtqW32EHYcpEXYf4J7Opk6TQQyPs8zF4PKMtkhfL9TV3HE9QWFkNO8RcFtoR9P6g8P4FoG68UqcMJOEY2fcbUJtXEN3HZ5OtTkpj9fPBZRJ3f2ExfUwYkIO6g6jOQsVmABbOeZsPyF1IXf4JtBQuAql3QJSUnE8G6UxWoHIVLJ6FqTzVJrLoRqOc9=="
```

- Change the system open file limit to `65536` for the `root` user.
- Create all users accounts contained in the yaml data structure;
    - Users must be able to login with their `login` using their `ssh_keys`
    - Users must be part of the mentionned `groups`.
    - An `info` file in their `/home/USER/info` must contain the following informations : `name`, `position` & `office`.
- Install the `docker` package and then
    - Run a given container : `public.ecr.aws/q0x2y8f9/nginx-demo` – default exposed port is `55000`
    - Name the container `happy_roentgen`
- Download and copy the following [file – prrtprrt.txt](https://gist.githubusercontent.com/slgevens/aa9a2fc52cb5fef8b41c1b11a8b7d3e3/raw/dc1e3e288967bd4818277e4688d1daf615225337/prrtprrt.txt)
    - In each users `home/USER/prrtprrt.txt`
    - Locally (on your computer) in the working directory `$CURRENT_DIR/files/prrtprrt.txt`
- Encrypt sensitive data
    - Modify the yaml data structure above and encrypt each users `passwd`
    - __PROVIDE THE ENCRYPTION KEY in a dedicated variable, `encryption_key`__
- Use a role or a class install `nginx`
    - Expose the port `80` FORWARDING REQUESTS to the container `happy_roentgen`

Deliverables:

- main.yml playbook

## (BONUS - Optional) devops/sre.technical-tests.monitoring

Bonus task: advanced monitoring and performance optimization

- Monitoring
    - Set up a centralized monitoring solution for the multi-container application in Kubernetes.
        - Use Prometheus and Grafana to monitor the following metrics:
            - CPU and memory usage of the containers.
            - HTTP request rates, latencies, and error rates for the backend and frontend services.
            - Redis memory usage and hit/miss rates.
        - Create a Grafana dashboard with at least the following panels:
            - Overall cluster CPU and memory usage.
            - Per-service request latency and error rate.
            - Redis performance metrics.

- Performance optimization
    - Perform load testing on the backend service (Falcon) using the tool of your choice
        - Simulate a workload of 100 users for 5 minutes, with an increasing request rate.
        - Identify any bottlenecks in the application or infrastructure.
        - Propose at least two recommendations to improve the system’s performance, considering:
            - Horizontal or vertical scaling.
            - Database optimization for Redis.
            - Application tuning (e.g., caching, request batching).

- Alerting
    - Set up alerts in Prometheus for the following scenarios
        - CPU usage exceeds 80% for any container.
        - HTTP error rate exceeds 5% for the frontend or backend.
        - Redis memory usage exceeds 75%.
        - Integrate the alerts with a notification system of your choice (e.g., Slack, PagerDuty, or email).

Deliverables:

- Monitoring and alerting configuration files (Prometheus rules, Grafana dashboard JSON).
- Load test script and a short summary of the findings.
- Recommendations document outlining the observed bottlenecks and proposed improvements.

## (BONUS - Optional) devops/sre.technical-tests.ci-cd

Implement a CI/CD pipeline using the tool/sotfware of your choice (Jenkins, CircleCI, GitLab CI, etc.).

- The pipeline should include stages to deploy/configure frontend, backend, and Redis applications:
  - build 
    - this stage should build the repositories mentioned in the [## devops/sre.technical-tests.containerization](## devops/sre.technical-tests.containerization) section
  - test
    - this stage should use `mocha` (or any other framework) for the frontend, and `testing` (or any other framework) for the backend applications
  - deploy
    - this stage should update the deployments image version in a running Kubernetes cluster

Deliverables:

- Pipeline Configuration File for the chosen tool (e.g., .gitlab-ci.yml for GitLab CI, Jenkinsfile for Jenkins, etc.), containing described stages.
- README file explaining:
  - CI/CD pipeline workflow.


## General deliverables

- All scripts and configuration files submitted in a Git repository OR a zipped folder.
- Documentation (README files) for each section explaining:
    - Setup and usage instructions.
    - Assumptions and decisions made during implementation.
