#!/bin/sh
set -ex

# systemsetup -setremotelogin on
launchctl load -wF "${VOLUME}/System/Library/LaunchDaemons/ssh.plist"
