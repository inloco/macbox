import base64
import hashlib
import plistlib


def make_hash(password='pass', salt=b'\0'*32, iterations=1):
    entropy = hashlib.pbkdf2_hmac('sha512', bytes(map(ord, password)), salt, iterations, dklen=128)

    shadow_hash_data = {
        'SALTED-SHA512-PBKDF2': {
            'salt': salt,
            'iterations': iterations,
            'entropy': entropy,
        },
    }

    return plistlib.dumps(shadow_hash_data, fmt=plistlib.FMT_BINARY)


def make_user(realname='User', shadow_hash_data=make_hash()):
    user = realname.split(' ')[0].lower()

    attributes = {
        'ShadowHashData': [
            shadow_hash_data,
        ],
        'authentication_authority': [
            ';ShadowHash;HASHLIST:<SALTED-SHA512-PBKDF2>',
        ],
        'home': [
            f'/Users/{user}',
        ],
        'name': [
            user,
        ],
        'generateduid': [
            '00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF',
        ],
        'gid': [
            '20',
        ],
        'realname': [
            realname,
        ],
        'shell': [
            '/bin/zsh',
        ],
        'uid': [
            '501',
        ],
    }

    return plistlib.dumps(attributes, fmt=plistlib.FMT_BINARY)


def make_admin(user='user'):
    props = {
        'groupmembers': [
            '00000000-AAAA-BBBB-CCCC-DDDDEEEEFFFF',
        ],
        'users': [
            user,
        ],
    }

    return plistlib.dumps(props, fmt=plistlib.FMT_BINARY)


def make_casa(build_version='$(sw_vers -buildVersion)'):
    props = {
        'DidSeeAccessibility': True,
        'DidSeeActivationLock': True,
        'DidSeeAppStore': True,
        'DidSeeAppearanceSetup': True,
        'DidSeeApplePaySetup': True,
        'DidSeeAvatarSetup': True,
        'DidSeeCloudSetup': True,
        'DidSeePrivacy': True,
        'DidSeeScreenTime': True,
        'DidSeeSiriSetup': True,
        'DidSeeSyncSetup': True,
        'DidSeeSyncSetup2': True,
        'DidSeeTouchIDSetup': True,
        'DidSeeTrueTone': True,
        'DidSeeiCloudLoginForStorageServices': True,
        'LastPreLoginTasksPerformedBuild': '0',
        'LastPreLoginTasksPerformedVersion': '0',
        'LastPrivacyBundleVersion': '2',
        'LastSeenBuddyBuildVersion': build_version,
        'LastSeenCloudProductVersion': '0',
        'LastSeenDiagnosticsProductVersion': '0',
        'LastSeenSiriProductVersion': '0',
        'LastSeeniCloudStorageServicesProductVersion': '0',
        'MiniBuddyLaunchReason': 0,
        'MiniBuddyLaunchedPostMigration': False,
        'MiniBuddyShouldLaunchToResumeSetup': False,
        'NSAddServicesToContextMenus': False,
        'PreviousBuildVersion': '0',
        'PreviousSystemVersion': '0',
        'SkipFirstLoginOptimization': False,
    }

    return plistlib.dumps(props, fmt=plistlib.FMT_BINARY)


def make_calw(user='user'):
    props = {
        'autoLoginUser': user,
        'loginWindowIdleTime': 0,
    }

    return plistlib.dumps(props, fmt=plistlib.FMT_BINARY)
        

def plist2sh(plist, patch=False):
    value_of = lambda e: switch[type(e)](e)
    
    switch = {
        type(''): lambda e:
            f'-string "{e}"',
        type(b''): lambda e:
            f'-data {e.hex().upper()}',
        type(0): lambda e:
            f'-int {e}',
        type(.0): lambda e:
            f'-float {e}',
        type(False): lambda e:
            '-bool ' + ('YES' if e else 'NO'),
        type([]): lambda e:
            '-array' + ('-add ' if patch else ' ') + ' '.join(map(value_of, e)),
        type({}): lambda e:
            '-dict' + ('-add ' if patch else ' ') + ' '.join(map(lambda kv: f'"{kv[0]}" {value_of(kv[1])}', e.items())),
    }

    props = plistlib.loads(plist, fmt=plistlib.FMT_BINARY)

    sh = b'#!/bin/sh\n'
    for kv in props.items():
        sh += f'defaults write "${{DOMAIN}}" "{kv[0]}" {value_of(kv[1])}\n'.encode('ascii')
    
    return sh


def make_kcpassword(password='pass'):
    key = [0x7D, 0x89, 0x52, 0x23, 0xD2, 0xBC, 0xDD, 0xEA, 0xA3, 0xB9, 0x1F]
    key_len = len(key)
    key_val = lambda i: key[i % key_len]
    dec = list(map(ord, password))
    dec_len = len(dec)
    dec_val = lambda i: dec[i] if i < dec_len else 0
    return bytes(map(lambda i: dec_val(i) ^ key_val(i), range(dec_len + key_len - dec_len % key_len)))


if __name__ == '__main__':
    d = './build'

    h_plist = make_hash()
    with open(f'{d}/ShadowHashData.plist', 'wb') as f:
        f.write(h_plist)
    h_sh = plist2sh(h_plist)
    with open(f'{d}/ShadowHashData.sh', 'wb') as f:
        f.write(h_sh)

    u_plist = make_user()
    with open(f'{d}/user.plist', 'wb') as f:
        f.write(u_plist)
    u_sh = plist2sh(u_plist)
    with open(f'{d}/user.sh', 'wb') as f:
        f.write(u_sh)

    a_plist = make_admin()
    with open(f'{d}/admin.plist', 'wb') as f:
        f.write(a_plist)
    a_sh = plist2sh(a_plist, patch=True)
    with open(f'{d}/admin.sh', 'wb') as f:
        f.write(a_sh)

    sa_plist = make_casa()
    with open(f'{d}/com.apple.SetupAssistant.plist', 'wb') as f:
        f.write(sa_plist)
    sa_sh = plist2sh(sa_plist)
    with open(f'{d}/com.apple.SetupAssistant.sh', 'wb') as f:
        f.write(sa_sh)

    lw_plist = make_calw()
    with open(f'{d}/com.apple.loginwindow.plist', 'wb') as f:
        f.write(lw_plist)
    lw_sh = plist2sh(lw_plist)
    with open(f'{d}/com.apple.loginwindow.sh', 'wb') as f:
        f.write(lw_sh)

    kcpw = make_kcpassword()
    with open(f'{d}/kcpassword', 'wb') as f:
        f.write(kcpw)
