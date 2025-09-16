#!/bin/bash
set -e

CONTAINER_NAME=laravel_php

# Run artisan commands inside the container
sudo docker exec -w /var/www/html $CONTAINER_NAME php artisan migrate --force
sudo docker exec -w /var/www/html $CONTAINER_NAME php artisan config:clear
sudo docker exec -w /var/www/html $CONTAINER_NAME php artisan cache:clear

# Start artisan serve
sudo docker exec -d -w /var/www/html $CONTAINER_NAME php artisan serve --host=0.0.0.0 --port=8000

