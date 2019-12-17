#!/usr/bin/env bash

pushd ${HOME} 1> /dev/null

OLD_IFS=${IFS}
IFS="
"
    for ged in `ls -f import/*.ged 2> /dev/null`;
    do
        gedComFile=$(basename ${ged})
        baseName=$(echo $(echo "${gedComFile%.*}") | tr -cd '[:alnum:]-')

        echo "Importing GEDCOM file '${PWD}/${ged}' as '${baseName}'" | tee -a import.log
        ged2gwb2 -f "${PWD}/${ged}" -o ${baseName} 2>&1 | tee -a import.log
    done;

IFS=${OLD_IFS}

popd 1> /dev/null
