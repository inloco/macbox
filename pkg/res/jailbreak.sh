#!/bin/sh
set -ex

spctl --master-disable
# systemextensionsctl developer on

"${VOLBASE}/usr/bin/sqlite3" "${VOLBASE}/private/var/db/SystemPolicyConfiguration/KextPolicy" << EOF
	CREATE TRIGGER IF NOT EXISTS INSERT_OF_allowed_ON_kext_policy AFTER INSERT ON kext_policy FOR EACH ROW WHEN NEW.allowed != 1
	BEGIN
		UPDATE kext_policy SET allowed = 1 WHERE team_id = NEW.team_id AND bundle_id = NEW.bundle_id;
	END;

	CREATE TRIGGER IF NOT EXISTS UPDATE_OF_allowed_ON_kext_policy AFTER UPDATE OF allowed ON kext_policy FOR EACH ROW WHEN NEW.allowed != 1
	BEGIN
		UPDATE kext_policy SET allowed = 1 WHERE team_id = NEW.team_id AND bundle_id = NEW.bundle_id;
	END;

	UPDATE kext_policy SET allowed = 1;

	CREATE TRIGGER IF NOT EXISTS INSERT_OF_flags_ON_kext_policy AFTER INSERT ON kext_policy FOR EACH ROW WHEN NEW.flags != 0
	BEGIN
		UPDATE kext_policy SET flags = 0 WHERE team_id = NEW.team_id AND bundle_id = NEW.bundle_id;
	END;

	CREATE TRIGGER IF NOT EXISTS UPDATE_OF_flags_ON_kext_policy AFTER UPDATE OF flags ON kext_policy FOR EACH ROW WHEN NEW.flags != 0
	BEGIN
		UPDATE kext_policy SET flags = 0 WHERE team_id = NEW.team_id AND bundle_id = NEW.bundle_id;
	END;

	UPDATE kext_policy SET flags = 0;

	CREATE TRIGGER IF NOT EXISTS INSERT_OF_flags_ON_kext_load_history_v3 AFTER INSERT ON kext_load_history_v3 FOR EACH ROW WHEN NEW.flags != 16
	BEGIN
		UPDATE kext_load_history_v3 SET flags = 16 WHERE path = NEW.path;
	END;

	CREATE TRIGGER IF NOT EXISTS UPDATE_OF_flags_ON_kext_load_history_v3 AFTER UPDATE OF flags ON kext_load_history_v3 FOR EACH ROW WHEN NEW.flags != 16
	BEGIN
		UPDATE kext_load_history_v3 SET flags = 16 WHERE path = NEW.path;
	END;
	
	UPDATE kext_load_history_v3 SET flags = 16;
EOF

TCC='/Library/Application Support/com.apple.TCC/TCC.db'
TCCVOL="${VOLBASE}${TCC}"
TCCTPL="${TPLBASE}${TCC}"

SERVICES=($(grep -aoE 'kTCCService\w+' "${VOLBASE}/System/Library/PrivateFrameworks/TCC.framework/Resources/tccd" | sed -E 's/^kTCCService//' | grep -v '^$' | sort | uniq))
CLIENTS0=('com.apple.CoreSimulator.SimulatorTrampoline' 'com.apple.dt.Xcode-Helper' 'com.apple.Terminal')
CLIENTS1=('/Library/Application Support/VMware Tools/vmware-tools-daemon' '/usr/libexec/sshd-keygen-wrapper')
OBJECTS0=('UNUSED' 'com.apple.finder' 'com.apple.systemevents')
OBJECTS1=()
{
	for SERVICE in "${SERVICES[@]}"
	do
		for CLIENT in "${CLIENTS0[@]}"
		do
			for OBJECT in "${OBJECTS0[@]}"
			do
				echo "INSERT INTO access VALUES ('kTCCService${SERVICE}','${CLIENT}',0,2,4,1,NULL,NULL,0,'${OBJECT}',NULL,0,0);"
			done
			for OBJECT in "${OBJECTS1[@]}"
			do
				echo "INSERT INTO access VALUES ('kTCCService${SERVICE}','${CLIENT}',0,2,4,1,NULL,NULL,1,'${OBJECT}',NULL,0,0);"
			done
		done
		for CLIENT in "${CLIENTS1[@]}"
		do
			for OBJECT in "${OBJECTS0[@]}"
			do
				echo "INSERT INTO access VALUES ('kTCCService${SERVICE}','${CLIENT}',1,2,4,1,NULL,NULL,0,'${OBJECT}',NULL,0,0);"
			done
			for OBJECT in "${OBJECTS1[@]}"
			do
				echo "INSERT INTO access VALUES ('kTCCService${SERVICE}','${CLIENT}',1,2,4,1,NULL,NULL,1,'${OBJECT}',NULL,0,0);"
			done
		done
	done
} | "${VOLBASE}/usr/bin/sqlite3" "${TCCVOL}"

mkdir -p "$(dirname "${TCCTPL}")"
"${VOLBASE}/usr/bin/sqlite3" "${TCCVOL}" '.dump' | "${VOLBASE}/usr/bin/sqlite3" "${TCCTPL}"
