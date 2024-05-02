#!/bin/bash

# Configurable variables
aws_region="<AWS_REGION>"
aws_profile="<AWS_PROFILE_NAME>"
# List of EBS Volume IDs to be deleted
volume_ids=("vol-11112222aabb3333" "vol-44445555ccdd6666" "vol-77778888eeff9999")

# Function to check if the volume state is available
check_volume_state() {
    local volume_id="$1"
    local state=$(aws --profile "$aws_profile" --region "$aws_region" ec2 describe-volumes --volume-ids "$volume_id" --query 'Volumes[0].State' --output text)
    if [ "$state" == "available" ]; then
        return 0
    else
        return 1
    fi
}

# Function to delete EBS volumes
delete_volumes() {
    local volume_ids=("$@")
    for volume_id in "${volume_ids[@]}"; do
        if check_volume_state "$volume_id"; then
            echo "Deleting volume $volume_id"
            aws --profile "$aws_profile" --region "$aws_profile" ec2 delete-volume --volume-id "$volume_id"
        else
            echo "Volume $volume_id is not available or cannot be deleted."
        fi
    done
}

# Main function
main() {
    delete_volumes "${volume_ids[@]}"
}

# Execute the main function
main