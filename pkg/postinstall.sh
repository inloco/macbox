#!/bin/sh
set -ex

VOLUME="$(printf "${DSTVOLUME:-${3:-/Volumes/Macintosh HD}}" | sed -E 's|/$||')"

. ./setup.sh
. ./jailbreak.sh
