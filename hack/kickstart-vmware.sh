#!/bin/sh
set -ex

VMWARE_LICENSETOOL_SERIALNUMBER="${1}"
VMWARE_LICENSETOOL_NAME=''
VMWARE_LICENSETOOL_COMPANYNAME=''
VMWARE_LICENSETOOL_PRODUCTVERSIONSTRING='12.0'
VMWARE_LICENSETOOL_PRODUCTNAME='VMware Fusion for Mac OS'
VMWARE_LICENSETOOL_DORMANTPATH=''

sudo '/Applications/VMware Fusion.app/Contents/Library/licenses/vmware-licenseTool' enter "${VMWARE_LICENSETOOL_SERIALNUMBER}" "${VMWARE_LICENSETOOL_NAME}" "${VMWARE_LICENSETOOL_COMPANYNAME}" "${VMWARE_LICENSETOOL_PRODUCTVERSIONSTRING}" "${VMWARE_LICENSETOOL_PRODUCTNAME}" "${VMWARE_LICENSETOOL_DORMANTPATH}"

until vctl system start
do
    :
done

vctl system stop --force