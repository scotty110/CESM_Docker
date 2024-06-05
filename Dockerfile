# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the base image
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    ca-certificates \
    git \
    subversion \
    cmake \
    build-essential \
    gfortran \
    libblas-dev \
    liblapack-dev \
    openmpi-bin \
    wget \
    openssl && \
    apt-get clean

# Install Miniconda
WORKDIR /opt
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

# Add cert ccsm-cert (incommon signed)
COPY svn-ccsm-cert.crt /usr/local/share/ca-certificates
RUN chmod 644 /usr/local/share/ca-certificates/svn-ccsm-cert.crt

# Add InCommon
COPY incommon.crt /usr/local/share/ca-certificates
RUN chmod 644 /usr/local/share/ca-certificates/incommon.crt

# Update CA certificates
RUN update-ca-certificates

# SSL verification for SVN, proving difficult
RUN echo "[global]" > /etc/subversion/servers && \
    echo "ssl-authority-files = /etc/ssl/certs/ca-certificates.crt" >> /etc/subversion/servers && \
    echo "ssl-trust-default-ca = yes" >> /etc/subversion/servers && \
    echo "ssl-ignore-unknown-ca = no" >> /etc/subversion/servers

# Download CESM
WORKDIR /opt
RUN git clone https://github.com/escomp/cesm.git my_cesm_sandbox

# Configure CESM
WORKDIR /opt/my_cesm_sandbox
RUN git fetch --all
RUN git checkout release-cesm2.1.2
RUN git pull origin release-cesm2.1.2

# Fix manage_externals
RUN rm -r manage_externals
RUN git clone https://github.com/ESMCI/manage_externals.git

# Get dependencies
RUN ./manage_externals/checkout_externals
