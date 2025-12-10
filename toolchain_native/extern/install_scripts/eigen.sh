#!/bin/bash

# stop at the first error
set -e

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi

if [ "$1" = "check" ]; then
  if [ -d "$EXTERN_DIR/include/Eigen" ]; then
    echo "n"
    exit 0
  else
    echo "y" 
    exit 1
  fi
elif [ "$1" = "install" ]; then
  mkdir -p $EXTERN_DIR/include/Eigen/
  rm -Rf eigen-eigen-5a0156e40feb
  tar xvjf ../downloads/eigen-eigen-5a0156e40feb.tar.bz2
  cp -R eigen-eigen-5a0156e40feb/Eigen/* $EXTERN_DIR/include/Eigen/
fi

