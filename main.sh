#!/usr/bin/env bash

set -e

PROJECT_NAME=jeffernz-geneweb
PROJECT_RELEASE=0.9

WEB_PORT=2317
SETUP_PORT=2316
DATA_HOME=~/GenealogyData
LANGUAGE="en"
HOST_IP="172.17.0.1"
TIME_ZONE="Australia/Melbourne"

function containerName()
{
    echo "${PROJECT_NAME}_${PROJECT_RELEASE}"
}

function usage()
{
    cat << EOF

${0}

Command options:
    -h      Display this help message.
    -b      Build the GeneWeb container
    -r | -z Run the GeneWeb container | Build and run the GeneWeb Container
            Option parameters:
                -l  The language to run GeneWeb in e.g. (en, de, fr)
                -i  The host ip address where the setup portal will be accessed from
                -t  The time zone to run GeneWeb in. e.g. (Australia/Melbourne)
                -w  The web portal port number. e.g. 2317
                -s  The setup portal port number. e.g. 2316
                -b  The storage location for the bases e.g. ~/GenealogyData
    -k      Stop the container

EOF

    exit 1
}

function displayRunning()
{
    cat << RUNNING

 GeneWeb is running using language '${LANGUAGE}' in the time zone '${TIME_ZONE}'

    The bases will be stored under '${DATA_HOME}'

    The web portal can be accessed at http://localhost:${WEB_PORT}
    The setup portal can be accessed at http://localhost:${SETUP_PORT}

    To stop the GeneWeb container, execute: '${0} -k'

RUNNING
}

function checkoutRepo()
{
    git clone https://github.com/jeffery/docker-geneweb.git
}

function buildContainer()
{
    docker build -t jeffernz/geneweb:latest -t jeffernz/geneweb:${PROJECT_RELEASE} .
}

function runContainer()
{
    # Create the database directory
    mkdir -p ${DATA_HOME}

    # Remove any running/old containers
    stopContainer && removeContainer

    # Run the container in detached mode
    docker run \
        -d=true \
        --restart unless-stopped \
        -p ${SETUP_PORT}:2316 \
        -p ${WEB_PORT}:2317 \
        -v ${DATA_HOME}:/usr/local/var/geneweb/ \
        --env HOST_IP=${HOST_IP} \
        --env LANGUAGE=${LANGUAGE} \
        --env TZ=${TIME_ZONE} \
        --name $(containerName) \
        jeffernz/geneweb:latest
}

function stopContainer()
{
    docker stop $(containerName)
}

function removeContainer()
{
    set +e
    docker rm $(containerName) 2>/dev/null
    set -e
}

function invalidOption()
{
    echo "Invalid Command: -$OPTARG" 1>&2
}

function invalidOptionParameter()
{
    echo "Invalid Option: -$OPTARG" 1>&2
}

function optionParameterRequiresValue()
{
    echo "Option: -$OPTARG requires an argument" 1>&2
}

while getopts ":hbrzk" opt; do
  case ${opt} in

    h ) usage ;;

    b ) buildContainer; exit $? ;;

    r | z )
        command=${opt}
        while getopts ":l:t:i:w:s:b:" opt; do
            case ${opt} in
                l ) LANGUAGE=$OPTARG ;;

                t ) TIME_ZONE=$OPTARG ;;

                i ) HOST_IP=$OPTARG ;;

                w ) WEB_PORT=$OPTARG ;;

                s ) SETUP_PORT=$OPTARG ;;

                b ) DATA_HOME=$OPTARG ;;

                \? ) invalidOptionParameter && usage ;;

                : ) optionParameterRequiresValue && usage ;;
            esac
        done

        if [[ "${command}" = "r" ]]; then
            runContainer
        else
            buildContainer && runContainer
        fi

        displayRunning; exit $?
    ;;

    k ) stopContainer; exit $? ;;

    \? ) invalidOption && usage ;;

  esac
done

if [[ $OPTIND -eq 1 ]]; then
    usage
fi
