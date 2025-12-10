# path to toolchain has to be defined!
if [[ ! -z "${NAOTH_TOOLCHAIN_PATH}" ]]; then
	export PATH=${PATH}:${NAOTH_TOOLCHAIN_PATH}/toolchain_native/extern/bin:${NAOTH_TOOLCHAIN_PATH}/toolchain_native/extern/lib # NAOTH
	export NAO_CTC=${NAOTH_TOOLCHAIN_PATH}/toolchain_nao_ubuntu # NAOTH
	export EXTERN_PATH_NATIVE=${NAOTH_TOOLCHAIN_PATH}/toolchain_native/extern # NAOTH
fi