#!/bin/bash

program=cdrtools
version=3.02a09-pled-1.0
arch=$(uname -p)
release=$program-v$version-$arch

set -e
cd "$(dirname "$0")"
rm -rf \
build-tmp \
$release \
$release.zip

# Just clean built binaries/releases from source and exit now if given the argument 'clean'.
if [ "$1" == "clean" ]; then
    exit 0
fi

mkdir -p \
build-tmp \
$release/licenses
cp -r $program build-tmp
# Can't use -j`nproc`, causes issuess.
make GMAKE_NOWARN=true -C build-tmp/cdrtools
pled/pled build-tmp/cdrtools/cdrecord/OBJ/*/cdrecord $release/
pled/pled build-tmp/cdrtools/mkisofs/OBJ/*/mkisofs $release/
# Copy licenses to release.
cp -r \
$program/GPL-2.0.txt \
$program/CDDL.Schily.txt \
$program/COPYING \
$release/licenses
cp readme.md $release/
rm -rf build-tmp
chmod -R 777 $release
zip -r $release.zip $release
