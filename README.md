## dicombot
PACS load tester

#what is dicombot?

dicombot is a load-testing tool for PACS servers. It's developed with the goal of providing an easy-to-use solution for testing PACS servers and making sure that they are performing as expected with a high load. It uses DICOM files and communicates using DIMSE commands that are part of the DICOM standard. It can be used with any PACS server that supports DICOM communication. dicombot allows you to spin up 1, 10, 100, 1000, etc. DICOM connections at once that store and retrieve from the server automatically.


#how do I get dicombot?

dicombot is a Docker container image. You need to have Docker installed to use it. This can be done on Linux, Windows, or MacOS. Once Docker is installed, you can get dicombot from the Docker Hub using the following command:

 
#docker pull scottclt/dicombot:latest
 

You can find out more about the container on Docker Hub, including its current vulnerabilities as scanned by Docker Scout. Please note that as of 25.04.2026, all known vulnerabilties are tied to the DICOM libraries that are used in the creation of dicombot. Those libraries will need to be updated before the vulnerabilities can be resolved in the Docker Scout scan.


#ok, i've got the dicombot image. how do i use it?

dicombot should be started from the terminal/command prompt. It requires 7 environment variables (and an optional 8th) to be passed on either the "docker run" or "docker service create" command. The environment variables are:

AETITLE:	Client AE Title
STORAGEIP:	PACS server storage IP SCP address
STORAGEPORT:	PACS server storage SCP port
STORAGEAE:	PACS storage AE SCP Title
RETRIEVEIP:	PACS server retrieve SCP IP address. This is often the same as the storage IP.
RETRIEVEPORT:	PACS server retrieve SCP port. This is often the same as the storage port.
RETRIEVEAE:	PACS server retrieve SCP AE Title. This is often the same as the storage AE Title. Must be a C-GET SCP (C-MOVE is not currently supported).
DICOMFILES (optional):	leave this variable out if using built-in DICOM files. Set to "1" if providing DICOM files using a mounted folder. The mount must be created using the "-v" parameter on the docker run or docker service create commands. The host folder must be mounted to the container folder /var/dcm/mount. The DICOM files in this folder must have extension .DCM (case sensitive).

Example syntax 1 - running a single container:

 
docker run --name=dicombot --env AETITLE="DICOMBOT" --env STORAGEIP="10.1.1.100" --env STORAGEPORT="11112" --env STORAGEAE="DCM4CHEE" --env RETRIEVEIP="10.1.1.100" --env RETRIEVEPORT="11112" --env RETRIEVEAE="DCM4CHEE" --env DICOMFILES=1 -v /path/to/mount/folder:/var/dcm/mount scottclt/dicombot
 

Example syntax 2 - running service/swarm of multiple containers:

 
docker service create --name dicombotSwarm --replicas 20 --env IPADDRESS="10.1.1.100" --env AETITLE="DICOMBOT" --env STORAGEIP="10.1.1.100" --env STORAGEPORT="11112" --env STORAGEAE="DCM4CHEE" --env RETRIEVEIP="10.1.1.100" --env RETRIEVEPORT="11112" --env RETRIEVEAE="DCM4CHEE" --env DICOMFILES=1 -v /path/to/mount/folder:/var/dcm/mount scottclt/dicombot
 


#tell me more about dicombot - what does it do exactly?

dicombot uses either a prepackaged set of 595 anonymized MR DICOM files OR a folder of DICOM files provided on the host machine (if the volume is mounted and the DICOMFILES="1" environment variable is passed) and operates in four steps:
Assigns new random SOP Instance, Series Instance, and Study Instance UIDs to the set of files. Also assigns a random number to First Name, Last Name, and Patient ID DICOM tags (first and last name are preceded by "dicombot-").

Stores all newly numerated files to a PACS server.

Queries Study-level for all studies using the patient ID generated in step 1.

Retrieves (via CGET) all files stored in step 2 from the PACS server.


#can do i use docker compose with dicombot?

Yes, of course! Docker Compose can be used with dicombot. Here's an example configuration to get you going:

 
services:
  dicombot:
    container_name: dicombot
    image: scottclt/dicombot
    environment:
      - AETITLE=DICOMBOT
      - STORAGEIP=10.1.1.100
      - STORAGEPORT=11112
      - STORAGEAE=DCM4CHEE
      - RETRIEVEIP=10.1.1.100
      - RETRIEVEPORT=11112
      - RETRIEVEAE=DCM4CHEE
      - DICOMFILES=1
    volumes:
      - /path/to/mount/folder:/var/dcm/mount
    restart: unless-stopped
 

Once you've saved that to a file called compose.yml (make sure to edit it with your environment's particular configuration), you can run Docker Compose from the directory that your compose.yml file is stored in. Here's the syntax:

 
docker compose up -d
 


#what tools were used to create dicombot?

Tools used in this container: gdcm, dcmtk


#i need help with dicombot

You can find dicombot on GitHub at https://www.github.com/scottclt/dicombot and on DockerHub at https://hub.docker.com/r/scottclt/dicombot. If you need additional assistance with dicombot, contact Scott Mallonee at scott@mallonee.org
