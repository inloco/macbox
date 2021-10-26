#!/bin/sh
set -ex

# systemsetup -setremotelogin on
launchctl load -wF /System/Library/LaunchDaemons/ssh.plist
