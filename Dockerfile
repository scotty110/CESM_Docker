# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the base image
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
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

# Fix SVN certs
COPY svn-ccsm-cert.crt /usr/local/share/ca-certificates/svn-ccsm-cert.crt
RUN chmod 644 /usr/local/share/ca-certificates/svn-ccsm-cert.crt

# Update CA certificates
RUN update-ca-certificates

# Configure SVN to use the certificate
RUN mkdir -p /root/.subversion && \
    echo "[global]" > /root/.subversion/servers && \
    echo "ssl-authority-files = /etc/ssl/certs/ca-certificates.crt" >> /root/.subversion/servers

# Download CESM
WORKDIR /opt
RUN git clone https://github.com/escomp/cesm.git my_cesm_sandbox

# Config
WORKDIR /opt/my_cesm_sandbox
RUN git fetch --all
RUN git checkout release-cesm2.1.2
RUN git pull origin release-cesm2.1.2

# Fix manage_externals
RUN rm -r manage_externals
RUN git clone https://github.com/ESMCI/manage_externals.git

# Debugging: Print the contents of the CA certificates file
RUN cat /etc/ssl/certs/ca-certificates.crt | openssl x509 -noout -text

# Get Deps - use a specific pattern for grep
RUN openssl x509 -in /etc/ssl/certs/ca-certificates.crt -text -noout | grep "CN=*.cgd.ucar.edu" || (echo "Certificate not found" && exit 1)

# Get Deps
RUN ./manage_externals/checkout_externals

