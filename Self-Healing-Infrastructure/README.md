## Self-Healing Infrastructure with Prometheus, Alertmanager & Ansible
## Elevate Labs: Empowering the Future of DevOps

* This project is a testament to the high-quality, hands-on learning experience provided by Elevate Labs. Their internship program is dedicated to empowering the next generation of DevOps professionals by offering practical, real-world challenges that build foundational skills and a deep understanding of modern software development practices.



* This project demonstrates an automated self-healing system for a web service (NGINX). It uses Prometheus for monitoring, Alertmanager for alert handling, and Ansible for automated remediation. The goal is to automatically detect when the NGINX service fails and bring it back online without manual intervention.

## Architecture Overview
```
+-------------+     +-------------+     +---------------+     +-------------+     +-------------+
|  Prometheus | --> | Alertmanager| --> | Webhook Listener | --> |   Ansible   | --> |    NGINX    |
| (Monitoring)|     | (Alerting)  |     | (Trigger)      |     | (Remediation)|     | (Service)   |
+-------------+     +-------------+     +---------------+     +-------------+     +-------------+
```
## How It Works

* Monitoring: Prometheus continuously checks if the NGINX service is online
* Alerting: If NGINX goes down, Prometheus immediately tells Alertmanager

* Trigger: Alertmanager receives the alert and sends a webhook to a listener script

* Automation: The listener script executes an Ansible playbook

## Remediation: The Ansible playbook restarts the NGINX service, fixing the problem automatically

Logging: Key actions are logged for traceability

Prerequisites
Ubuntu system (tested on 20.04/22.04)

Internet connection to download components

Basic terminal knowledge

Quick Start
Step 1: Create Project Structure and Files
```
cd ~
mkdir self-healing-ansible
cd self-healing-ansible
mkdir -p ansible prometheus alertmanager webhook nginx
```
Create the necessary files with the content provided in the respective sections below.

Step 2: Install Required Tools
```
sudo apt-get update
sudo apt-get install -y nginx ansible socat
Step 3: Deploy the NGINX Login Page
```
sudo cp nginx/index.html /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx
Visit http://<your-ip-address> to verify the page is working.
```
Step 4: Set Up and Run Prometheus
In a dedicated terminal:
```
```
cd ~/self-healing-ansible
wget https://github.com/prometheus/prometheus/releases/download/v2.51.2/prometheus-2.51.2.linux-amd64.tar.gz
tar xvfz prometheus-2.51.2.linux-amd64.tar.gz
cd prometheus-2.51.2.linux-amd64
./prometheus --config.file=../prometheus/prometheus.yml
Access Prometheus UI at http://<your-ip-address>:9090
```
Step 5: Set Up and Run Alertmanager
In another dedicated terminal:

```
cd ~/self-healing-ansible
wget https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz
tar xvfz alertmanager-0.27.0.linux-amd64.tar.gz
cd alertmanager-0.27.0.linux-amd64
./alertmanager --config.file=../alertmanager/config.yml
Access Alertmanager UI at http://<your-ip-address>:9093
```
Step 6: Set Up Ansible and the Webhook Listener
In a third dedicated terminal:

```
cd ~/self-healing-ansible
sudo mkdir -p /etc/ansible/playbooks
sudo cp ansible/restart_nginx.yml /etc/ansible/playbooks/
chmod +x webhook/webhook_handler.sh
sudo socat TCP-LISTEN:5001,fork,reuseaddr EXEC:"$(pwd)/webhook/webhook_handler.sh"
Step 7: Demo the Auto-Healing
Verify the login page is working

Stop NGINX: sudo systemctl stop nginx

Observe the self-healing process:

After ~1 minute, Prometheus shows NGINX as DOWN

Alert appears in Alertmanager UI

Webhook terminal shows activity

NGINX automatically restarts
```
Confirm the login page is back online

