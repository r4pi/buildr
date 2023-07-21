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

This breaks a ton of the build process so it's important to force the use of
the 32 bit kernel to ensure successful builds.

Add the following to `/boot/config.txt`:

```
# Fix to prevent loading the (now default) 64 bit kernel
arm_64bit=0
```

and then reboot.

