# Tools for building R

## ToDo

* Where is the devel source kept?
    - https://cran.r-project.org/src/base-prerelease/
* Add Makefile
* add options to buildr for the R release version to build - release, old-release, devel


## Steps for building a standalone version

1. run the `buildr` script

```
./buildr -a <version>
```

2. Install your new build

```
sudo ./buildr -i <version>
```

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

4. Apply R4Pi patches

5. Package

