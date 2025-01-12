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
  To test main.yaml, I launched the following command in ansible VM deployed by using vagrant.
   

