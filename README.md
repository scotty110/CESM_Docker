# CAM/CESM on Grace Hopper 
Here we present a docker container that runs on both x86 and arm processors?

<div style="text-align: center;">
  <img src="images/egg.jpg" style="width:50%;">
  <p><em>This Docker Container is a Faberge Egg</em></p>
</div>

## Build
### Base CESM 
Base CESM container installes compilers and pulls the needed repos to build and run projects. Note this does not include dependencies like NetCDF (may add later). You can compile for x86 by changing the miniconda package to `Linux-x86_64.sh`. 
1. `cd ./cesm`
2. `./build.sh`

## Download Intermediate Certs
1. Verify that still using InCommon: `openssl x509 -in svn-ccsm-cert.crt -text -noout`. Should give something like: ```Data:
        Version: 3 (0x2)
        Serial Number:
            21:85:bc:d4:dd:fc:31:57:42:bb:12:ed:fa:c6:df:6f
        Signature Algorithm: sha384WithRSAEncryption
        Issuer: C = US, O = Internet2, CN = InCommon RSA Server CA 2
        Validity
            Not Before: Jan 22 00:00:00 2024 GMT
            Not After : Jan 21 23:59:59 2025 GMT
        Subject: C = US, ST = Colorado, O = University Corporation for Atmospheric Research, CN = *.cgd.ucar.edu
        Subject Public Key Info: ...```
2. Navigate to [Link](https://uit.stanford.edu/service/ssl/chain) or [Link](https://it.colostate.edu/incommon-certificates/#)
3. Other potential cert Link: [Link](https://it.colostate.edu/incommon-certificates/#) [From](https://incommon.org/certificates/repository/)

[Link](https://github.com/NordicESMhub/containers)
[Link](https://github.com/NordicESMhub/cesm_docker_libs)

