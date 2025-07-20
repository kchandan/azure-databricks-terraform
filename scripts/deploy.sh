#!/bin/bash

# Databricks Multi-Region Deployment Script
# Usage: ./scripts/deploy.sh [primary|dr|both] [plan|apply|destroy]

set -e

REGION=${1:-both}
ACTION=${2:-plan}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Function to deploy to a specific region
deploy_region() {
    local region_dir=$1
    local region_name=$2
    
    log "Processing $region_name region..."
    
    if [ ! -d "$region_dir" ]; then
        error "Directory $region_dir does not exist"
    fi
    
    cd "$region_dir"
    
    # Check if terraform.tfvars exists
    if [ ! -f "terraform.tfvars" ]; then
        warn "terraform.tfvars not found in $region_dir"
        warn "Please copy terraform.tfvars.example to terraform.tfvars and update values"
        cd - > /dev/null
        return 1
    fi
    
    # Initialize Terraform
    log "Initializing Terraform for $region_name..."
    terraform init
    
    # Run the specified action
    case $ACTION in
        plan)
            log "Running terraform plan for $region_name..."
            terraform plan
            ;;
        apply)
            log "Running terraform apply for $region_name..."
            terraform apply -auto-approve
            ;;
        destroy)
            warn "Running terraform destroy for $region_name..."
            terraform destroy -auto-approve
            ;;
        *)
            error "Invalid action: $ACTION. Use plan, apply, or destroy"
            ;;
    esac
    
    cd - > /dev/null
    log "Completed $region_name region"
}

# Main deployment logic
case $REGION in
    primary)
        deploy_region "infra/prod/eastus" "Primary (East US)"
        ;;
    dr)
        deploy_region "infra/prod/westus" "DR (West US)"
        ;;
    both)
        deploy_region "infra/prod/eastus" "Primary (East US)"
        if [ $? -eq 0 ]; then
            deploy_region "infra/prod/westus" "DR (West US)"
        else
            error "Primary region deployment failed. Skipping DR deployment."
        fi
        ;;
    *)
        error "Invalid region: $REGION. Use primary, dr, or both"
        ;;
esac

log "Deployment script completed successfully!"