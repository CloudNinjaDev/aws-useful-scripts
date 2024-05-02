#!/bin/bash

# Configurable variables
aws_region="<AWS_REGION>"
aws_profile="<AWS_PROFILE_NAME>"
snapshot_type="automated"
# List of RDS instance identifiers
instances=("instance1" "instance2" "instance3" "instance4" "instance5")

# Iterate over each RDS instance
for instance in "${instances[@]}"
do
    # Get list of automated snapshots for the instance
    snapshots=$(aws --profile "$aws_profile" --region "$aws_region" rds describe-db-snapshots --db-instance-identifier "$instance" --snapshot-type "$snapshot_type" --query "DBSnapshots[].DBSnapshotIdentifier" --output text)

    # Iterate over each snapshot and delete it
    while IFS= read -r snapshot; do
        echo "Deleting snapshot $snapshot for instance $instance"
        aws --profile "$aws_profile" --region "$aws_region" rds delete-db-snapshot --db-snapshot-identifier "$snapshot"
    done <<< "$snapshots"
done