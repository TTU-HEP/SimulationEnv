ARG BASE_IMAGE=almalinux:9.4

FROM ${BASE_IMAGE}
RUN dnf install -y epel-release & dnf update -y && \
    dnf install -y gcc gcc-c++ make cmake git python3-pip zlib-devel expat-devel wget which && \
    dnf install -y tbb-devel && \
    dnf install -y binutils libX11-devel libXpm-devel libXft-devel libXext-devel python openssl-devel xrootd-client-devel xrootd-libs-devel && \
    dnf --enablerepo=crb  install -y xxhash-devel && \
    dnf clean all

# build ROOT
# https://root.cern/install/dependencies/
WORKDIR /workspace
COPY root_v6.32.06.Linux-almalinux9.4-x86_64-gcc11.4.tar.gz /workspace/
RUN tar -xvf root_v6.32.06.Linux-almalinux9.4-x86_64-gcc11.4.tar.gz && \
    rm -f root_v6.32.06.Linux-almalinux9.4-x86_64-gcc11.4.tar.gz && \
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

# environment
COPY entrypoint.sh /workspace/
RUN chmod +x /workspace/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/workspace/entrypoint.sh"]