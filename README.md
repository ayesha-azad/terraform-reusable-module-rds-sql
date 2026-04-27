# Terraform RDS MySQL Reusable Module

A reusable Terraform module that provisions a complete AWS RDS MySQL database infrastructure, including VPC, subnets, security groups, and automated snapshots.

## Overview

This module creates a production-ready RDS MySQL database environment within a dedicated VPC with:
- Custom VPC configuration
- Private subnets across multiple availability zones
- Security group for database access control
- RDS MySQL instance with optional Multi-AZ deployment
- Automated database snapshots

## Features

- **VPC Management**: Create and configure custom VPC with specified CIDR blocks
- **Multi-AZ Support**: Optional deployment across multiple availability zones
- **Security**: Dedicated security group with ingress/egress rules
- **Snapshots**: Automated database backup snapshots
- **Flexible Configuration**: Highly customizable through input variables
- **AWS Provider**: Compatible with AWS provider v6.42.0+

## Requirements

- Terraform >= 1.0
- AWS Provider >= 6.42.0
- AWS Account with appropriate permissions

## Usage

To use this module, simply **modify the `terraform.tfvars` file** with your desired configuration values. All the infrastructure customization happens through this single file.

The module is already configured in `main.tf` to reference all variables from `terraform.tfvars`, so no changes to the module definition are needed. Just update the variable values in `terraform.tfvars` to match your environment and requirements, then run:

```bash
terraform init
terraform plan
terraform apply
```

## Inputs

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `region` | `string` | AWS region where resources will be created |
| `vpc-config` | `object` | VPC configuration including name and CIDR block |
| `private-subnets` | `map(object)` | Map of private subnets with CIDR, name, and AZ |
| `security-group-config` | `object` | Security group name and description |
| `rds-mysql-config` | `object` | RDS MySQL configuration parameters |
| `db_snapshot_identifier` | `string` | Unique identifier for the database snapshot |

### VPC Config Object

```hcl
vpc-config = {
  vpc-name   = string  # Name tag for the VPC
  cidr_block = string  # CIDR block for the VPC (e.g., "10.0.0.0/16")
}
```

### Private Subnets Map

```hcl
private-subnets = {
  subnet-key = {
    cidr_block        = string  # Subnet CIDR block
    subnet-name       = string  # Name tag for the subnet
    availability-zone = string  # AWS availability zone
  }
}
```

### Security Group Config Object

```hcl
security-group-config = {
  security-group-name        = string  # Name for the security group
  security-group-description = string  # Description for the security group
}
```

### RDS MySQL Config Object

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `allocated_storage` | `number` | — | Storage in GB |
| `db_name` | `string` | — | Initial database name |
| `engine` | `string` | — | Database engine (e.g., "mysql") |
| `engine_version` | `string` | — | Engine version (e.g., "8.0") |
| `instance_class` | `string` | — | Instance type (e.g., "db.t3.micro") |
| `username` | `string` | — | Master username |
| `password` | `string` | — | Master password |
| `parameter_group_name` | `string` | `""` | Custom parameter group (optional) |
| `skip_final_snapshot` | `bool` | — | Skip final snapshot on deletion |
| `multi_az` | `bool` | `false` | Enable Multi-AZ deployment (optional) |

## Outputs

The module exports the following outputs:

- **RDS Instance Endpoint**: Database connection endpoint
- **RDS Instance ID**: Unique identifier for the RDS instance
- **VPC ID**: ID of the created VPC
- **Security Group ID**: ID of the security group

## Security Considerations

- **Database Password**: Use AWS Secrets Manager or similar for password management
- **Ingress Rules**: Currently configured for port 3306 (MySQL) from private subnet CIDR
- **Multi-AZ**: Enable for production environments to ensure high availability
- **Snapshots**: Snapshots are retained for disaster recovery

## Architecture

```
VPC (10.0.0.0/16)
├── Private Subnet 1 (10.0.1.0/24) [AZ: us-east-1a]
├── Private Subnet 2 (10.0.2.0/24) [AZ: us-east-1b]
├── Route Table
├── Security Group (MySQL port 3306)
└── RDS MySQL Instance
    └── Database Snapshot
```

## Best Practices

1. **Never commit passwords** to version control. Use environment variables or AWS Secrets Manager
2. **Enable backups** by setting `skip_final_snapshot = false`
3. **Use Multi-AZ** for production databases
4. **Monitor logs** in CloudWatch for database activity
5. **Test snapshots** regularly for recovery procedures
6. **Implement automated backups** with appropriate retention policies

## Troubleshooting

### Connection Issues
- Verify security group ingress rules allow your application's CIDR block
- Confirm the RDS instance is in the same VPC as your application
- Check the database password and username

### Snapshot Failures
- Ensure the RDS instance is in "Available" state
- Verify IAM permissions for snapshot operations

## License

[Specify your license here - e.g., MIT, Apache 2.0, etc.]

## Author

[Your name/organization]

## Support

For issues or questions, please contact [your contact information].
