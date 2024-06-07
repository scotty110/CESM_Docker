FROM cesm:latest

# Install zlib
RUN apt-get update && apt-get install -y \
    curl \
    zlib1g \
    libcurl4-openssl-dev \
    mpich

# MPI Compiler Support
ENV CC=/usr/bin/mpicc
ENV FC=/usr/bin/mpif90
ENV CXX=/usr/bin/mpicxx

# Install SZIP
WORKDIR /opt
RUN wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz && \
    tar -zxvf szip-2.1.1.tar.gz && \
    rm szip-2.1.1.tar.gz && \
    mv szip-2.1.1 szip

WORKDIR /opt/szip
ENV SZIP_PATH /usr/local/szip
RUN mkdir -p $SZIP_PATH
RUN ./configure --prefix=$SZIP_PATH
RUN make
RUN make install

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$SZIP_PATH/lib

# Install HDF5
WORKDIR /opt
RUN wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5_1.14.4.3.tar.gz && \
    tar -xzvf hdf5_1.14.4.3.tar.gz && \
    rm hdf5_1.14.4.3.tar.gz && \
    mv hdf5-hdf5_1.14.4.3 hdf5 

WORKDIR /opt/hdf5
ENV HDF5_PATH /usr/local/hdf5
ENV PATH $HDF5_PATH/bin:$PATH
ENV LD_LIBRARY_PATH $HDF5_PATH/lib:$LD_LIBRARY_PATH

RUN mkdir builds
WORKDIR /opt/hdf5/builds
RUN cmake -DCMAKE_INSTALL_PREFIX=$HDF5_PATH -DHDF5_ENABLE_PARALLEL=ON -DSZIP_USE_EXTERNAL=ON -DSZIP_DIR=$SZIP_PATH  ..
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
ENV CPATH $NETCDF_PATH/include:$CPATH

RUN cmake -DCMAKE_INSTALL_PREFIX=$NETCDF_PATH -DSzip_INCLUDE_DIRS=$SZIP_PATH/includes ..
RUN make
RUN make install

# Install Fortran NetCDF
WORKDIR /opt
RUN wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz && \
    tar -xzvf v4.6.1.tar.gz && \
    rm v4.6.1.tar.gz && \
    mv netcdf-fortran-4.6.1 netcdf-fortran

WORKDIR /opt/netcdf-fortran
RUN mkdir build
WORKDIR /opt/netcdf-fortran/build

ENV NETCDF_FORTRAN_PATH /usr/local/netcdf

#RUN CFLAGS="-I$(nc-config --includedir)" LDFLAGS="-L$(nc-config --libs)" ./configure --prefix=$NETCDF_FORTRAN_PATH
#RUN cmake -DNetCDF_ROOT=$NETCDF_PATH -DCMAKE_INSTALL_PREFIX=$NETCDF_FORTRAN_PATH ..
