#!/bin/bash

# stop at the first error
set -e

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi


if [ "$1" = "check" ]; then
  if [ -d "/usr/include/opencv2" -o -d "$EXTERN_DIR/include/opencv2" ]; then
    echo "n"
    exit 0
  else
    echo "y"
    exit 1
  fi
elif [ "$1" = "install" ]; then
  export CMAKE_LIBRARY_PATH="$EXTERN_DIR/lib"
  export CMAKE_INCLUDE_PATH="$EXTERN_DIR/include"
  
  rm -rf opencv-4.7.0
  unzip -qq -o ../downloads/opencv-4.7.0.zip
  cd opencv-4.7.0
  rm -Rf build
  mkdir build && cd build
  cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX="$EXTERN_DIR" -DCMAKE_INSTALL_LIBDIR="lib" -DBUILD_opencv_apps=OFF -DBUILD_DOCS=OFF -DBUILD_TESTS=OFF -DBUILD_JAVA=OFF \
  -DBUILD_opencv_python2=OFF -DBUILD_opencv_python3=OFF -DBUILD_PERF_TESTS=OFF -DENABLE_PRECOMPILED_HEADERS=OFF \
  -DBUILD_opencv_calib3d=ON -DBUILD_opencv_features2d=ON -DBUILD_opencv_flann=ON -DBUILD_opencv_highgui=OFF -DBUILD_opencv_gapi=OFF \
  -DBUILD_opencv_imgcodecs=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_shape=OFF \
  -DBUILD_opencv_stitching=OFF -DBUILD_opencv_superres=OFF -DBUILD_opencv_ts=OFF -DBUILD_opencv_videoio=OFF \
  -DBUILD_opencv_videostab=OFF -DBUILD_opencv_objdetect=ON \
  -DWITH_CUDA=OFF -DWITH_FFMPEG=OFF -DWITH_JPEG=OFF -DWITH_PNG=OFF -DWITH_OPENEXR=OFF -DWITH_TIFF=OFF -DWITH_VTK=OFF\
  -DWITH_JASPER=OFF -DWITH_WEBP=OFF -DWITH_IPP=OFF -DWITH_EIGEN=OFF ..
  make && make install

  cd ../../../

  # the code will create the includes in include/opencv4/opencv2 we have to move the opencv2 folder to include/
  rm -rf include/opencv2/
  mv include/opencv4/* include/
  rm -rf include/opencv4
fi