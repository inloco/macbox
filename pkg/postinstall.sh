#!/bin/sh
set -ex

VOLBASE="$(printf "${DSTVOLUME:-${3:-/Volumes/Macintosh HD}}" | sed -E 's|/$||')"
TPLBASE="${VOLBASE}/System/Library/User Template/Non_localized"

PEDPLIST="$(mktemp -d)/IOPlatformExpertDevice.plist"
ioreg -a -c IOPlatformExpertDevice -d 2 > "${PEDPLIST}"

HOSTUUID="$("${VOLBASE}/usr/libexec/PlistBuddy" -c 'Print :IORegistryEntryChildren:0:IOPlatformUUID' "${PEDPLIST}")"

. ./jailbreak.sh
. ./setup.sh
