#!/bin/sh
set -ex

launchctl load -wF /Library/LaunchDaemons/com.incognia.macbox.ssh-environment.plist
launchctl load -wF /System/Library/LaunchDaemons/ssh.plist
