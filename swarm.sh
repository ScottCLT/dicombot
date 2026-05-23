#!/bin/bash
docker swarm init
docker service create --name dicombotSwarm --replicas 20 --env IPADDRESS="10.1.1.100" --env AETITLE="DICOMBOT" --env STORAGEIP="10.1.1.100" --env STORAGEPORT="11112" --env STORAGEAE="DCM4CHEE" --env RETRIEVEIP="10.1.1.100" --env RETRIEVEPORT="11112" --env RETRIEVEAE="DCM4CHEE" --env DICOMFILES=1 -v /path/to/mount/folder:/var/dcm/mount scottclt/dicombot
