#!/usr/bin/env bash

pushd ${HOME} 1> /dev/null

    if [[ -n "${HOST_IP}" ]]; then
       echo "${HOST_IP}" > ${HOME}/gwsetup_only.txt
    fi

    umask 007
    TEMP_FILE=`tempfile`

    gwsetup -p 2316 -gd /usr/share/geneweb -lang ${LANGUAGE} -bindir /usr/bin -only ${HOME}/gwsetup_only.txt -log ${TEMP_FILE} 2>&1 | tee -a ${HOME}/gwsetup.log

popd 1> /dev/null
