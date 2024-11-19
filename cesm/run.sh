#!/bin/bash

#docker run -it cesm /bin/bash
docker run --gpus all --ipc=host --ulimit memlock=-1 -it -v $HOME/Documents/cesm_inputs:/root/cesm cesm /bin/bash

