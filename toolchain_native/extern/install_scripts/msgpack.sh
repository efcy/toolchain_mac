#!/bin/bash

# stop at the first error
set -e

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi

if [ "$1" = "check" ]; then
  if [ -d "$EXTERN_DIR/include/msgpack" ]; then
    echo "n"
    exit 0
  else
    echo "y" 
    exit 1
  fi
elif [ "$1" = "install" ]; then
  rm -Rf msgpack-3.1.1
  # v - add to make it verbouse
  tar xvzf ../downloads/msgpack-3.1.1.tar.gz
  cp -R msgpack-3.1.1/include/* $EXTERN_DIR/include/
fi

