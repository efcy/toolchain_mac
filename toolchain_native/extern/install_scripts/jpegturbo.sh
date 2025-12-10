#!/bin/bash

# stop at the first error
set -e

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi

if [ "$1" = "check" ]; then
  # don't check global install since we have to be sure to have the same version of protobuf on
  # our computer as the one on the Nao
  if [ -d "$EXTERN_DIR/include/libjpeg-turbo/" ]; then
    echo "n"
    exit 0
  else
    echo "y" 
    exit 1
  fi
elif [ "$1" = "install" ]; then
  # remove the old stuff
  rm -Rf libjpeg-turbo-2.0.3
  # extract the new stuff
  tar xvzf ../downloads/libjpeg-turbo-2.0.3.tar.gz
  # prepare build
  cd libjpeg-turbo-2.0.3
  mkdir build && cd build
  # check for yasm/nasm compiler
  WITH_SIMD="on" && (! type "nasm" &> /dev/null && ! type "yasm" &> /dev/null) && WITH_SIMD="off"
  # build ...
  cmake -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$EXTERN_DIR -DCMAKE_INSTALL_LIBDIR="$EXTERN_DIR/lib" -DCMAKE_INSTALL_INCLUDEDIR="$EXTERN_DIR/include/libjpeg-turbo" -DWITH_SIMD=$WITH_SIMD .. && make && make install
  # finish
  cd ..  
fi
