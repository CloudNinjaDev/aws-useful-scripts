#!/bin/bash

# Configurable variables
aws_region="<AWS_REGION>"
aws_profile="<AWS_PROFILE_NAME>"
db_instance_class="db." # Instance class starting with "db."

# Get the list of all RDS instances of instance class starting with "db."
instances=$(aws --profile $aws_profile --region $aws_region rds describe-db-instances --query "DBInstances[?DBInstanceClass && starts_with(DBInstanceClass, '$db_instance_class')].DBInstanceIdentifier" --output text)

# Create a temporary file to store the data
temp_file=$(mktemp)

# Calculate the start time as one month ago from today
start_time=$(date -u -v-1m "+%Y-%m-%dT%H:%M:%SZ")

# Loop through each instance and check the average number of connections for the past month
for instance in $instances; do
    connections=$(aws --profile $aws_profile --region $aws_region cloudwatch get-metric-statistics \
        --namespace AWS/RDS \
        --metric-name DatabaseConnections \
        --dimensions Name=DBInstanceIdentifier,Value=$instance \
        --start-time "$start_time" \
        --end-time "$(date -u "+%Y-%m-%dT%H:%M:%SZ")" \
        --period 21600 \
	    --statistics Average \
        --output text | awk '{print int($2)}' | tail -n1)

    # Check if connections is not empty and greater than or equal to 1
    if [ -n "$connections" ] && [ "$connections" -eq 0 ]; then
        # Fetch other details of the instance
        details=$(aws --profile $aws_profile --region $aws_region rds describe-db-instances --db-instance-identifier $instance --output json)
        instanceClass=$(echo $details | jq -r '.DBInstances[0].DBInstanceClass')
        engine=$(echo $details | jq -r '.DBInstances[0].Engine')

        # Append details to the temporary file
        echo -e "$instance,$instanceClass,$engine,$connections" >> "$temp_file"
    fi
done

# Output the data in a tabular format and save it to a file
column -t -s $'\t' "$temp_file" > rds_instances_connections.txt

# Remove the temporary file
rm "$temp_file"