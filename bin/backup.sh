#!/usr/bin/env bash

pushd ${HOME} 1> /dev/null

    mkdir -p backup

    for base in `ls -d *.gwb 2> /dev/null`;
    do
        geneWebBase=$(basename ${base})
        databaseName=$(echo "${geneWebBase%.*}")
        databaseBackupPath="$(pwd)/backup/${databaseName}-$(date +%Y%m%d-%Z-%H%M%S).ged"

        echo "Backing up database '${databaseName}' to ${databaseBackupPath}" | tee -a backup.log
        gwb2ged ${databaseName} -o ${databaseBackupPath} -charset ASCII 2>&1 | tee -a backup.log
    done;

popd 1> /dev/null
