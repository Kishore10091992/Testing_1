## Overview

This Terraform configuration provisions a basic AWS infrastructure suitable for a two-tier application, including networking, security, compute, and load balancing resources. The setup is designed for use with Terraform Cloud and leverages variables for flexibility and reusability.

---

## Files Structure

- **main.tf**: Contains all resource definitions and data sources.
- **variable .tf**: Declares input variables for customization.
- **output.tf**: Defines outputs to display key resource attributes after deployment.

---

## Components

### 1. Terraform Cloud & Provider

- **Terraform Cloud**: Uses a specific organization and workspace.
- **AWS Provider**: Configured with a region from variables and AWS provider version constraint.

### 2. Networking

- **VPC**: A custom VPC is created using a CIDR block from variables.
- **Subnets**: Two subnets in different availability zones, CIDRs and AZs are variable-driven.
- **Internet Gateway**: Provides internet access to the VPC.
- **Route Table & Associations**: A route table with a default route to the internet gateway, associated with both subnets.

### 3. Security

- **Security Group**: Allows all inbound and outbound traffic from a configurable CIDR (variable `default_ip` must be defined).

### 4. Network Interfaces & Elastic IPs

- **ENIs**: One for each subnet, attached to the security group.
- **Elastic IPs**: One for each ENI, for public access.

### 5. Compute

- **Key Pair Data Source**: References an existing AWS key pair for SSH access.
- **AMI Data Source**: Selects the latest Amazon Linux 2 AMI.
- **EC2 Instances**: Two instances, each in a different subnet, with user data scripts and attached ENIs.

### 6. Load Balancing

- **Application Load Balancer (ALB)**: Configurable as internal or internet-facing, spans both subnets.
- **Target Groups**: Two, one for each instance.
- **Target Group Attachments**: Associates each instance with its target group.
- **Listener & Rules**: HTTP listener with fixed response for unmatched requests, and path-based rules to forward traffic to the correct target group.

---

## Variables

Defined in `variable .tf` (ensure all are present and correctly typed):

- **vpc_cidr**: VPC CIDR block.
- **aws_region**: AWS region.
- **subnet-1_cidr**, **subnet-2_cidr**: Subnet CIDRs.
- **subnet-1_az**, **subnet-2_az**: Subnet availability zones.
- **most_recent**: Use most recent AMI.
- **instance_type**: EC2 instance type.
- **protocol**: Protocol for security group rules.
- **lb_type**: Load balancer type.
- **user_data-1**, **user_data-2**: User data scripts for EC2 instances.
- **environment**: Environment name (e.g., dev).
- **ALB_internal**: Boolean, whether ALB is internal.
- **default_ip**: (Must be defined) CIDR for security group and route table (e.g., `"0.0.0.0/0"`).

---

## Outputs

Defined in `output.tf` (ensure resource names match):

- VPC, subnet, security group, ENI, EIP, instance, IGW, route table, ALB, target group, and listener ARNs/IDs.

---

## Notes & Recommendations

- **Variable Consistency**: Ensure all variables referenced in `main.tf` are defined in `variable .tf`.
- **Resource Naming**: Double-check for typos in resource and variable names.
- **Security**: The security group allows all traffic; restrict as needed for production.
- **Improvements**: Consider using modules for reusability and adding tags for better resource management.

---

## Usage

1. Review and update variables in `variable .tf` as needed.
2. Run `terraform init` to initialize the configuration.
3. Run `terraform plan` to review the planned actions.
4. Run `terraform apply` to provision the infrastructure.

---