#!/usr/bin/env bash

set -e

PORTAL_PORT=2317
SETUP_PORT=2316
DATA_HOME=${HOME}/GenealogyData
PROJECT_RELEASE=0.2


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
#  To stop the docker container, execute: 'docker stop jeffernz-geneweb'     #
#                                                                            #
##############################################################################

EOT

}

function removeContainer()
{
    set +e
    docker rm jeffernz-geneweb 2>/dev/null
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
    -p ${SETUP_PORT}:2316 \
    -p ${PORTAL_PORT}:2317 \
    -v ${DATA_HOME}:/usr/local/var/geneweb/ \
    --env HOST_IP=172.17.0.1 \
    --env LANGUAGE=en \
    --name jeffernz-geneweb \
    jeffernz/geneweb:latest && stopInstructions
}

function stopContainer()
{
    docker stop jeffernz-geneweb
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
            buildContainer && runContainer
            ;;

        bootstrap)
            checkoutRepo && pushd docker-geneweb 1> /dev/null && buildContainer && popd 1> /dev/null && runContainer
            ;;

        *)
            echo $"Usage: $0 {build|run|build-run|bootstrap|stop}"
            exit 1

esac


