#!/bin/bash

RESTORE_PATH="/tmp/[datastore1] jeos/"
RESTORE_VMDK="jeos.vmdk"
RESTORE_VMX="restore.vmx"

ESXi="1.1.1.1"
ESXi_USER="root"
ESXi_PASSWD="password"
ESXi_DATASTORE="datastore1"

VM_NAME="restore"

# upload vmdk to esxi
vifs --server ${ESXi} --username ${ESXi_USER} --password ${ESXi_PASSWD} -p "${RESTORE_PATH}${RESTORE_VMDK}" "[${ESXi_DATASTORE}] ${VM_NAME}/${RESTORE_VMDK}"
# register vm to esxi
vmware-cmd --server ${ESXi} --username ${ESXi_USER} --password ${ESXi_PASSWD} -s register /vmfs/volumes/${ESXi_DATASTORE}/${VM_NAME}/${RESTORE_VMX}
rm "${RESTORE_PATH}${RESTORE_VMDK}"
