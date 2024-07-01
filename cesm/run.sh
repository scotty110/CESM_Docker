#!/bin/bash

#docker run -it cesm /bin/bash
docker run -it -v $HOME/Documents/SML/Supervision/MSc/cesm_inputs:/root/cesm cesm /bin/bash

