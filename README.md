# Azure Databricks Multi-Region Deployment

This repository contains Terraform configurations for deploying Azure Databricks workspaces across multiple regions with disaster recovery (DR) capabilities.

## Architecture Overview

- **Primary Region**: East US
- **DR Region**: West US
- **Network**: VNet injection with private endpoints
- **Security**: Network Security Groups with minimal required rules
- **SKU**: Premium (configurable)

## Prerequisites

- Azure CLI installed and authenticated
- Terraform >= 1.0
- Appropriate Azure permissions for Databricks and networking resources

## Project Structure

```
├── infra/
│   ├── modules/
│   │   ├── databricks_compute/     # Databricks cluster configuration
│   │   ├── databricks_workspace/   # Databricks workspace module
│   │   └── network/                # VNet and subnet configuration
│   ├── prod/
│   │   ├── eastus/                 # Primary region deployment
│   │   └── westus/                 # DR region deployment
│   └── shared/                     # Shared configuration and variables
├── apps/                           # Application-specific configurations
├── notebooks/                      # Databricks notebooks
└── scripts/                        # Deployment scripts
```

## Quick Start

### 1. Configure Variables

Copy the example tfvars files and update with your values:

```bash
# Primary region
cp infra/prod/eastus/terraform.tfvars.example infra/prod/eastus/terraform.tfvars

# DR region
cp infra/prod/westus/terraform.tfvars.example infra/prod/westus/terraform.tfvars
```

### 2. Deploy Infrastructure

Using the deployment script:

```bash
# Deploy both regions
./scripts/deploy.sh both plan
./scripts/deploy.sh both apply

# Deploy only primary region
./scripts/deploy.sh primary apply

# Deploy only DR region
./scripts/deploy.sh dr apply
```

Manual deployment:

```bash
# Primary region
cd infra/prod/eastus
terraform init
terraform plan
terraform apply

# DR region
cd ../westus
terraform init
terraform plan
terraform apply
```

## Configuration Options

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `region` | Azure region | eastus/westus | Yes |
| `resource_group_name` | Resource group name | - | Yes |
| `owner` | Resource owner | platform-team | No |
| `cost_center` | Cost center for billing | engineering | No |
| `databricks_sku` | Databricks SKU | premium | No |

### Databricks SKU Options

- `standard`: Basic features
- `premium`: Advanced security and collaboration features
- `trial`: Trial version (limited time)

## Security Features

- **VNet Injection**: Databricks deployed in custom VNet
- **No Public IP**: Clusters use private IPs only
- **Network Security Groups**: Minimal required rules
- **Private Endpoints**: Secure communication
- **Premium SKU**: Advanced security features

## Disaster Recovery

The DR setup provides:

- **Identical Infrastructure**: Same configuration in both regions
- **Independent State**: Separate Terraform state files
- **Quick Failover**: Pre-deployed infrastructure ready for use
- **Data Replication**: Configure separately based on requirements

### DR Activation Process

1. Update DNS/load balancer to point to DR region
2. Restore data from backups/replication
3. Update application configurations
4. Validate functionality

## Best Practices Implemented

### Terraform
- ✅ Modular design with reusable modules
- ✅ Consistent naming conventions
- ✅ Proper variable validation
- ✅ Comprehensive outputs
- ✅ Remote state management
- ✅ Resource tagging strategy

### Security
- ✅ No hardcoded credentials
- ✅ Network security groups
- ✅ VNet injection
- ✅ Private endpoints
- ✅ Premium SKU for advanced security

### Operations
- ✅ Automated deployment scripts
- ✅ Environment separation
- ✅ Consistent tagging
- ✅ Documentation

## Monitoring and Maintenance

### Recommended Monitoring
- Azure Monitor for infrastructure metrics
- Databricks audit logs
- Network flow logs
- Cost monitoring and alerts

### Maintenance Tasks
- Regular Terraform state cleanup
- Security updates
- Cost optimization reviews
- DR testing procedures

## Troubleshooting

### Common Issues

1. **Provider Authentication**
   ```bash
   az login
   az account set --subscription <subscription-id>
   ```

2. **State Lock Issues**
   ```bash
   terraform force-unlock <lock-id>
   ```

3. **Module Path Issues**
   - Ensure correct relative paths in module sources
   - Run `terraform init` after module changes

### Support

For issues and questions:
1. Check Terraform and Azure provider documentation
2. Review Azure Databricks documentation
3. Check Azure service health status

## Contributing

1. Follow existing code structure and naming conventions
2. Update documentation for any changes
3. Test changes in development environment first
4. Use consistent formatting (`terraform fmt`)

## License

See LICENSE file for details.