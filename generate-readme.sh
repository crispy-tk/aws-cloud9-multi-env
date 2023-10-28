#!/bin/bash
###############################################
# This script generates the directory structure
# then run the README compositor
# and finally creates a tfvars file
###############################################

tree . > "./docs/.tree"
terraform-docs -c "./docs/.terraform-docs.yml" .
terraform-docs tfvars hcl . > local.auto.tfvars