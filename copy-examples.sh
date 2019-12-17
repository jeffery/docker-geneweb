#!/bin/bash

# copy from rom docker ps, usually jeffernz-geneweb or jeffernz-geneweb_1.2
CONTAINER=jeffernz-geneweb

docker cp examples/shakespeare.ged $CONTAINER:/usr/local/var/geneweb/import/
docker cp examples/shakespeare.gw $CONTAINER:/usr/local/var/geneweb/import/
docker cp examples/shakespeare-images.tar.gz $CONTAINER:/usr/local/var/geneweb/import/

docker exec -u 0 -it $CONTAINER chown -R geneweb. /usr/local/var/geneweb/import/shakespeare.ged
docker exec -u 0 -it $CONTAINER chown -R geneweb. /usr/local/var/geneweb/import/shakespeare.gw
docker exec -u 0 -it $CONTAINER chown -R geneweb. /usr/local/var/geneweb/import/shakespeare-images.tar.gz

# Import from GECOM work, but no pictures:
#docker exec -it jeffernz-geneweb_1.2 import.sh

# Import from Geneweb (.gw) with pictures:
docker exec -it $CONTAINER import-gw.sh
