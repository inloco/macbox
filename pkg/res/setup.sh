#!/bin/sh
set -ex

PEDPLIST="$(mktemp -d)/IOPlatformExpertDevice.plist"
ioreg -a -c IOPlatformExpertDevice -d 2 > "${PEDPLIST}"

HOSTUUID="$(/usr/libexec/PlistBuddy -c 'Print :IORegistryEntryChildren:0:IOPlatformUUID' "${PEDPLIST}")"

DOMAIN="${VOLUME}/System/Library/User Template/Non_localized/Library/Preferences/ByHost/com.apple.screensaver.${HOSTUUID}"
. ./screensaver_host.sh

DOMAIN="${VOLUME}/System/Library/User Template/Non_localized/Library/Preferences/com.apple.SetupAssistant"
. ./SetupAssistant.sh

if [ -z "${VOLUME}" ]
then
    sysadminctl -addUser vagrant -fullName Vagrant -UID 501 -password vagrant -admin
    # dscl . -create /Users/vagrant
    # dscl . -create /Users/vagrant GeneratedUID 00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF
    # dscl . -create /Users/vagrant NFSHomeDirectory /Users/vagrant
    # dscl . -create /Users/vagrant PrimaryGroupID 20
    # dscl . -create /Users/vagrant RealName Vagrant
    # dscl . -create /Users/vagrant UniqueID 501
    # dscl . -create /Users/vagrant UserShell /bin/zsh
    # dscl . -passwd /Users/vagrant vagrant
    # dscl . -append /Groups/admin GroupMembers 00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF
    # dscl . -append /Groups/admin GroupMembership vagrant
else
    DOMAIN="${VOLUME}/private/var/db/dslocal/nodes/Default/users/vagrant"
    . ./user.sh

    DOMAIN="${VOLUME}/private/var/db/dslocal/nodes/Default/groups/admin"
    . ./group.sh
fi

DOMAIN="${VOLUME}/Library/Preferences/com.apple.screensaver"
. ./screensaver_root.sh

DOMAIN="${VOLUME}/Library/Preferences/com.apple.loginwindow"
. ./loginwindow_root.sh

cp ./kcpassword "${VOLUME}/private/etc/kcpassword"

SUDOER="${VOLUME}/private/etc/sudoers.d/vagrant"
mkdir -p "$(dirname ${SUDOER})"
printf 'vagrant\t\tALL = (ALL) NOPASSWD: ALL\n' > "${SUDOER}"

systemsetup -setsleep Never
systemsetup -setrestartfreeze off

DOMAIN="${HOME}/Library/Preferences/com.apple.loginwindow"
. ./loginwindow_home.sh

LOGINHOOK="$(defaults read ${DOMAIN} LoginHook)"
mkdir -p "$(dirname ${LOGINHOOK})"
cp -f ./loginhook.sh "${LOGINHOOK}"

LOGOUTHOOK="$(defaults read ${DOMAIN} LogoutHook)"
mkdir -p "$(dirname ${LOGOUTHOOK})"
cp -f ./logouthook.sh "${LOGOUTHOOK}"

POWEROFF="${HOME}/.local/bin/poweroff"
mkdir -p "$(dirname ${POWEROFF})"
cp -f ./poweroff.applescript "${POWEROFF}"

DOTSSH="$(eval echo ~$(id -un 501))/.ssh"
mkdir -p "${DOTSSH}"
chown 501:20 "${DOTSSH}"
chmod 700 "${DOTSSH}"

AUTHZEDKEYS="${DOTSSH}/authorized_keys"
cp -f ./authorized_keys "${AUTHZEDKEYS}"
chown 501:20 "${AUTHZEDKEYS}"
chmod 600 "${AUTHZEDKEYS}"

IDRSA="${DOTSSH}/id_rsa"
cp -f ./id_rsa "${IDRSA}"
chown 501:20 "${IDRSA}"
chmod 600 "${IDRSA}"

IDRSAPUB="${IDRSA}.pub"
cp -f ./id_rsa "${IDRSAPUB}"
chown 501:20 "${IDRSAPUB}"
chmod 644 "${IDRSAPUB}"

touch "${VOLUME}/private/var/db/.AppleSetupDone"
