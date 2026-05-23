#!/bin/bash
docker stop dicombot
docker rm dicombot
docker run --name dicombot --env IPADDRESS="10.0.3.214" --env SERVERPORT="11112" --env CALLING="DICOMBOT" --env CALLED="DCM4CHEE" scottclt/dicombot
