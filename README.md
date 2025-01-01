# CAM/CESM on Grace Hopper 
Here we present a docker container that runs on arm processors?

<div style="text-align: center;">
  <img src="images/egg.jpg" style="width:50%;">
  <p><em>This Docker Container is a Faberge Egg</em></p>
</div>

## Build
### Base CESM 
Base CESM provides the following packages installed from source code by the maintainers:
- Fortran-11
- MPI
- BLAS
- LAPACK
- HDF5 (with parallel support)
- NetCDF-C 
- NetCDF-Fortran
- Parrallel IO (no fortran)

We also install `python-3.8` to manage CESM's ...

How to build:
1. Install docker
2. Navigate to `./cesm_base`
3. Run `./build.sh`. This might take awhile, but should build the container `cesm_base`

Note. This image should be good for a couple of years, may need to update as ubuntu depricates `24.04`

### CESM
This container installes CESM2.2.2 (We included CESM2.1.5 as well, but we were having trouble getting it to run, updates to follow).

To Build
1. Build `cesm_base` image
2. Navigate to `./cesm`
3. Runn `./build.sh` to build the container. This will pull CESM things and takes awhile

## x86
While not supported by this repo, the only hard coded `aarch64` package is the miniconde install script. Probably could replace with `Linux-x86` to build. Untested though.

## Blog Post
Our blog post: [Link](https://medium.com/@twins.corgi.0a/containerizing-cesm-and-porting-to-arm-b9419ed939af)
