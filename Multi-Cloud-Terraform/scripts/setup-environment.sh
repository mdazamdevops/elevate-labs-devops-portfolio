#!/bin/bash

# Set environment variables for your application
cat > /opt/qr-scanner-python-advance/.env << 'EOF'
DATABASE_URL=sqlite:///./test.db
SECRET_KEY=your-secret-key-here
DEBUG=False
EOF