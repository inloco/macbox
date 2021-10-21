#!/bin/sh
set -ex

DOMAIN="${VOLUME}/System/Library/User Template/Non_localized/Library/Preferences/com.apple.SetupAssistant"
. ./SetupAssistant.sh

if [ -z "${VOLUME}" ]
then
    sysadminctl -addUser user -password pass -admin
    # dscl . -create /Users/user
    # dscl . -create /Users/user GeneratedUID 00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF
    # dscl . -create /Users/user NFSHomeDirectory /Users/user
    # dscl . -create /Users/user PrimaryGroupID 20
    # dscl . -create /Users/user RealName User
    # dscl . -create /Users/user UniqueID 501
    # dscl . -create /Users/user UserShell /bin/zsh
    # dscl . -passwd /Users/user pass
    # dscl . -append /Groups/admin GroupMembers 00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF
    # dscl . -append /Groups/admin GroupMembership user
else
    DOMAIN="${VOLUME}/private/var/db/dslocal/nodes/Default/users/user"
    . ./user.sh

    DOMAIN="${VOLUME}/private/var/db/dslocal/nodes/Default/groups/admin"
    . ./admin.sh
fi

DOMAIN="${VOLUME}/Library/Preferences/com.apple.loginwindow"
. ./loginwindow_root.sh

cp ./kcpassword "${VOLUME}/private/etc/kcpassword"

SUDOER="${VOLUME}/private/etc/sudoers.d/user"
mkdir -p "$(dirname ${SUDOER})"
printf 'user\t\tALL = (ALL) NOPASSWD: ALL\n' > "${SUDOER}"

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

touch "${VOLUME}/private/var/db/.AppleSetupDone"
