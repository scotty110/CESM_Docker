FROM ubuntu:latest
#FROM ubuntu:noble

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
#RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
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
RUN ./configure --enable-orterun-prefix-by-default && \
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
RUN cmake .. && \
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
ENV LAPACK_PATH /usr/local/lapack
RUN cmake .. && \
    make -j $(nproc) && \
    make install 

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

###############################################
# Install HDF5, NetCDF-C, NetCDF-Fortran, PIO #
###############################################
# MPI Compiler Support
ENV CC /usr/local/bin/mpicc
ENV FC /usr/local/bin/mpif90
ENV CXX /usr/local/bin/mpicxx

# Install HDF5
# https://portal.hdfgroup.org/downloads/
WORKDIR /opt
RUN wget https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.3/hdf5-1.14.4-3.tar.gz && \
    tar -xzvf hdf5-1.14.4-3.tar.gz && \
    rm hdf5-1.14.4-3.tar.gz && \
    mv hdf5-1.14.4-3 hdf5 

WORKDIR /opt/hdf5/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DHDF5_ENABLE_PARALLEL=ON  .. && \
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
RUN cmake .. && \
    make -j $(nproc) && \
    make install

# Install NetCDF-Fortran
WORKDIR /opt
RUN wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz && \
    tar -xzvf v4.6.1.tar.gz && \
    rm v4.6.1.tar.gz && \
    mv netcdf-fortran-4.6.1 netcdf-fortran

WORKDIR /opt/netcdf-fortran
RUN CPPFLAGS="-I$(nc-config --includedir)" LDFLAGS="-L$(nc-config --libdir)" ./configure --disable-dependency-tracking && \
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
RUN cmake -DPIO_ENABLE_FORTRAN=OFF .. && \
    make -j $(nproc) && \
    make install

