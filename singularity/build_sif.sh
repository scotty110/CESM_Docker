#!/bin/bash

# Build cesm sif file from docker tar
# https://stackoverflow.com/questions/52738888/converting-docker-tar-file-into-a-singularity-image

singularity build cesm.sif docker-archive://cesm_aarch64.tar
