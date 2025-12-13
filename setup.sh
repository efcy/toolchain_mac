#!/bin/bash

if [ -z "$DEFAULT" ]; then DEFAULT="n" ; fi
DEFSTRING="[Y/n]"
if [ "$DEFAULT" = "n" ]; then 
  DEFSTRING="[y/N]"
fi

PROFILE_NAOTH_TOOLCHAIN_STRING="export NAOTH_TOOLCHAIN_PATH=$(pwd)"
PROFILE_NAOTH_TOOLCHAIN_CURRENT=$(cat ~/.profile | grep "export NAOTH_TOOLCHAIN_PATH=")

# prevent multiple env_var definitions
if [[ -z "${NAOTH_TOOLCHAIN_PATH}" ]]; then

    NAOTH_TOOLCHAIN_PATH=`pwd`

	echo -n "Do you want append NaoTH environment variables to ~/.profile and ~/.bashrc? $DEFSTRING : "
	read ANSWER

	# set default answer
	if [ -z "$ANSWER" ]; then 
	  ANSWER=$DEFAULT
	fi

	if [ "$ANSWER" = "y" -o "$ANSWER" = "Y" ]
	then
	  echo "--------------------------------------"
	  echo "- extending ~/.profile and ~/.bashrc -"
	  echo "--------------------------------------"

	  # force new line
	  echo  >> ~/.profile
	  echo  >> ~/.bashrc
	  #
	  echo "# NAOTH Toolchain" >> ~/.profile
	  echo "# NAOTH Toolchain" >> ~/.bashrc
	  echo "$PROFILE_NAOTH_TOOLCHAIN_STRING" >> ~/.profile
	  echo "$PROFILE_NAOTH_TOOLCHAIN_STRING" >> ~/.bashrc
	  echo "[[ -f $NAOTH_TOOLCHAIN_PATH/.naoth.profile ]] && . $NAOTH_TOOLCHAIN_PATH/.naoth.profile" >> ~/.profile
	  echo "[[ -f $NAOTH_TOOLCHAIN_PATH/.naoth.profile ]] && . $NAOTH_TOOLCHAIN_PATH/.naoth.profile" >> ~/.bashrc
	fi
elif [[ "$PROFILE_NAOTH_TOOLCHAIN_STRING" != "$PROFILE_NAOTH_TOOLCHAIN_CURRENT" ]]; then

	echo -e -n "NaoTH toolchain path in the ~/.profile is different to this path!\nDo you want to replace it? $DEFSTRING : "
	read ANSWER

	# set default answer
	if [ -z "$ANSWER" ]; then 
	  ANSWER=$DEFAULT
	fi

	if [ "$ANSWER" = "y" -o "$ANSWER" = "Y" ]
	then
		# replace toolchain path and using | as sed delimiter
		sed -i "s|$PROFILE_NAOTH_TOOLCHAIN_CURRENT|$PROFILE_NAOTH_TOOLCHAIN_STRING|g" "~/.profile"
		sed -i "s|$PROFILE_NAOTH_TOOLCHAIN_CURRENT|$PROFILE_NAOTH_TOOLCHAIN_STRING|g" "~/.bashrc"
	fi
else
  echo "NaoTH environment variables already defined."
fi

# load (new) profile
. ~/.profile

echo "-----------------------------------"
echo "- compiling external dependencies -"
echo "-----------------------------------"

cd toolchain_native/extern/
# make executeable
chmod u+x install_linux.sh
./install_linux.sh

if [ $? -ne 0 ]; then
	echo "---------------------------------------------------"
	echo "- ./install_linux.sh did not finish successfully! -"
	echo "---------------------------------------------------"
	exit 1
fi

echo "-------------------------------------------------------------------------------------------"
echo "- If paths were appended to .profile a restart is needed in order for the changes to work -"
echo "-------------------------------------------------------------------------------------------"
