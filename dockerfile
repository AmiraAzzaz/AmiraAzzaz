#Download base image ubuntu 18.04
FROM ubuntu:18.04
ENV USER=root

# LABEL about the custom image
LABEL maintainer="amira.azzez@telecom-paris.fr"

# Update Ubuntu Software repository
RUN apt-get update

# create the gitlab file
RUN mkdir gitlab && cd gitlab
RUN apt-get update && apt-get install git --yes
RUN git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git 
WORKDIR /openairinterface5g
RUN git checkout develop
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install apt-utils --yes

#run build_oai to build the target image
RUN rm -Rf /oai-ran
WORKDIR /oai-ran
COPY . .
RUN apt-get install build-essential --yes
ENTRYPOINT ["/bin/bash", "-c", "source oaienv"]
WORKDIR cmake_targets && \
    rm -Rf log && \
    mkdir -p log && \
    ./build_oai -I && \
    ./build_oai --nrUE -gNB

WORKDIR /ran_build/build && \
    RUN make -C rfsimulator
RUN ln -s librfsimulator.so liboai_device.so

ENTRYPOINT ["RFSIMULATOR=server ./nr-softmodem", "–O", "../../../targets/PROJECTS/GENERIC-LTE-EPC/CONF/gnb.band78.tm1.106PRB.usrpn300.conf", "–parallel-config", "PARALLEL_SINGLE_THREAD", "--rfsim", "--phy-test"]
