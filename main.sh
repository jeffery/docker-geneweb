#!/usr/bin/env bash

set -e


function buildDocker()
{
    docker build -t jeffernz/geneweb:latest .
}

function checkoutRepo()
{
    git clone https://github.com/jeffery/docker-geneweb.git
}

function runDocker()
{
    mkdir -p ${HOME}/GenealogyData &&
    docker rm jeffernz-geneweb 2>/dev/null &&
    docker run \
    -p 9316:2316 -p 9317:2317 \
    -v ${HOME}/GenealogyData:/usr/local/var/geneweb/ \
    --env HOST_IP=172.17.0.1 \
    --env LANGUAGE=en \
    --name jeffernz-geneweb \
    jeffernz/geneweb:latest
}

case "$1" in
        build)
            buildDocker
            ;;

        run)
            runDocker
            ;;

        build-run)
            buildDocker && runDocker
            ;;

        bootstrap)
            checkoutRepo && pushd docker-geneweb 1> /dev/null && buildDocker && popd 1> /dev/null && runDocker
            ;;

        *)
            echo $"Usage: $0 {build|run|build-run|bootstrap}"
            exit 1

esac


