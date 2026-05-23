FROM ubuntu:24.04
WORKDIR	/var/dcm
RUN apt-get update
RUN apt-get install -y dcmtk
RUN apt-get install -y libgdcm-tools
RUN mkdir -p /var/dcm
RUN mkdir -p /var/dcm/retrieve
RUN chmod -R 777 /var/dcm
COPY ./mod-store-get.sh /var/dcm
COPY ./dcm/*.DCM /var/dcm
ENTRYPOINT /var/dcm/mod-store-get.sh
