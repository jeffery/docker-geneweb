#!/usr/bin/env bash

pushd ${HOME} 1> /dev/null

OLD_IFS=${IFS}
IFS="
"
    for gw in $(ls -f import/*.gw 2> /dev/null);
    do
        gwComFile=$(basename ${gw})
        baseName=$(echo $(echo "${gwComFile%.*}") | tr -cd '[:alnum:]-')
        echo "Importing Geneweb (.gw) file '${PWD}/${gw}' as '${baseName}'" | tee -a import.log
        gwc -nofail -f "${PWD}/${gw}" -o ${baseName} 2>&1 | tee -a import.log

	# images
	if [ -f "import/${baseName}-images.tar.gz" ]; then
	    echo "Importing Images from ${baseName}"
	    mkdir -p /usr/local/var/geneweb/images/${baseName}/
            tar -xf import/${baseName}-images.tar.gz --strip=1 -C /usr/local/var/geneweb/images/${baseName}/
	else
	    echo "Database ${baseName }has no images. skyp"
	fi
    done;

IFS=${OLD_IFS}

popd 1> /dev/null
