#/bin/bash

#!/bin/bash
git config --global http.postBuffer 1048576000
git clone --depth 1 --branch v1.0-OW https://github.com/nasa/GSAP.git /gsap


export GSAP_HOME=/gsap

mkdir -p $GSAP_HOME/build
cd $GSAP_HOME/build
cmake ..
make