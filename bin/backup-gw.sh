#!/usr/bin/env bash

pushd ${HOME} 1> /dev/null

    mkdir -p backup

    for base in `ls -d *.gwb 2> /dev/null`;
    do
        geneWebBase=$(basename ${base})
        databaseName=$(echo "${geneWebBase%.*}")
	#date=$(date +%Y%m%d-%Z-%H%M%S)
	date=$(date +%Y-%m-%d-%H%M)
	mkdir -p backup/${databaseName}/${date}/
	databaseBackupPath="$(pwd)/backup/${databaseName}/${date}/${databaseName}.gw"
	imageBackupPath="$(pwd)/backup/${databaseName}/${date}/${databaseName}-images.tar.gz"

        echo "Backing up database '${databaseName}' to ${databaseBackupPath}" | tee -a backup.log
	gwu ${databaseName} -o ${databaseBackupPath} 2>&1 | tee -a backup.log
	# images
	if [ -d /usr/local/var/geneweb/images/${databaseName} ]; then
	    echo "Backing up images from '${databaseName}' to ${imageBackupPath}"
	    tar -zcvf ${imageBackupPath} -C /usr/local/var/geneweb/images/ ${databaseName}  2>&1 | tee -a backup.log
	else
	    echo "Database ${databaseName} has no images."
	fi
    done;

popd 1> /dev/null
