#!/bin/sh
set -ex

spctl --master-disable
spctl developer-mode enable-terminal

# systemextensionsctl developer on

"${VOLUME}/usr/bin/sqlite3" "${VOLUME}/private/var/db/SystemPolicyConfiguration/KextPolicy" << EOF
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

{
    for SERVICE in $(grep -aoE 'kTCCService\w+' "${VOLUME}/System/Library/PrivateFrameworks/TCC.framework/Resources/tccd" | sed -E 's/^kTCCService//' | grep -v '^$' | sort | uniq)
    do
        echo "INSERT INTO access VALUES ('kTCCService${SERVICE}','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0);"
    done
} | "${VOLUME}/usr/bin/sqlite3" "${VOLUME}/Library/Application Support/com.apple.TCC/TCC.db"