## File Structure
```
self-healing-ansible/
├── ansible/
│   └── restart_nginx.yml
├── prometheus/
│   ├── prometheus.yml
│   └── alert.rules.yml
├── alertmanager/
│   └── config.yml
├── webhook/
│   └── webhook_handler.sh
└── nginx/
    └── index.html
```
## Configuration Files
ansible/restart_nginx.yml
yaml
```
- name: Restart NGINX Service
  hosts: localhost
  become: yes
  tasks:
    - name: Check NGINX status
      command: systemctl status nginx
      ignore_errors: yes
      register: nginx_status

    - name: Restart NGINX
      systemd:
        name: nginx
        state: restarted
      when: nginx_status.rc != 0

    - name: Log restart action
      shell: echo "$(date): NGINX restarted by Ansible" >> /var/log/nginx_restart.log
prometheus/prometheus.yml
yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - ../prometheus/alert.rules.yml

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['localhost:9093']

scrape_configs:
  - job_name: 'nginx'
    static_configs:
      - targets: ['localhost:9113']
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
prometheus/alert.rules.yml
yaml
groups:
- name: nginx_alerts
  rules:
  - alert: NginxDown
    expr: nginx_up == 0
    for: 30s
    labels:
      severity: critical
    annotations:
      summary: "NGINX is down"
      description: "NGINX service has been down for more than 30 seconds"
alertmanager/config.yml
yaml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'webhook'

receivers:
- name: 'webhook'
  webhook_configs:
  - url: 'http://localhost:5001/'
    send_resolved: false
```
webhook/webhook_handler.sh
```
#!/bin/bash

# Read the incoming webhook data
while read -r line; do
    # Check if the alert is for NGINX down
    if echo "$line" | grep -q '"alertname":"NginxDown"'; then
        echo "$(date): Received NginxDown alert, triggering Ansible playbook" >> /var/log/nginx_restart.log
        # Execute the Ansible playbook to restart NGINX
        ansible-playbook /etc/ansible/playbooks/restart_nginx.yml
        break
    fi
done
nginx/index.html
html
<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f0f0f0; }
        .login-container { width: 300px; margin: 100px auto; padding: 20px; background: white; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; margin: 8px 0; box-sizing: border-box; }
        input[type="submit"] { background-color: #4CAF50; color: white; padding: 14px 20px; margin: 8px 0; border: none; border-radius: 4px; cursor: pointer; width: 100%; }
        input[type="submit"]:hover { background-color: #45a049; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>
        <form>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            
            <input type="submit" value="Login">
        </form>
    </div>
</body>
</html>
```
## Troubleshooting
Error: "address already in use"
This means another process is already using the required port.

## Solution:

```
# Find the process using the port (e.g., 9093 for Alertmanager)
sudo lsof -i :9093

# Stop the process (replace 12345 with the actual PID)
sudo kill 12345
Problem: Alerts are "FIRING" but not reaching Alertmanager
Prometheus may not be configured to send alerts to Alertmanager.
```
## Solution:

Check Prometheus UI: Go to Status → Runtime & Build Information

Verify the "Alertmanagers" section lists your Alertmanager

Ensure prometheus/prometheus.yml contains the alerting block

Restart Prometheus

Problem: nginx_restart.log is not created
The automation step is failing.

## Solution:

Check the socat terminal for activity when alerts fire

Test the webhook script manually:

```
sudo bash webhook/webhook_handler.sh
Look for errors in the output and fix accordingly

Monitoring and Verification
Prometheus UI: http://localhost:9090

Alertmanager UI: http://localhost:9093

NGINX status: http://localhost

Logs: Check /var/log/nginx_restart.log for restart events
```
## Customization
This setup can be adapted for other services by:

Updating the Prometheus job and alert rules

Modifying the Ansible playbook to handle the target service

Adjusting the webhook handler to recognize different alerts

## Creator
* Name: Mohd Azam Uddin
* Role: Devops Intern