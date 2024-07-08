#!/bin/bash

singularity run -B $HOME/cesm_inputs:/home/ucabsoc/cesm --writable-tmpfs cesm.sif /bin/bash

