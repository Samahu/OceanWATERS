#!/bin/bash
git config --global http.postBuffer 1048576000
git clone --depth 1 --branch releases/plexil-4 https://git.code.sf.net/p/plexil/git /plexil

export PLEXIL_HOME=/plexil
source $PLEXIL_HOME/scripts/plexil-setup.sh

cd $PLEXIL_HOME
make src/configure
cd src
./configure CFLAGS="-g -O2" CXXFLAGS="-g -O2" --prefix=$PLEXIL_HOME --disable-static --disable-viewer --enable-ipc
cd $PLEXIL_HOME
make universalExec plexil-compiler checkpoint