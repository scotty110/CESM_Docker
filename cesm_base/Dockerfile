FROM nvcr.io/nvidia/cuda-dl-base:24.09-cuda12.6-devel-ubuntu22.04
#FROM ubuntu:latest

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
    m4 \
    build-essential \
    libxml-libxml-perl \
    wget \
    curl \
    libcurl4-openssl-dev \
    zlib1g \
    zlib1g-dev && \ 
    apt-get clean

# Install Miniconda
WORKDIR /opt
#RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh && \
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
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

##########################
# Install Nvidia HPC SDK #
##########################
# Link: https://developer.nvidia.com/hpc-sdk
RUN curl https://developer.download.nvidia.com/hpc-sdk/ubuntu/DEB-GPG-KEY-NVIDIA-HPC-SDK | gpg --dearmor -o /usr/share/keyrings/nvidia-hpcsdk-archive-keyring.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/nvidia-hpcsdk-archive-keyring.gpg] https://developer.download.nvidia.com/hpc-sdk/ubuntu/amd64 /' | tee /etc/apt/sources.list.d/nvhpc.list && \
    apt-get update -y && \
    apt-get install -y nvhpc-24-11

# Set environment variables
ENV NVHPC=/opt/nvidia/hpc_sdk/Linux_x86_64/24.11/compilers
ENV PATH=$NVHPC/bin:$PATH

#######################################
# Install MPI, BLAS, LAPACK, and zlib #
#######################################
# Replace with Nvidia Compilers
#RUN ln -s $(which nvc) /usr/bin/gcc
#RUN ln -s $(which nvcc) /usr/bin/g++

# Install Fortran
#RUN ln -s $(which nvfortran) /usr/bin/gfortran

# Install MPI
# https://www.open-mpi.org/software/ompi/v5.0/
WORKDIR /opt
RUN wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.3.tar.gz && \
    tar -xzvf openmpi-5.0.3.tar.gz && \
    rm openmpi-5.0.3.tar.gz && \
    mv openmpi-5.0.3 openmpi

WORKDIR /opt/openmpi
RUN ./configure \
    CC=$(which nvc) \
    CXX=$(which nvc++) \
    FC=$(which nvfortran) \
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
    FFLAGS="-fPIC" \
    FCFLAGS="-fPIC" \
    --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install

# Install BLAS
# Only latest version is on site: https://netlib.org/blas/
# Maybe could downgrade by selecting version ??? Something to investigate if need by
WORKDIR /opt
RUN wget http://www.netlib.org/blas/blas-3.12.0.tgz && \
    tar -xzvf blas-3.12.0.tgz && \
    rm blas-3.12.0.tgz && \
    mv BLAS-3.12.0 blas 

WORKDIR /opt/blas/build
RUN cmake .. -DCMAKE_C_COMPILER=$(which nvc) -DCMAKE_CXX_COMPILER=$(which nvc++) -DCMAKE_Fortran_COMPILER=$(which nvfortran) && \
    make -j $(nproc) && \
    make install

# Install LAPACK
# Version from 2022: https://www.netlib.org/lapack/#_lapack_version_3_11_0
WORKDIR /opt
RUN wget https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.11.0.tar.gz && \
    tar -xzvf v3.11.0.tar.gz && \
    rm v3.11.0.tar.gz && \
    mv lapack-3.11.0 lapack 

WORKDIR /opt/lapack/build
ENV LAPACK_PATH=/usr/local/lapack
RUN cmake .. -DCMAKE_C_COMPILER=$(which nvc) -DCMAKE_CXX_COMPILER=$(which nvc++) -DCMAKE_Fortran_COMPILER=$(which nvfortran) && \
    make -j $(nproc) && \
    make install 

ENV LD_LIBRARY_PATH=/usr/local/lib

###############################################
# Install HDF5, NetCDF-C, NetCDF-Fortran, PIO #
###############################################
# MPI Compiler Support
ENV CC=/usr/local/bin/mpicc
ENV FC=/usr/local/bin/mpif90
ENV CXX=/usr/local/bin/mpicxx

# Install HDF5
# https://portal.hdfgroup.org/downloads/
WORKDIR /opt
RUN wget https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.3/hdf5-1.14.4-3.tar.gz && \
    tar -xzvf hdf5-1.14.4-3.tar.gz && \
    rm hdf5-1.14.4-3.tar.gz && \
    mv hdf5-1.14.4-3 hdf5 

WORKDIR /opt/hdf5/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DHDF5_ENABLE_PARALLEL=ON -DCMAKE_C_COMPILER=$(which nvc) -DCMAKE_CXX_COMPILER=$(which nvc++) -DCMAKE_Fortran_COMPILER=$(which nvfortran) && \
    make -j $(nproc) && \
    make install

# Install NetCDF-C
# https://downloads.unidata.ucar.edu/netcdf/
WORKDIR /opt
RUN wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz && \
    tar -xzvf netcdf-c-4.9.2.tar.gz && \
    rm netcdf-c-4.9.2.tar.gz && \
    mv netcdf-c-4.9.2 netcdf-c

WORKDIR /opt/netcdf-c/build
RUN cmake .. -DCMAKE_C_COMPILER=$(which nvc) -DCMAKE_CXX_COMPILER=$(which nvc++) -DCMAKE_Fortran_COMPILER=$(which nvfortran) && \
    make -j $(nproc) && \
    make install

# Install NetCDF-Fortran
WORKDIR /opt
RUN wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz && \
    tar -xzvf v4.6.1.tar.gz && \
    rm v4.6.1.tar.gz && \
    mv netcdf-fortran-4.6.1 netcdf-fortran

WORKDIR /opt/netcdf-fortran
RUN export CPPFLAGS="-I$(nc-config --includedir)" \
    LDFLAGS="-L$(nc-config --libdir)" \
    LIBS="$(nc-config --libs)" \
    CC=$(which nvc) \
    CXX=$(which nvc++) \
    FC=$(which nvfortran) \
    CFLAGS="-fPIC -fpic" \
    CXXFLAGS="-fPIC -fpic" \
    FFLAGS="-fPIC -fpic" \
    FCFLAGS="-fPIC -fpic" && \
    ./configure \
    --prefix=/usr/local \
    --disable-dependency-tracking \
    --enable-shared \
    --enable-static \
    --with-pic && \
    make -j $(nproc) && \
    make install

# Make PIO Parallel I/0
# https://www2.cesm.ucar.edu/models/pio/
WORKDIR /opt
RUN wget https://github.com/NCAR/ParallelIO/archive/refs/tags/pio2_3_1.tar.gz && \
    tar -xzvf pio2_3_1.tar.gz && \
    rm pio2_3_1.tar.gz && \
    mv ParallelIO-pio2_3_1 pio 

WORKDIR /opt/pio/build
RUN cmake .. \
    -DPIO_ENABLE_FORTRAN=OFF \
    -DPIO_ENABLE_TIMING=OFF \
    -DWITH_PNETCDF=OFF \
    -DPIO_USE_MALLOC=ON \
    -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j $(nproc) && \
    make install

