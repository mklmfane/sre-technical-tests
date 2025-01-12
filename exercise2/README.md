## (CORE) devops/sre.technical-tests.infrastructure-as-code

Given an application with a frontend, a backend and a Redis, write Terraform scripts to provision a necessary infrastructure on AWS. These scripts should include the following resources:
  - 3 EC2 instances `technical-test-ariane`, `technical-test-falcon`, `technical-test-redis`
  - a VPC containing with following attached resources `technical-test-vpc`
    - a VPC Internet gateway `technical-test-internet-gateway`
    - a VPC NAT gateway `technical-test-nat-gateway`
    - 2 subnets (a `technical-test-public` and a `technical-test-private`)
    - an elastic ip address in the `technical-test-public` attached to the EC2 instance `technical-test`
    - a default VPC routing table `technical-test-routing-table`
      - the necessary route table entries to redirect the subnets
    - 3 security-groups
      - a security group `technical-test-ariane-security-group` with the following permission entries, attached to `technical-test-ariane`
        - Inbound/ protocol: HTTPS (TCP), port: 443, source: 82.11.22.33/32, descripton: Office
        - Inbound/ protocol: HTTPS (TCP), port: 443, source: 81.44.55.87/32, descripton: VPN
        - Inbound/ protocol: HTTPS (TCP), port: 443, source: 87.12.33.88/32, descripton: Home
        - Outboud/ protocol: All, port: All, source: 0.0.0.0/0, descripton: Internet outbound
      - a security group `technical-test-falcon-security-group` with the following permission entries, attached to `technical-test-falcon`
        - Inbound/ protocol: HTTP (TCP), port: 4000, source: `technical-test-ariane-security-group`, descripton: `technical-test-ariane-security-group`
        - Outboud/ protocol: All, port: All, source: 0.0.0.0/0, descripton: Internet outbound
      - a security group `technical-test-redis-security-group` with the following permission entries, attached to `technical-test-redis`
        - Inbound/ protocol: HTTP (TCP), port: 6399, source: `technical-test-falcon-security-group`, descripton: `technical-test-falcon-security-group`
        - Outboud/ protocol: All, port: All, source: 0.0.0.0/0, descripton: Internet outbound

Deliverables:

- Terraform scripts including all mentioned resources: Provided in tf files from this repository.
- Terraform plan/output file showing resources to be created.

 
- README file explaining:
  - How to initialize and apply the Terraform configuration.

    - clone this repository by using 
       git clone https://github.com/mklmfane/terraform-exercise.git
       cd terraform-exercise
     
    - Configure aws account should be set up by using `aws configure` according to the explanations from this like https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html 

     - Launch `terraform init`

      It means that teraform up to 0.13 will be used based on code from file provider.tf
       terraform {
        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"    
          }
        }
      }

      provider "aws" {
        # Configuration options
        region = "eu-west-1" 
      }
        
      # More infromation about terraform proivde can be found here in this link https://registry.terraform.io/providers/hashicorp/aws/latest/docs   

    - Launch terraform plan to see which resources will be created
      terraform plan -var-file="terraform_vars.tfvars"

    - Launch the folloiwng command 
     terraform apply -var-file="terraform_vars.tfvars" -auto-approve  - to see how it can be applied withotut requiring to confirm
    
      
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_eip.technical_test_eip will be created
  + resource "aws_eip" "technical_test_eip" {
      + allocation_id        = (known after apply)
      + arn                  = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + ipam_pool_id         = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + ptr_record           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "technical-test-eip"
        }
      + tags_all             = {
          + "Name" = "technical-test-eip"
        }
      + vpc                  = (known after apply)
    }

  # aws_instance.technical_test_ariane will be created
  + resource "aws_instance" "technical_test_ariane" {
      + ami                                  = "ami-0e9085e60087ce171"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "technical-test-ariane"
        }
      + tags_all                             = {
          + "Name" = "technical-test-ariane"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # aws_instance.technical_test_falcon will be created
  + resource "aws_instance" "technical_test_falcon" {
      + ami                                  = "ami-0e9085e60087ce171"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "technical-test-falcon"
        }
      + tags_all                             = {
          + "Name" = "technical-test-falcon"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # aws_instance.technical_test_redis will be created
  + resource "aws_instance" "technical_test_redis" {
      + ami                                  = "ami-0e9085e60087ce171"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "technical-test-redis"
        }
      + tags_all                             = {
          + "Name" = "technical-test-redis"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # aws_internet_gateway.technical_test_internet_gateway will be created
  + resource "aws_internet_gateway" "technical_test_internet_gateway" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "technical-test-internet-gateway"
        }
      + tags_all = {
          + "Name" = "technical-test-internet-gateway"
        }
      + vpc_id   = (known after apply)
    }

  # aws_nat_gateway.technical_test_nat_gateway will be created
  + resource "aws_nat_gateway" "technical_test_nat_gateway" {
      + allocation_id                      = (known after apply)
      + association_id                     = (known after apply)
      + connectivity_type                  = "public"
      + id                                 = (known after apply)
      + network_interface_id               = (known after apply)
      + private_ip                         = (known after apply)
      + public_ip                          = (known after apply)
      + secondary_private_ip_address_count = (known after apply)
      + secondary_private_ip_addresses     = (known after apply)
      + subnet_id                          = (known after apply)
      + tags                               = {
          + "Name" = "technical-test-nat-gateway"
        }
      + tags_all                           = {
          + "Name" = "technical-test-nat-gateway"
        }
    }

  # aws_route.route_internet_gateway will be created
  + resource "aws_route" "route_internet_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + gateway_id             = (known after apply)
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)
    }

  # aws_route_table.technical_test_routing_table will be created
  + resource "aws_route_table" "technical_test_routing_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "Name" = "technical-test-routing-table"
        }
      + tags_all         = {
          + "Name" = "technical-test-routing-table"
        }
      + vpc_id           = (known after apply)
    }

  # aws_security_group.technical_test_ariane_security_group will be created
  + resource "aws_security_group" "technical_test_ariane_security_group" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Internet outbound"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "82.11.22.33/32",
                  + "81.44.55.87/32",
                  + "87.12.33.88/32",
                ]
              + description      = "HTTPS inbound from Office, VPN, Home"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "technical-test-ariane-security-group"
        }
      + tags_all               = {
          + "Name" = "technical-test-ariane-security-group"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.technical_test_falcon_security_group will be created
  + resource "aws_security_group" "technical_test_falcon_security_group" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Internet outbound"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = []
              + description      = "technical-test-ariane-security-group"
              + from_port        = 4000
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = (known after apply)
              + self             = false
              + to_port          = 4000
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "technical-test-falcon-security-group"
        }
      + tags_all               = {
          + "Name" = "technical-test-falcon-security-group"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.technical_test_redis_security_group will be created
  + resource "aws_security_group" "technical_test_redis_security_group" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Internet outbound"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = []
              + description      = "technical-test-falcon-security-group"
              + from_port        = 6399
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = (known after apply)
              + self             = false
              + to_port          = 6399
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "technical-test-redis-security-group"
        }
      + tags_all               = {
          + "Name" = "technical-test-redis-security-group"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.technical_test_private will be created
  + resource "aws_subnet" "technical_test_private" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "technical-test-private"
        }
      + tags_all                                       = {
          + "Name" = "technical-test-private"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_subnet.technical_test_public will be created
  + resource "aws_subnet" "technical_test_public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "technical-test-public"
        }
      + tags_all                                       = {
          + "Name" = "technical-test-public"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.technical_test_vpc will be created
  + resource "aws_vpc" "technical_test_vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "technical-test-vpc"
        }
      + tags_all                             = {
          + "Name" = "technical-test-vpc"
        }
    }

