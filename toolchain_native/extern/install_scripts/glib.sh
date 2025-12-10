#!/bin/bash

# stop at the first error
set -e

if [ "$EXTERN_DIR" == "" ]; then
  echo ".::ERROR::. enviroment variable EXTERN_DIR was not set"
  echo ".::ERROR::. will exit"
  exit -1
fi

if [ "$1" = "check" ]; then
  if [ -d "/usr/include/glib-2.0/" -o -d "$EXTERN_DIR/include/glib-2.0" ]; then
    echo "n"
    exit 0
  else
    echo "y" 
    exit 1
  fi
elif [ "$1" = "install" ]; then
  rm -Rf glib-2.26.0
  tar xvzf ../downloads/glib-2.26.0.tar.gz
  cd glib-2.26.0/

  # patch glib2 so that the macros `major' and `minor' are defined if newer glibc versions are used to compile this version of glib2
  # gio/gdbusmessage.c requires two macros `major' and `minor'. These macros are defined in sys/sysmacros.h of glibc.
  # In glib-2.26 it is assumed that sys/sysmacros.h is indirectly included thru including sys/types.h into gio/gdbusmessage.c.
  # Beginning with glibc 2.25 indirect inclusion is deprecated and is only done if the macro __USE_MISC is defined.
  # Since glibc 2.28 sys/sysmacros.h can't be indirectly included thru sys/types.h anymore.
  # So to be able to compile glib-2.26 on modern linux systems gio/gdbusmessage.c need to include sys/sysmacros.h directly.
  patch -u gio/gdbusmessage.c ../../install_scripts/glib2.patch
  CFLAGS="-std=gnu11" ./configure --prefix="$EXTERN_DIR" --enable-dtrace=no --build=aarch64-unknown-linux-gnu
  make -j4 
  make
  make install
  cd ..  
fi

