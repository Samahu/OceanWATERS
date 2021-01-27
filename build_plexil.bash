#!/bin/bash

git clone https://git.code.sf.net/p/plexil/git /plexil
pushd /plexil
git checkout tags/2020-11-17 -b branch-2020-11-17
popd

export PLEXIL_HOME=/plexil
source $PLEXIL_HOME/scripts/plexil-setup.sh

cd $PLEXIL_HOME
make src/configure
cd src
./configure CFLAGS="-g -O2" CXXFLAGS="-g -O2" --prefix=$PLEXIL_HOME --disable-static --disable-viewer --enable-ipc
cd $PLEXIL_HOME
make