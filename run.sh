#!/bin/bash

declare project_dir="$(PWD)"
declare dc_app_deps=${project_dir}/docker/docker-compose.yml
declare dc_app=${project_dir}/docker/docker-compose-app.yml
declare app="bookmark-service"

function restart() {
    stop
    start
}

function start() {
    echo "Starting dependent docker containers...."
    docker-compose -f "${dc_app_deps}" up --build --force-recreate -d
    docker-compose -f "${dc_app_deps}" logs -f
}

function stop() {
    echo "Stopping dependent docker containers...."
    docker-compose -f "${dc_app_deps}" stop
    docker-compose -f "${dc_app_deps}" rm -f
}

function start_app() {
    echo "Starting ${app} and dependencies...."
    build_api
    docker-compose -f "${dc_app_deps}" -f "${dc_app}" up --build --force-recreate -d
    docker-compose -f "${dc_app_deps}" -f "${dc_app}" logs -f
}

function stop_app() {
    echo 'Stopping all....'
    docker-compose -f "${dc_app_deps}" -f "${dc_app}" stop
    docker-compose -f "${dc_app_deps}" -f "${dc_app}" rm -f
}

function build_api() {
    ./mvnw clean package
}

action="start"

if [[ "$#" != "0"  ]]
then
    action=$@
fi

eval "${action}"
