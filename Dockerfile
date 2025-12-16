ARG BASE_IMAGE=almalinux:9.7

FROM ${BASE_IMAGE}
RUN dnf install -y epel-release && \
    dnf update -y && \
    dnf install -y gcc gcc-c++ make cmake git python3-pip zlib-devel expat-devel wget which && \
    dnf install -y tbb-devel && \
    dnf install -y rsync && \
    dnf install -y binutils libX11-devel libXpm-devel libXft-devel libXext-devel python openssl-devel xrootd-client-devel xrootd-libs-devel && \
    dnf install -y libtiff libtiff-devel libpng libpng-devel jasper libjpeg giflib && \
    dnf --enablerepo=crb install -y xxhash-devel && \
    dnf clean all

# build ROOT
# https://root.cern/install/dependencies/
WORKDIR /workspace
#RUN wget https://github.com/root-project/root/releases/download/v6-32-06/root_v6.32.06.Linux-almalinux9.4-x86_64-gcc11.4.tar.gz && \
#    tar -xvf root_v6.32.06.Linux-almalinux9.4-x86_64-gcc11.4.tar.gz && \
#    rm -f root_v6.32.06.Linux-almalinux9.4-x86_64-gcc11.4.tar.gz && \
#    source /workspace/root/bin/thisroot.sh
RUN wget https://github.com/root-project/root/releases/download/v6-38-00/root_v6.38.00.Linux-almalinux9.7-x86_64-gcc11.5.tar.gz && \
    tar -xvf root_v6.38.00.Linux-almalinux9.7-x86_64-gcc11.5.tar.gz && \
    rm -f root_v6.38.00.Linux-almalinux9.7-x86_64-gcc11.5.tar.gz && \
    source /workspace/root/bin/thisroot.sh

# build GEANT4
WORKDIR /workspace
RUN wget https://github.com/Geant4/geant4/archive/refs/tags/v11.2.2.tar.gz && \
    tar -xvf v11.2.2.tar.gz && \
    mv geant4-11.2.2/ geant4-v11.2.2 && \
    mkdir geant4-v11.2.2-build && \
    cd geant4-v11.2.2-build && \
    cmake -DCMAKE_INSTALL_PREFIX=/workspace/geant4-v11.2.2-install -DGEANT4_INSTALL_DATA=ON ../geant4-v11.2.2 && \
    make -j20 && make install && \
    cd /workspace && rm -rf geant4-v11.2.2 geant4-v11.2.2-build v11.2.2.tar.gz

# build Pythia8
WORKDIR /workspace
RUN wget https://www.pythia.org/download/pythia83/pythia8315.tgz && \
    tar -xvf pythia8315.tgz && \
    mv pythia8315 pythia8 && \
    cd pythia8 && \
    ./configure --prefix=/workspace/pythia8-install --with-root=/workspace/root --with-geant4=/workspace/geant4-v11.2.2-install && \
    make -j20 && make install && \
    cd /workspace && rm -rf pythia8 pythia8315.tgz


# environment
COPY pythia8.sh /workspace/pythia8-install/bin/
COPY entrypoint.sh /workspace/
RUN chmod +x /workspace/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/workspace/entrypoint.sh"]
