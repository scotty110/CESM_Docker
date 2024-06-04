#!/bin/bash

# Get
#echo | openssl s_client -showcerts -servername svn-ccsm-models.cgd.ucar.edu -connect svn-ccsm-models.cgd.ucar.edu:443 2>/dev/null | openssl x509 -inform pem -out svn-ccsm-cert.pem
echo | openssl s_client -showcerts -servername svn-ccsm-models.cgd.ucar.edu -connect svn-ccsm-models.cgd.ucar.edu:443 2>/dev/null | openssl x509 -inform pem -out svn-ccsm-cert.crt

# Verify
#openssl x509 -in svn-ccsm-cert.pem -text -noout
openssl x509 -in svn-ccsm-cert.crt -text -noout


