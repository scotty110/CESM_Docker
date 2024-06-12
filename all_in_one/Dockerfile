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
    openssl && \
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

##############WWWWW####################################
# Install GCC, Fortran, MPI, BLAS and LAPACK for CESM #
#######################################################
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