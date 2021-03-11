#/bin/bash

#!/bin/bash
git config --global http.postBuffer 1048576000
git clone --depth 1 --branch v2.0.0 https://github.com/nasa/GSAP.git /gsap


export GSAP_HOME=/gsap

mkdir -p $PLEXIL_HOME/build
cd $PLEXIL_HOME/build
cmake ..
make