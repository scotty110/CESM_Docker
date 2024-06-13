#!/bin/bash

#docker run -it cesm /bin/bash
docker run -it -v $HOME/Documents/code/cesm_inputs:/root/cesm cesm /bin/bash

