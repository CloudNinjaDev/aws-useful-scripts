#!/bin/bash

# Configurable Variables
aws_region="us-west-2"
aws_profile="mgmt-admin"
sso_instance_arn="arn:aws:sso:::instance/ssoins-12345ca987653b09"
account_id="111122223333"


aws --profile "$aws_profile" --region "$aws_region" sso-admin list-permission-sets-provisioned-to-account --instance-arn "$sso_instance_arn" --account-id "$account_id" --output text