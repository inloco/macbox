#!/bin/sh
set -ex

while true
do
    /usr/libexec/path_helper -s | sed -e 's/"//g' -e 's/;.*//g' > /private/etc/ssh/ssh_environment
done
