#!/bin/bash

# This script is executed by socat when a webhook is received from Alertmanager.

# Exit immediately if a command exits with a non-zero status.
set -e
# Print each command to stderr before executing it for debugging.
set -x

# Define a central log file for this handler
LOG_FILE="/var/log/webhook_handler.log"

# --- Script Start ---
echo "Webhook handler script started at $(date)" >> $LOG_FILE

# In a real run, 'cat' will hang until it receives the payload from socat.
# For a manual test, you can press Ctrl+D to continue.
echo "Waiting for payload from stdin..." >> $LOG_FILE
cat >> $LOG_FILE
echo "Payload received or stdin closed." >> $LOG_FILE

# Execute the Ansible playbook, using the full path to avoid PATH issues.
# Redirect both stdout and stderr to our log file to capture any errors.
echo "Executing Ansible playbook..." >> $LOG_FILE
/usr/bin/ansible-playbook /etc/ansible/playbooks/restart_nginx.yml >> $LOG_FILE 2>&1

# This is the original log file you were looking for.
# It will only be created if the playbook command above succeeds.
echo "NGINX restart attempted via Ansible at $(date)" >> /var/log/nginx_restart.log

echo "Webhook handler script finished successfully at $(date)." >> $LOG_FILE
echo "---" >> $LOG_FILE

