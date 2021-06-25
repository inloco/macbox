#!/bin/sh
set -ex

VOLNAME='Macintosh HD'
DIRNAME="$(echo -n ${BASH_SOURCE[0]} | sed -E 's|^([^/]+)$|./\1|' | sed -E 's|^(.*)/([^/]+)$|\1|')"

for PKG in "${DIRNAME}/MacBox.pkg" /Volumes/VBox_GAs_*/VBoxDarwinAdditions.pkg /Volumes/VMware*/Install*.app/Contents/Resources/VMware*.pkg
do
    if [ -f "${PKG}" ]
    then
        ARGS+=('--installpackage' "${PKG}")
    fi
done

diskutil eraseDisk APFS "${VOLNAME}" disk0
/Volumes/Image*/Install*.app/Contents/Resources/startosinstall --agreetolicense --volume "/Volumes/${VOLNAME}" "${ARGS[@]}"
