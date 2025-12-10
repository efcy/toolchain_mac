#!/bin/bash

# stop at the first error
set -e

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi


if [ "$1" = "check" ]; then
  if [ -d "$EXTERN_DIR/include/tensorflow/" ]; then  # TODO change this maybe?
    echo "n"
    exit 0
  else
    echo "y"
    exit 1
  fi
elif [ "$1" = "install" ]; then
  export CMAKE_LIBRARY_PATH="$EXTERN_DIR/lib"
  export CMAKE_INCLUDE_PATH="$EXTERN_DIR/include"
  
  unzip -qq -o ../downloads/tflite-2.15.0.zip
  rm -Rf tf_build
  mkdir -p tf_build && cd tf_build
  
  cmake -DCMAKE_BUILD_TYPE=RELEASE ../tensorflow-2.15.0/tensorflow/lite/c
  cmake --build . --config Release
  
  # Note install does not work for some weird reason with the flag -DTFLITE_ENABLE_INSTALL=ON , so we copy everything manually
  # copy the binary from tf_build to the extern/lib folder
  cp libtensorflowlite_c.* ../../lib/

  # TODO copy the tflite includes
  mkdir -p ../../include/tensorflow/lite/
  mkdir -p ../../include/tensorflow/lite/core/
  
  # copy all header files from tensorflow/lite dir
  # inspired by https://stackoverflow.com/questions/9622883/recursive-copy-of-a-specific-file-type-maintaining-the-file-structure-in-unix-li/9626253#9626253
  rsync -am --include='*.h' -f 'hide,! */' ../tensorflow-2.15.0/tensorflow/lite/ ../../include/tensorflow/lite

  # go back to the toolchain-native folder 
  cd ../../../

  # cleanup
  rm -rf extern/extracted/tf_build
  rm -rf extern/extracted/tensorflow-2.15.0
  echo ""
fi