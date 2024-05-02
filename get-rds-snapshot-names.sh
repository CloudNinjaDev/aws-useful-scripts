#!/bin/bash

# Configurable variables
aws_region="<AWS_REGION>"
aws_profile="<AWS_PROFILE_NAME>"
snapshot_type="automated"
database_instance="<DATABASE_INSTANCE_NAME>"

# Get the list of all RDS snapshots of the specified type for the specified database instance
aws --profile "$aws_profile" --region "$aws_region" rds describe-db-snapshots --snapshot-type "$snapshot_type" --query "DBSnapshots[].DBSnapshotIdentifier" --db-instance-identifier "$database_instance" --output text | awk '{print $1}