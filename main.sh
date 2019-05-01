#!/usr/bin/env bash

set -e

PORTAL_PORT=2317
SETUP_PORT=2316


function buildDocker()
{
    docker build -t jeffernz/geneweb:latest .
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

function runDocker()
{
    # Create the database directory
    mkdir -p ${HOME}/GenealogyData

    # Remove any running/old containers
    docker rm jeffernz-geneweb 2>/dev/null

    # Run the container in detached mode
    docker run \
    -d=true \
    -p ${SETUP_PORT}:2316 \
    -p ${PORTAL_PORT}:2317 \
    -v ${HOME}/GenealogyData:/usr/local/var/geneweb/ \
    --env HOST_IP=172.17.0.1 \
    --env LANGUAGE=en \
    --name jeffernz-geneweb \
    jeffernz/geneweb:latest && stopInstructions
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


