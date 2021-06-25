#!/bin/sh
set -ex

VOLUME=$(printf "${DSTVOLUME:-${3:-/Volumes/Macintosh HD}}" | sed -E 's|/$||')

if [ -z "${VOLUME}" ]
then
    # sysadminctl -addUser user -password pass -admin
    dscl . -create /Users/user
    dscl . -create /Users/user GeneratedUID 00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF
    dscl . -create /Users/user NFSHomeDirectory /Users/user
    dscl . -create /Users/user PrimaryGroupID 20
    dscl . -create /Users/user RealName User
    dscl . -create /Users/user UniqueID 501
    dscl . -create /Users/user UserShell /bin/zsh
    dscl . -passwd /Users/user pass
    dscl . -append /Groups/admin GroupMembers 00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF
    dscl . -append /Groups/admin GroupMembership user
else
    DOMAIN="${VOLUME}/private/var/db/dslocal/nodes/Default/users/user"
    . ./user.sh

    DOMAIN="${VOLUME}/private/var/db/dslocal/nodes/Default/groups/admin"
    . ./admin.sh
fi

mkdir -p "${VOLUME}/private/etc/sudoers.d"
printf 'user\t\tALL = (ALL) NOPASSWD: ALL\n' > "${VOLUME}/private/etc/sudoers.d/user"

DOMAIN="${VOLUME}/Library/Preferences/com.apple.loginwindow"
. ./com.apple.loginwindow.sh

cp ./kcpassword "${VOLUME}/private/etc/kcpassword"

DOMAIN="${VOLUME}/System/Library/User Template/Non_localized/Library/Preferences/com.apple.SetupAssistant"
. ./com.apple.SetupAssistant.sh

# systemsetup -setremotelogin on
launchctl load -wF /System/Library/LaunchDaemons/ssh.plist

spctl --master-disable
spctl developer-mode enable-terminal

systemsetup -setsleep Never
systemsetup -setrestartfreeze off

touch "${VOLUME}/private/var/db/.AppleSetupDone"
