#!/bin/bash

#docker run -it cesm /bin/bash
#docker run -it -v $HOME/Documents/code/cesm_inputs:/root/cesm cesm /bin/bash
docker run -it --cpus="8" -v $HOME/Documents/thor_shit/cesm_inputs:/root/cesm cesm /bin/bash

