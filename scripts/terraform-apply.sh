#!/bin/bash

terraform apply -auto-approve
terraform apply -var="argocd_app_enabled=true" -auto-approve
