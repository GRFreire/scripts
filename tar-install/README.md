# tar-install

## About
Easily install binary tarballs in your home directory without messing with native packages.

> DO NOT USE AS A PACKAGE MANAGER REPLACEMENT

### Use cases:
 - Testing out binaries without commitment
 - Installing software just for your user
 - Installing local libs
 - Using releases not yet distributed by your package manager
 - etc

## How to use it

### Preparing the environment

1. Create a folder in your home dir called `.opt`
2. Add to your path `$HOME/.opt/bin/`
3. That's it! Start installing packages

### Installing
From `tar-install -h`:
```
Usage: tar-install [OPTION] FILE
  tar-install file.tar                      Install the tar program in $HOME/.opt
  tar-install -u, --uninstall file.tar      Uninstall the tar file already installed

ATENTION: BE SURE THAT YOUR TARBALL HAS THE FOLLOWING FORMAT:
  /program_name
      /bin
          program
      /lib
          ...
      /share
          ... 
```


