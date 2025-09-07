#!/bin/bash

# Check if the application is running
if curl -s http://localhost:5000 > /dev/null; then
    echo "Application is running successfully"
    exit 0
else
    echo "Application is not responding"
    exit 1
fi