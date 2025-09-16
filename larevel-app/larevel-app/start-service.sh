#!/bin/bash

cd /home/ubuntu/larevel-app

# Start docker-compose
sudo docker-compose up -d

sleep 300

# Run artisan commands
sudo ./startup.sh
