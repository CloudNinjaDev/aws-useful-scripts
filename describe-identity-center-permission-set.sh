#!/bin/bash

# Configurable Variables
aws_region="<AWS_REGION>"
aws_profile="<AWS_PROFILE_NAME>"
sso_instance_arn="arn:aws:sso:::instance/ssoins-12345ca987653b09"

# Function to describe permission sets
describe_permission_sets() {
    local permission_set_arns=("${@:2}")
    local output=""
    for permission_set_arn in "${permission_set_arns[@]}"; do
        output+="$(aws sso-admin describe-permission-set --instance-arn "$sso_instance_arn" --permission-set-arn "$permission_set_arn" --profile "$aws_profile" --region "$aws_region")"
    done
    echo "$output"
}

# Main function
main() {
    echo "These details are fetched on $(date +"%Y-%m-%d %H:%M:%S")"
    # List of permission set ARNs
    permission_set_arns=(
        "arn:aws:sso:::permissionSet/ssoins-12345ca987653b09/ps-0b1b3b3b3b3b3b3b3"
        "arn:aws:sso:::permissionSet/ssoins-12345ca987653b09/ps-0b2b2b2b2b2b2b2b"
        "arn:aws:sso:::permissionSet/ssoins-12345ca987653b09/ps-0b3b3b3b3b3b3b3b3"
    )

    # Describe permission sets
    describe_permission_sets "${permission_set_arns[@]}"
}

# Execute the main function
main