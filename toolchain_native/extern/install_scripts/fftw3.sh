#!/bin/bash

# stop at the first error
set -e

FFTW_INCLUDE_DIR='include/fftw3'

# current path is toolchain_native/extern/extracted

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi

if [ "$1" = "check" ]; then
  if [ -f "/usr/include/fftw3.h" -o -f "$EXTERN_DIR/$FFTW_INCLUDE_DIR/fftw3.h" ]; then
    echo "n"
    exit 0
  else
    echo "y" 
    exit 1
  fi
elif [ "$1" = "install" ]; then
  rm -Rf fftw-3.3.5
  tar xvzf ../downloads/fftw-3.3.5.tar.gz
  cd fftw-3.3.5
  ./configure --enable-shared --prefix="$EXTERN_DIR" --includedir="\$(prefix)/$FFTW_INCLUDE_DIR" && make && make install
  cd ..
fi
