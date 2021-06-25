#!/bin/sh
set -ex

VOLUME=$(printf "${DSTVOLUME:-${3:-/Volumes/Macintosh HD}}" | sed -E 's|/$||')

# for SERVICE in $(strings "${VOLUME}/System/Library/PrivateFrameworks/TCC.framework/Resources/tccd" | grep '^kTCCService[[:alnum:]]*$' | sed -E 's/^kTCCService//' | grep -v '^$' | sort)
# do
#     sqlite3 "${VOLUME}/Library/Application Support/com.apple.TCC/TCC.db" "INSERT INTO access VALUES ('kTCCService${SERVICE}','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0);"
# done
"${VOLUME}/usr/bin/sqlite3" "${VOLUME}/Library/Application Support/com.apple.TCC/TCC.db" << EOF
INSERT INTO access VALUES ('kTCCServiceAccessibility','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0);
INSERT INTO access VALUES ('kTCCServiceAppleEvents','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0);
INSERT INTO access VALUES ('kTCCServiceDeveloperTool','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0);
INSERT INTO access VALUES ('kTCCServiceSystemPolicyAllFiles','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0);
INSERT INTO access VALUES ('kTCCServiceSystemPolicySysAdminFiles','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0);
EOF

csrutil disable
csrutil authenticated-root disable

spctl kext-consent disable

sed -i '' -e 's/^root:\*/root:At666InBFXqls/g' /etc/master.passwd
mkdir -p /etc/dropbear
cp /Volumes/packer/dropbear /etc/dropbear
chmod +x /etc/dropbear/dropbear
/etc/dropbear/dropbear -RFEBp 2222
