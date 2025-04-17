# Packaging an R release

Step 1 - remove any existing package artefacts

```
sudo rm -r ./src-release/opt/R/release
```

Step 2 - Copy in the new build

```
sudo cp -r /opt/R/release ./src/opt/R/release
```

Step 3 - Copy in any patches

```
sudo cp ../r-patches/Rprofile.site.<OS> ./src-release/opt/R/release/lib/R/etc/Rprofile.site
```

Step 4 - Run the appropriate packaging script

```
./package-release-<OS>.sh <R_VERSION> <BUILD_ITERATION>
```

Step 5 - copy built artefacts to the repo host

```
scp /tmp/output/raspbian-bookworm/r-release_4.5.0-1_arm64.deb buildberry32:/tmp/output/raspbian-bookworm/r-release_4.5.0-1_arm64.deb
```

Step 6 - Switch to the publishing machine and go through the publishing flow.

