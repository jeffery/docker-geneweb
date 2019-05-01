#!/usr/bin/env bash

set -xe

function startPortal()
{
    # Start GeneWeb
    gwd -lang ${LANGUAGE} -bd ${HOME} -hd /usr/share/geneweb -dd /usr/share/doc/geneweb -p 2317 -log ${HOME}/geneweb.log
}

function startSetup()
{
    # Run the gwsetup service in the background
    setup.sh
}

function runBackup()
{
    # Run the backup of all GWB databases
    backup.sh
}

case "$1" in
        start-portal)
            startPortal
            ;;

        start-setup)
            startSetup
            ;;

        backup)
            runBackup
            ;;

        bootstrap)
            startSetup &
            startPortal
            ;;

        *)
            echo $"Usage: $0 {start-portal|start-setup|status|backup|bootstrap}"
            exit 1

esac
