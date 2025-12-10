#!/bin/bash

# stop at the first error
set -e

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi

if [ "$1" = "check" ]; then
  if [ -d "$EXTERN_DIR/include/lua" ]; then
    echo "n"
    exit 0
  else
    echo "y" 
    exit 1
  fi
elif [ "$1" = "install" ]; then
 
  tar xvzf ../downloads/lua-5.3.4.tar.gz
  cp -R ../downloads/luabridge $EXTERN_DIR/include/luabridge
  cd lua-5.3.4
  make clean
  make linux

  mkdir -p $EXTERN_DIR/include/lua
  cp src/liblua.a $EXTERN_DIR/lib/liblua53.a
  cp src/*.h $EXTERN_DIR/include/lua
  cd ../../
fi