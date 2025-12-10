#!/bin/bash

# stop at the first error

export EXTERN_DIR="$PWD"


PACKAGESTOINSTALL=""


ask_install_package()
{
  # test if installed and choose default answer based on this
  DEFAULT=`../install_scripts/$1.sh check`
  if [ -z "$DEFAULT" ]; then DEFAULT="y" ; fi
  DEFSTRING="[Y/n]"
  if [ "$DEFAULT" = "n" ]; then 
    DEFSTRING="[y/N]"
  fi

  echo -n "Do you want to compile and install \"$1\" to extern/ ? $DEFSTRING : "
  read ANSWER

  # set default answer
  if [ -z "$ANSWER" ]; then 
    ANSWER=$DEFAULT
  fi

  if [ "$ANSWER" = "y" -o "$ANSWER" = "Y" ]
  then
    PACKAGESTOINSTALL="$PACKAGESTOINSTALL $1"
  fi
}

# create target directories for installation
mkdir -p "./include/sfsexp"
mkdir -p "./lib"
mkdir -p "./bin"

# create extracted dir and step into it
mkdir -p extracted
cd extracted

# iterate through install scripts
for scripts in ../install_scripts/*.sh; do
  # get the script/file name
  file_name=$(basename -s ".sh" $scripts)
  # ignore files starting with underscore
  if [[ $file_name == _* ]]; then
    continue
  fi
  ask_install_package "$file_name"
done

echo "==========================="

if [[ -z "$PACKAGESTOINSTALL" ]]; then
  echo "Nothing to install"
else
  echo "Selected packages for install:"
  for PKG in $PACKAGESTOINSTALL
  do
     echo "* $PKG"
  done

  echo -n "Proceed? [Y/n]: "
  read ANSWER

  if [ "$ANSWER" != "n" ]; then
    CWD=$(pwd) # remember the current working directory
    # actually install the packages
    for PKG in $PACKAGESTOINSTALL
    do
      echo "==========================="  
      echo "Installing \"$PKG\""
      echo "==========================="
      . ../install_scripts/$PKG.sh install

      if [ $? -ne 0 ]; then
        echo "================================"
        echo "Installation of \"$PKG\" failed "
        echo "================================"
        exit 1
      fi

      cd $CWD # make sure, the script didn't change the directory
    done
  fi
fi

# get out of the extracted directory
cd ..
