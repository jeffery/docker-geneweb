#!/usr/bin/env bash

pushd ${HOME} 1> /dev/null

    if [[ -n "${HOST_IP}" ]]; then
       echo "${HOST_IP}" > ${HOME}/gwsetup_only.txt
    fi

    gwsetup -p 2316 -gd /usr/share/geneweb -lang ${LANGUAGE} -bindir /usr/bin -only ${HOME}/gwsetup_only.txt -log /dev/null 2>&1 | tee -a ${HOME}/gwsetup.log

popd 1> /dev/null
