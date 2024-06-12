FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive


# Update and upgrade the base image
# Install the packages that shouldn't affect the build process as all
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    ca-certificates \
    git \
    subversion \
    cmake \
    build-essential \
    libxml-libxml-perl \
    wget \
    openssl \ 
    zlib1g && \
    apt-get clean

# Install Miniconda
WORKDIR /opt
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/miniconda && \
    rm miniconda.sh

# Set up the conda environment
ENV PATH="/opt/miniconda/bin:$PATH"
RUN conda init && \
    conda config --set auto_activate_base false

# Ensure conda is available in non-interactive shells
RUN echo "source /opt/miniconda/etc/profile.d/conda.sh" >> ~/.bashrc

# Conda install python version which works
RUN conda install python=3.8

##############WWWWW##################################
# Install GCC, Fortran, MPI, BLAS, LAPACK, and zlib #
#####################################################
# Install GCC-9
RUN apt remove -y gcc && apt update && apt install -y gcc-9 g++-9
RUN ln -s /usr/bin/gcc-9 /usr/bin/gcc
RUN ln -s /usr/bin/g++-9 /usr/bin/g++

# Install Fortran
# Build for source maybe if becomes outdated: https://gcc.gnu.org/wiki/GFortranBinaries#FromSource
RUN apt install -y gfortran-9 
RUN ln -s /usr/bin/gfortran-9 /usr/bin/gfortran

# Install MPI
# https://www.open-mpi.org/software/ompi/v5.0/
WORKDIR /opt
RUN wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.3.tar.gz && \
    tar -xzvf openmpi-5.0.3.tar.gz && \
    rm openmpi-5.0.3.tar.gz && \
    mv openmpi-5.0.3 openmpi

WORKDIR /opt/openmpi
ENV OPENMPI_PATH /usr/local/openmpi
RUN ./configure --prefix=$OPENMPI_PATH --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install

ENV PATH $PATH:$OPENMPI_PATH/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$OPENMPI_PATH/lib

# Install BLAS
# Only latest version is on site: https://netlib.org/blas/
# Maybe could downgrade by selecting version ??? Something to investigate if need by
WORKDIR /opt
RUN wget http://www.netlib.org/blas/blas-3.12.0.tgz && \
    tar -xzvf blas-3.12.0.tgz && \
    rm blas-3.12.0.tgz && \
    mv BLAS-3.12.0 blas 

WORKDIR /opt/blas
RUN mkdir build
WORKDIR /opt/blas/build
ENV BLAS_PATH /usr/local/blas
RUN cmake -DCMAKE_INSTALL_PREFIX=$BLAS_PATH .. && \
    make -j $(nproc) && \
    make install

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$BLAS_PATH/lib

# Install LAPACK
# Version from 2022: https://www.netlib.org/lapack/#_lapack_version_3_11_0
WORKDIR /opt
RUN wget https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.11.0.tar.gz && \
    tar -xzvf v3.11.0.tar.gz && \
    rm v3.11.0.tar.gz && \
    mv lapack-3.11.0 lapack 

WORKDIR /opt/lapack
RUN mkdir build
WORKDIR /opt/lapack/build
ENV LAPACK_PATH /usr/local/lapack
RUN cmake -DCMAKE_INSTALL_PREFIX=$LAPACK_PATH .. && \
    make -j $(nproc) && \
    make install 

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$LAPACK_PATH/lib

# Install zlib
# https://zlib.net/
WORKDIR /opt
RUN wget https://www.zlib.net/zlib-1.3.1.tar.gz && \
    tar -xzvf zlib-1.3.1.tar.gz && \
    rm zlib-1.3.1.tar.gz && \
    mv zlib-1.3.1 zlib

WORKDIR /opt/zlib
ENV ZLIB_PATH /usr/local/zlib
RUN mkdir build
WORKDIR /opt/zlib/build
RUN cmake -DCMAKE_INSTALL_PREFIX=$ZLIB_PATH .. && \
    make -j $(nproc) && \
    make install

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ZLIB_PATH/lib


###############################################
# Install HDF5, NetCDF-C, NetCDF-Fortran, PIO #
###############################################
# MPI Compiler Support
ENV CC /usr/local/openmpi/bin/mpicc
ENV FC /usr/local/openmpi/bin/mpif90
ENV CXX /usr/local/openmpi/bin/mpicxx

# Install HDF5
# https://portal.hdfgroup.org/downloads/
WORKDIR /opt
RUN wget https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.3/hdf5-1.14.4-3.tar.gz && \
    tar -xzvf hdf5-1.14.4-3.tar.gz && \
    rm hdf5-1.14.4-3.tar.gz && \
    mv hdf5-1.14.4-3 hdf5 

WORKDIR /opt/hdf5
ENV HDF5_PATH /usr/local/hdf5
RUN mkdir builds
WORKDIR /opt/hdf5/builds
RUN cmake -DCMAKE_INSTALL_PREFIX=$HDF5_PATH -DHDF5_ENABLE_PARALLEL=ON .. && \
    make -j $(nproc) && \
    make install

ENV PATH $HDF5_PATH/bin:$PATH
ENV LD_LIBRARY_PATH $HDF5_DIR/lib:$LD_LIBRARY_PATH

# Install NetCDF-C
# https://downloads.unidata.ucar.edu/netcdf/
WORKDIR /opt
RUN wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz && \
    tar -xzvf netcdf-c-4.9.2.tar.gz && \
    rm netcdf-c-4.9.2.tar.gz && \
    mv netcdf-c-4.9.2 netcdf-c

WORKDIR /opt/netcdf-c
RUN mkdir build
WORKDIR /opt/netcdf-c/build
ENV NETCDF_C_PATH /usr/local/netcdf
RUN cmake -DCMAKE_INSTALL_PREFIX=$NETCDF_C_PATH .. && \
    make -j $(nproc) && \
    make install

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$NETCDF_C_PATH/lib
ENV PATH $NETCDF_C_PATH/bin:$PATH


