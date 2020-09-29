#!/bin/bash

git clone https://git.code.sf.net/p/plexil/git /plexil
# update to latest commit known to compile successfully
pushd /plexil
git checkout 51813f1f6846d37b401bc088f0f5aeb5debb9841
popd

export PLEXIL_HOME=/plexil
source $PLEXIL_HOME/scripts/plexil-setup.sh

cd $PLEXIL_HOME
make src/configure
cd src
./configure CFLAGS="-g -O2" CXXFLAGS="-g -O2" --prefix=$PLEXIL_HOME --disable-static --disable-viewer --enable-ipc
cd $PLEXIL_HOME
make