FROM cesm:latest

# Install zlib
RUN apt-get update && apt-get install -y \
    curl \
    zlib1g \
    libcurl4-openssl-dev 

# MPI Compiler Support
ENV CC=/usr/bin/mpicc
ENV FC=/usr/bin/mpif90
ENV CXX=/usr/bin/mpicxx

# Install HDF5
WORKDIR /opt
RUN wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5_1.14.4.3.tar.gz && \
    tar -xzvf hdf5_1.14.4.3.tar.gz && \
    rm hdf5_1.14.4.3.tar.gz && \
    mv hdf5-hdf5_1.14.4.3 hdf5 

WORKDIR /opt/hdf5
ENV HDF5_PATH /usr/local/hdf5
ENV PATH $HDF5_PATH/bin:$PATH
ENV LD_LIBRARY_PATH $HDF5_DIR/lib:$LD_LIBRARY_PATH

RUN mkdir builds
WORKDIR /opt/hdf5/builds
RUN cmake -DCMAKE_INSTALL_PREFIX=$HDF5_PATH -DHDF5_ENABLE_PARALLEL=ON ..
RUN make
RUN make install

# Install NetCDF
WORKDIR /opt
RUN wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz && \
    tar -xzvf v4.9.2.tar.gz && \
    rm v4.9.2.tar.gz && \
    mv netcdf-c-4.9.2 netcdf-c

WORKDIR /opt/netcdf-c
RUN mkdir build
WORKDIR /opt/netcdf-c/build

ENV NETCDF_PATH /usr/local/netcdf
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$NETCDF_PATH/lib
ENV PATH $NETCDF_PATH/bin:$PATH

RUN cmake -DCMAKE_INSTALL_PREFIX=$NETCDF_PATH ..
RUN make
RUN make install

# Set Machine Name
ENV CIME_MACHINE ubuntu-latest
ENV USER root

# Configure CAM 
WORKDIR /opt/my_cesm_sandbox/cime/scripts
RUN mkdir -p /root/cesm/inputdata
