#!/bin/bash

RESTORE_PATH="/tmp/[datastore1] jeos/"
RESTORE_VMDK="jeos.vmdk"
RESTORE_VMX="restore.vmx"
SHARE_PATH="/mnt/"
SHARE_OVA="restore.ova"

QCS_DOMAIN=${QCS_DOMAIN:-"1.1.1.1"}
QCS_USER="admin@internal"
QCS_PASSWD="admin"
QCS_API="https://${QCS_DOMAIN}/ovirt-engine/api"
QCS_API_CURL="curl -s --insecure -H  \"accept: application/xml\" --user ${QCS_USER}:${QCS_PASSWD} "
QCS_SHARE_PATH="ova:///share/CACHEDEV1_DATA/.qpkg/QCephClient/run/vdsm/data-center/mnt/_QCS/"

QCS_CLUSTER_ID=$( $QCS_API_CURL -X GET ${QCS_API}/clusters | sed -n 's:.*/ovirt-engine/api/clusters/\([^"/]*\)".*:\1:p' )
QCS_HOST_ID=$( $QCS_API_CURL -X GET ${QCS_API}/hosts | sed -n 's:.*/ovirt-engine/api/hosts/\([^"/]*\)".*:\1:p' )
QCS_STORAGE_ID=$( $QCS_API_CURL -X GET ${QCS_API}/storagedomains?search=name=hosted_storage | sed -n 's:.*/ovirt-engine/api/storagedomains/\([^"/]*\)".*:\1:p' )

VM_NAME="restore_vmware"

# convert vmx to ova
ovftool --quiet "${SHARE_PATH}${RESTORE_VMX}" "${SHARE_PATH}${SHARE_OVA}"

# use rest api to import OVA on QCS
$QCS_API_CURL -X POST ${QCS_API}/externalvmimports -H  "Content-Type: application/xml" \
     -d "<external_vm_import>  <cluster id=\"${QCS_CLUSTER_ID}\" />  <storage_domain id=\"${QCS_STORAGE_ID}\" />  <host id=\"${QCS_HOST_ID}\"/>  <name>${VM_NAME}</name>  <sparse>true</sparse>  <provider>vmware</provider>  <url>${QCS_SHARE_PATH}${SHARE_OVA}</url></external_vm_import>"

rm "${RESTORE_PATH}${RESTORE_VMDK}"
