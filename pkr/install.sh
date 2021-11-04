#!/bin/sh
set -ex

function pidof {
	ps -ce | awk '$4 == "'"${1}"'" { print $1 }' | paste -sd ' ' -
}

{
	trap $'kill -s USR1 $(pidof startosinstall)' SIGUSR1

	set +x

	while true
	do
		sleep 1
	done
} &
SIGPID="${!}"

VOLNAME='Macintosh HD'
DIRNAME="$(echo -n "${BASH_SOURCE[0]}" | sed -E 's|^([^/]+)$|./\1|' | sed -E 's|^(.*)/([^/]+)$|\1|')"

for PKG in "${DIRNAME}/MacBox.pkg" '/Volumes/VMware Tools/Install VMware Tools.app/Contents/Resources/VMware Tools.pkg'
do
	ARGS+=('--installpackage' "${PKG}")
done

diskutil eraseDisk APFS "${VOLNAME}" disk0

/System/Installation/CDIS/Installation\ Log.app/Contents/MacOS/Installation\ Log &
/Volumes/Image\ Volume/Install\ macOS\ *.app/Contents/Resources/startosinstall --agreetolicense --pidtosignal "${SIGPID}" --rebootdelay '300' --volume "/Volumes/${VOLNAME}" "${ARGS[@]}"

kill -s KILL "${SIGPID}"

nvram boot-args='serverperfmode=1 -v'
nvram -d platform-uuid

spctl kext-consent add EG7KH642X6
spctl kext-consent disable

csrutil authenticated-root disable
csrutil disable

reboot
