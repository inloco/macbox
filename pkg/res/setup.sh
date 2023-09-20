#!/bin/sh
set -ex

DOMAIN="${TPLBASE}/Library/Preferences/ByHost/com.apple.screensaver.${HOSTUUID}"
. ./screensaver_host.sh

DOMAIN="${TPLBASE}/Library/Preferences/com.apple.SetupAssistant"
. ./SetupAssistant.sh

if [ -z "${VOLBASE}" ]
then
	sysadminctl -addUser runner -fullName Runner -UID 501 -password runner -admin
	# dscl . -create /Users/runner
	# dscl . -create /Users/runner GeneratedUID 00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF
	# dscl . -create /Users/runner NFSHomeDirectory /Users/runner
	# dscl . -create /Users/runner PrimaryGroupID 20
	# dscl . -create /Users/runner RealName Runner
	# dscl . -create /Users/runner UniqueID 501
	# dscl . -create /Users/runner UserShell /bin/zsh
	# dscl . -passwd /Users/runner runner
	# dscl . -append /Groups/admin GroupMembers 00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF
	# dscl . -append /Groups/admin GroupMembership runner
else
	DOMAIN="${VOLBASE}/private/var/db/dslocal/nodes/Default/users/runner"
	. ./user.sh

	DOMAIN="${VOLBASE}/private/var/db/dslocal/nodes/Default/groups/admin"
	. ./group.sh
fi

DOMAIN="${VOLBASE}/Library/Preferences/com.apple.commerce"
. ./commerce.sh

DOMAIN="${VOLBASE}/Library/Preferences/com.apple.SoftwareUpdate"
. ./SoftwareUpdate.sh

DOMAIN="${VOLBASE}/Library/Preferences/com.apple.screensaver"
. ./screensaver_root.sh

DOMAIN="${VOLBASE}/Library/Preferences/com.apple.loginwindow"
. ./loginwindow_root.sh

cp ./kcpassword "${VOLBASE}/private/etc/kcpassword"

SUDOER="${VOLBASE}/private/etc/sudoers.d/runner"
mkdir -p "$(dirname "${SUDOER}")"
printf 'runner\t\tALL = (ALL) NOPASSWD: ALL\n' > "${SUDOER}"

PATHS="${VOLBASE}/private/etc/paths"
sed -Ei '' 's|(/usr/bin)|/usr/local/bin\n\1|g' "${PATHS}"
sed -Ei '' 's|(/usr/sbin)|/usr/local/sbin\n\1|g' "${PATHS}"
uniq "${PATHS}" "${PATHS}.uniq"
mv "${PATHS}.uniq" "${PATHS}"

systemsetup -setsleep Never
systemsetup -setrestartfreeze off

DOMAIN="${HOME}/Library/Preferences/com.apple.loginwindow"
. ./loginwindow_home.sh

LOGINHOOK="$(defaults read ${DOMAIN} LoginHook)"
mkdir -p "$(dirname "${LOGINHOOK}")"
cp -f ./loginhook.sh "${LOGINHOOK}"

LOGOUTHOOK="$(defaults read ${DOMAIN} LogoutHook)"
mkdir -p "$(dirname "${LOGOUTHOOK}")"
cp -f ./logouthook.sh "${LOGOUTHOOK}"

HOMEBIN="${HOME}/.local/bin"
mkdir -p "${HOMEBIN}"

POWEROFF="${HOMEBIN}/poweroff"
cp -f ./poweroff.applescript "${POWEROFF}"

SSHENVIRONMENTPATHHELPER="${HOMEBIN}/ssh-environment-path-helper"
cp -f ./ssh-environment-path-helper.sh "${SSHENVIRONMENTPATHHELPER}"

DOMAIN="${VOLBASE}/Library/LaunchDaemons/com.incognia.macbox.ssh-environment"
. ./ssh-environment.sh

ETCSSH="${VOLBASE}/private/etc/ssh"

SSHDCONF="${ETCSSH}/sshd_config"
sed -Ei '' 's/#(PermitUserEnvironment) .+/\1 yes/g' "${SSHDCONF}"

ENVIRONMENT_ROOT="${ETCSSH}/ssh_environment"
mkfifo "${ENVIRONMENT_ROOT}"

DOTSSH="$(eval echo ~$(id -un 501))/.ssh"
mkdir -p "${DOTSSH}"
chown 501:20 "${DOTSSH}"
chmod 700 "${DOTSSH}"

ENVIRONMENT_HOME="${DOTSSH}/environment"
ln -s "${ENVIRONMENT_ROOT}" "${ENVIRONMENT_HOME}"

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

touch "${VOLBASE}/private/var/db/.AppleSetupDone"
