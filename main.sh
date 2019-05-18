#!/usr/bin/env bash

set -e

PORTAL_PORT=2317
SETUP_PORT=2316
DATA_HOME=~/GenealogyData
PROJECT_NAME=jeffernz-geneweb
PROJECT_RELEASE=0.8

function containerName()
{
    echo "${PROJECT_NAME}_${PROJECT_RELEASE}"
}

function buildContainer()
{
    docker build -t jeffernz/geneweb:latest -t jeffernz/geneweb:${PROJECT_RELEASE} .
}

function checkoutRepo()
{
    git clone https://github.com/jeffery/docker-geneweb.git
}

function stopInstructions()
{

    cat <<EOT
##############################################################################
#                                                                            #
#  Your GeneWeb docker container is now up and running.                      #
#                                                                            #
#    Access to the GeneWeb Portal is at http://localhost:${PORTAL_PORT}                #
#                                                                            #
#    Access to the Setup Portal is at http://localhost:${SETUP_PORT}                  #
#                                                                            #
#  To stop the docker container, execute: 'docker stop $(containerName)' #
#                                                                            #
##############################################################################

EOT

}

function removeContainer()
{
    set +e
    docker rm $(containerName) 2>/dev/null
    set -e
}

function runContainer()
{
    # Create the database directory
    mkdir -p ${DATA_HOME}

    # Remove any running/old containers
    removeContainer

    # Run the container in detached mode
    docker run \
    -d=true \
    --restart unless-stopped \
    -p ${SETUP_PORT}:2316 \
    -p ${PORTAL_PORT}:2317 \
    -v ${DATA_HOME}:/usr/local/var/geneweb/ \
    --env HOST_IP=172.17.0.1 \
    --env LANGUAGE=en \
    --env TZ=Australia/Melbourne \
    --name $(containerName) \
    jeffernz/geneweb:latest && stopInstructions
}

function stopContainer()
{
    docker stop $(containerName)
}

case "$1" in
        build)
            buildContainer
            ;;

        run)
            runContainer
            ;;

        stop)
            stopContainer
            ;;

        build-run)
            buildContainer && stopContainer && runContainer
            ;;

        bootstrap)
            checkoutRepo && pushd docker-geneweb 1> /dev/null && buildContainer && popd 1> /dev/null && runContainer
            ;;

        *)
            echo $"Usage: $0 {build|run|build-run|bootstrap|stop}"
            exit 1

esac


