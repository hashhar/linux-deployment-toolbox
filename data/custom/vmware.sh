#!/bin/sh

printf '%s' "Enter path to VMWare bundle: "
read BUNDLE

sudo "${BUNDLE}"
printf '%s' "Enter path where the program to sign VMWare kernel modules should be installed: "
read VMWARE_PATCH
git clone https://github.com/hashhar/vmware-module-patch "${VMWARE_PATCH}"
"${VMWARE_PATCH}/patch-launcher.sh"
"${VMWARE_PATCH}/patch-modules.sh"
"${VMWARE_PATCH}/sign-modules.sh"
