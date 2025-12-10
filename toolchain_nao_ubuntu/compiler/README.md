# Cross Compilation Tool Chain for Ubuntu 20.04

## Clang Compiler

Clang makes it possible to compile for other platforms by providing it with necessary headers and libs from the terget system. We need files for the GCC-Toolchain and files for the System itself.

We have following ways to control how clang searches for files:
* `--isystem=` manually set all necessary include paths'
* `--sysroot=` set the system root - if the directly structure is correct, then clang will find all necessary includes, libs and the GCC-Toolchain automanically
* `--gcc-toolchain=` point to a separate directory for GCC-Toolchain to make sure it's the one to be used.

### System Include Paths for clang

To see the list of default include paths' used by clang we can 'compile' some empty input with verbouse flag `-v` and run the preprocessor with `-E`
```sh
clang++ -v -E - </dev/null 2>&1
```

The paths for `clang 10.0.0` are

```sh
# local libraries 
/usr/local/include

# clang ressource libraries
/usr/lib/llvm-10/lib/clang/10.0.0/include

# system libraries
/usr/include/x86_64-linux-gnu
/usr/include
```

Path of the clang ressource libraries can also be retrieved with
```sh
clang++ --print-resource-dir
```


## Creating Sysroot

We want to create a minimal sysroot for Ubuntu 20.04. The easiest way to do that is to copy necessary files from an existing Ubuntu 20.04 system.

### Preparing the System - Ubuntu 20.04

* We start with the Server install image. It's a minimal image without unnecessary libraries.
  https://releases.ubuntu.com/20.04/
* Install the Image in VirtualBox
* Install all necessary libraries. We need especially
  ```sh
  # c++ compile
  sudo apt install build-essential cmake 
  # c++ essential libs
  sudo apt install zlib1g-dev libreadline-dev
  # sound library
  sudo apt-get install libpulse-dev
  ```

### Copying Files

**NOTE:** when copying the files we want to preserve their paths relative to the new sysroot directory. E.g., a file `/usr/lib/blub.so` is copied to `./mysysroot/usr/lib/blub.so`.

* Create a directory for our sysroot
  ```sh
  mkdir sysroot-ubuntu20.04
  ```
* Copy include directory
  ```sh
  cp -r --parents /usr/include ./sysroot-ubuntu20.04/
  ```
* Copy GCC-Toolchain Files
  ```sh
  /usr/lib/gcc/x86_64-linux-gnu/9
  ```
  * [ ] **TODO** which files are copied?
* Copy System Libraries  
  **NOTE:** clang takes the system libraries from `/lib -> /usr/lib` which is a symbolic link to `/usr/lib` 
  ```sh
  /lib/x86_64-linux-gnu
  ```
  * [ ] **TODO** which files are copied?


## Explanations


### C runtime startup
https://stackoverflow.com/questions/16436035/whats-the-usage-of-mcrt1-o-and-scrt1-o

Files of the form *crt*.o are invariably C runtime startup code (the bulk of the C runtime tends to exist in libraries, the startup code is an object file as it's always needed).

```
Mini FAQ about the misc libc/gcc crt files.

Some definitions:
  PIC - position independent code (-fPIC)
  PIE - position independent executable (-fPIE -pie)
  crt - C runtime
```

Then the various startup object files:

```
crt0.o
  Older style of the initial runtime code ?  Usually not generated anymore
  with Linux toolchains, but often found in bare metal toolchains.  Serves
  same purpose as crt1.o (see below).
crt1.o
  Newer style of the initial runtime code.  Contains the _start symbol which
  sets up the env with argc/argv/libc _init/libc _fini before jumping to the
  libc main.  glibc calls this file 'start.S'.
crti.o
  Defines the function prolog; _init in the .init section and _fini in the
  .fini section.  glibc calls this 'initfini.c'.
crtn.o
  Defines the function epilog.  glibc calls this 'initfini.c'.
Scrt1.o
  Used in place of crt1.o when generating PIEs.
gcrt1.o
  Used in place of crt1.o when generating code with profiling information.
  Compile with -pg.  Produces output suitable for the gprof util.
Mcrt1.o
  Like gcrt1.o, but is used with the prof utility.  glibc installs this as
  a dummy file as it's useless on linux systems.
```

And some others:

```
crtbegin.o
  GCC uses this to find the start of the constructors.
crtbeginS.o
  Used in place of crtbegin.o when generating shared objects/PIEs.
crtbeginT.o
  Used in place of crtbegin.o when generating static executables.
crtend.o
  GCC uses this to find the start of the destructors.
crtendS.o
  Used in place of crtend.o when generating shared objects/PIEs.
```

Finally, common linking order:

```
General linking order:
  crt1.o crti.o crtbegin.o [-L paths] [user objects] [gcc libs]
    [C libs] [gcc libs] crtend.o crtn.o
```

