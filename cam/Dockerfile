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
# https://portal.hdfgroup.org/downloads/
WORKDIR /opt
RUN wget https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.3/hdf5-1.14.4-3.tar.gz && \
    tar -xzvf hdf5-1.14.4-3.tar.gz && \
    rm hdf5-1.14.4-3.tar.gz && \
    mv hdf5-1.14.4-3 hdf5 

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
# https://downloads.unidata.ucar.edu/netcdf/
WORKDIR /opt
RUN wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz && \
    tar -xzvf netcdf-c-4.9.2.tar.gz && \
    rm netcdf-c-4.9.2.tar.gz && \
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

# Make PIO Parallel I/0
# https://www2.cesm.ucar.edu/models/pio/
WORKDIR /opt
RUN wget https://github.com/NCAR/ParallelIO/archive/refs/tags/pio2_3_1.tar.gz && \
    tar -xzvf pio2_3_1.tar.gz && \
    rm pio2_3_1.tar.gz && \
    mv ParallelIO-pio2_3_1 pio 

WORKDIR /opt/pio
RUN mkdir build
WORKDIR /opt/pio/build

ENV PIO_PATH /usr/local/pio
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PIO_PATH/lib

RUN cmake -DNetCDF_C_PATH=$NETCDF_PATH -DPNetCDF_PATH=$PNETCDF_PATH -DCMAKE_INSTALL_PREFIX=$PIO_PATH -DPIO_ENABLE_FORTRAN=OFF .. 
RUN make
RUN make install

# Install VIM
RUN apt remove -y gfortran && apt install -y gfortran-9
RUN ln -s /usr/bin/gfortran-9 /usr/bin/gfortran
RUN apt update && apt install -y vim

# Install Fortran NetCDF
WORKDIR /opt
RUN wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz && \
    tar -xzvf v4.6.1.tar.gz && \
    rm v4.6.1.tar.gz && \
    mv netcdf-fortran-4.6.1 netcdf-fortran

WORKDIR /opt/netcdf-fortran
RUN mkdir build
WORKDIR /opt/netcdf-fortran/build

ENV NETCDF_FORTRAN_PATH /usr/local/netcdf_fortran
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$NETCDF_FORTRAN_PATH/lib
ENV PATH $NETCDF_FORTRAN_PATH/bin:$PATH

#RUN CPPFLAGS="-I$(nc-config --includedir)" LDFLAGS="-L$(nc-config --libdir --libs)" ./configure
#RUN cmake -DNetCDF_DIR=$NETCDF_PATH -DCMAKE_INSTALL_PREFIX=$NETCDF_FORTRAN_PATH ..
#RUN CPPFLAGS="-I$(nc-config --includedir)" LDFLAGS="-L$(nc-config --libdir --libs)" ./configure --prefix=$NETCDF_FORTRAN_PATH --disable-dependency-tracking
RUN CPPFLAGS="-I$(nc-config --includedir)" LDFLAGS="-L$(nc-config --libdir)" ./configure --prefix=$NETCDF_FORTRAN_PATH --disable-dependency-tracking
RUN make
RUN make install
