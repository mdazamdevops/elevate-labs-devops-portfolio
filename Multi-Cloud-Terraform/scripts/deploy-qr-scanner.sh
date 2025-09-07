#!/bin/bash
apt-get update
apt-get install -y nginx git

# Create QR scanner application
mkdir -p /var/www/qr-scanner
cat > /var/www/qr-scanner/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>QR Scanner App - Multi Cloud</title>
    <style>body { font-family: Arial; margin: 40px; }</style>
</head>
<body>
    <h1>QR Scanner Application</h1>
    <p>Deployed on: $(curl -s http://169.254.169.254/latest/meta-data/instance-id >/dev/null 2>&1 && echo "AWS" || echo "GCP")</p>
    <p>Health Status: ✅ Operational</p>
</body>
</html>
EOF

# NGINX config
cat > /etc/nginx/sites-available/qr-scanner << 'EOF'
server {
    listen 80;
    root /var/www/qr-scanner;
    index index.html;
    location / { try_files $uri $uri/ =404; }
}
EOF

ln -sf /etc/nginx/sites-available/qr-scanner /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx