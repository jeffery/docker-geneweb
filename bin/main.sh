#!/usr/bin/env bash

set -e

function startPortal()
{
    # Start GeneWeb
    gwd -lang ${LANGUAGE} -bd ${HOME} -hd /usr/share/geneweb -dd /usr/share/doc/geneweb -p 2317 -log ${HOME}/geneweb.log
}

function ensureBackupPathExists()
{
    if [[ ! -d backup ]]; then
        mkdir -p backup
    fi
}

function ensureImportPathExists()
{
    if [[ ! -d import ]]; then
        mkdir -p import
    fi
}

function startSetup()
{
    pushd ${HOME} 1> /dev/null

        if [[ -n "${HOST_IP}" ]]; then
           echo "${HOST_IP}" > ${HOME}/gwsetup_only.txt
        fi

        ensureBackupPathExists
        ensureImportPathExists

        DEFAULT_CONFIG="${HOME}/default.gwf"
        if [[ ! -f ${DEFAULT_CONFIG} ]]; then
            cp /var/lib/geneweb/default.gwf ${DEFAULT_CONFIG}
        fi

        gwsetup -p 2316 -gd /usr/share/geneweb -lang ${LANGUAGE} -bindir /usr/bin -only ${HOME}/gwsetup_only.txt -log /dev/null 2>&1 | tee -a ${HOME}/gwsetup.log

    popd 1> /dev/null
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

        start-all)
            startSetup &
            startPortal
            ;;

        backup)
            runBackup
            ;;

        *)
            echo $"Usage: $0 {start-portal|start-setup|start-all|backup}"
            exit 1

esac
