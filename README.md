# Tools for building R


## Steps for building a release version

1. Remove `/opt/R/release`

```
sudo rm -rf /opt/R/release
```

2. run the `buildr` script

```
./buildrelase -a <version>
```

3. Install your new build

```
sudo ./buildrelase -i <version>
```

4. As root, copy the install tree into the src-release directory

5. Apply R4Pi patches

6. Package



## Steps for building a standalone version

1. run the `buildr` script

```
./buildr -a <version>
```

2. Install your new build

```
sudo ./buildr -i <version>
```


## IMPORTANT NOTE FOR 32BIT RASBIAN

As of some time around May 2023 32bit Rasbian started using a 64bit kernel.

This means `uname -m` and `arch` return 'aarch64' instead of 'armv7l'.

You can check which version of the OS you're using with:

```
getconf LONG_BIT
```

This change breaks a ton of the build process so it's important to force the use of
the 32 bit kernel to ensure successful builds.

Add the following to `/boot/config.txt`:

```
# Fix to prevent loading the (now default) 64 bit kernel
arm_64bit=0
```

and then reboot.


## Installing fpm

The project uses fpm to package the build for release.

Building fpm for debian bullseye requires a very specific set of packages so 
there's an install script in `install_fpm.sh`.

