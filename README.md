# CAM/CESM on Grace Hopper 
Here we present a docker container that runs on both x86 and arm processors?

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

