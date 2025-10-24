#!/bin/bash

# Check if first argument is 'init'
if [ "$1" = "init" ]; then
    # Use exec with flock to ensure exclusive access during terraform init without forking
    # The lock file will be created in /tmp
    exec flock /tmp/terraform-init.lock terraform-exec "$@"
else
    # For all other commands, just pass through to terraform
    exec terraform-exec "$@"
fi