Plan: 14 to add, 0 to change, 0 to destroy.
aws_eip.technical_test_eip: Creating...
aws_vpc.technical_test_vpc: Creating...
aws_eip.technical_test_eip: Creation complete after 1s [id=eipalloc-0040701e8e7c07fc7]
aws_vpc.technical_test_vpc: Creation complete after 2s [id=vpc-0c7650ce73d9cbf39]
aws_internet_gateway.technical_test_internet_gateway: Creating...
aws_route_table.technical_test_routing_table: Creating...
aws_subnet.technical_test_public: Creating...
aws_subnet.technical_test_private: Creating...
aws_security_group.technical_test_ariane_security_group: Creating...
aws_internet_gateway.technical_test_internet_gateway: Creation complete after 1s [id=igw-06e352790f8a3a301]
aws_route_table.technical_test_routing_table: Creation complete after 1s [id=rtb-0bfd8ddd3e5435d2a]
aws_route.route_internet_gateway: Creating...
aws_subnet.technical_test_private: Creation complete after 1s [id=subnet-00c665e6770668d21]
aws_route.route_internet_gateway: Creation complete after 1s [id=r-rtb-0bfd8ddd3e5435d2a1080289494]
aws_security_group.technical_test_ariane_security_group: Creation complete after 3s [id=sg-0edc949839d0e666c]
aws_security_group.technical_test_falcon_security_group: Creating...
aws_security_group.technical_test_falcon_security_group: Creation complete after 3s [id=sg-09472f5ee73e12cd0]
aws_security_group.technical_test_redis_security_group: Creating...
aws_instance.technical_test_falcon: Creating...
aws_security_group.technical_test_redis_security_group: Creation complete after 4s [id=sg-0bea2badf62ca0c5e]
aws_instance.technical_test_redis: Creating...
aws_subnet.technical_test_public: Still creating... [10s elapsed]
aws_subnet.technical_test_public: Creation complete after 11s [id=subnet-02672b01e98d2590a]
aws_nat_gateway.technical_test_nat_gateway: Creating...
aws_instance.technical_test_ariane: Creating...
aws_instance.technical_test_falcon: Still creating... [10s elapsed]
aws_instance.technical_test_falcon: Creation complete after 14s [id=i-0b2baec53ade34f73]
aws_instance.technical_test_redis: Still creating... [10s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [10s elapsed]
aws_instance.technical_test_ariane: Still creating... [10s elapsed]
aws_instance.technical_test_redis: Creation complete after 13s [id=i-001f69cbeb2918e95]
aws_instance.technical_test_ariane: Creation complete after 13s [id=i-0b91d51b9d4091447]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [20s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [30s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [40s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [50s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [1m0s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [1m10s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [1m20s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [1m30s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Still creating... [1m40s elapsed]
aws_nat_gateway.technical_test_nat_gateway: Creation complete after 1m45s [id=nat-087bc51664e6ea994]

Apply complete! Resources: 14 added, 0 changed, 0 destroyed. 

  - Resource hierarchy and purpose.
     
    I used the following files
     - vars.tf - the variables for EC2 instance like ami id and the type of the instance
     - provider.tf - used for aws provider in region eu-west-1.
     - network.tf  - is used to vpc, EIP, NAT gateway as pre-quisite for the EC virtual machines
     - ec2.tf      - is used to create teh actual EC2 virtual machines.
     - .gitignore fule to prevent wirting tfvars file and state files in the repository.