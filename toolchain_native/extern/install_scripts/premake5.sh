#!/bin/bash

# stop at the first error
set -e

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi

if [ "$1" = "check" ]; then
  if [ -f "$EXTERN_DIR/bin/premake5" ]; then
    echo "n"
    exit 0
  else
    echo "y" 
    exit 1
  fi
elif [ "$1" = "install" ]; then
  rm -Rf premake-5.0.0-beta5-src
  unzip ../downloads/premake-5.0.0-beta5-src.zip
  cd premake-5.0.0-beta5-src/
  make -f Bootstrap.mak linux
  cp bin/release/premake5 $EXTERN_DIR/bin
  cd ../ 
  pwd
fi
