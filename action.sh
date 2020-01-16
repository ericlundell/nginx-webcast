#!/bin/bash

# It might be easier to create an alias: `alias sa="./action.sh"`

# Export enviroment vars set in action.conf
# https://unix.stackexchange.com/a/79077
set -a
. ./action.env
set +a

for arg; do

  if [[ $arg == 'build' ]] ; then

    echo "Building docker with network '$X_DOCKER_IP'"

    envsubst '$X_DOCKER_IP' < ./web/nginx.conf.example > ./web/nginx.conf
    envsubst '$X_DOCKER_IP' < ./web/player.html.example > ./web/player.html
    envsubst '$X_DOCKER_IP' < ./rtmp/nginx.conf.example > ./rtmp/nginx.conf
    docker-compose build

  elif [[ $arg == 'start' ]]; then

    echo "Starting..."
    docker-compose up -d
    sleep 2
    docker ps

  elif [[ $arg == 'stop' ]]; then

    echo "Stopping"
    docker-compose down

  elif [[ $arg == 'restart' ]]; then

    echo "Restarting"
    docker-compose restart
    sleep 1
    docker ps

  elif [[ $arg == 'logs' ]]; then

    echo "Getting logs"
    docker-compose logs

  else
    echo "No good args provided."
  fi
done
