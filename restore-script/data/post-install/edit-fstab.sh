#!/bin/bash

# Colour table {{{
NONE="\033[0m"    # unsets color to term's fg color

# emphasized (bolded) colors
EMR="\033[1;31m" # red
EMG="\033[1;32m" # green
EMY="\033[1;33m" # yellow
# }}}

# Query for information {{{
cont='y'
counter=1
printf "\n# Below entries configured by Ashhar Hasan's postinstall script, be sure to check for errors\n" | sudo tee -a /etc/fstab
while [[ $cont == 'y' ]]; do
    confirm='n'
    while [[ $confirm == 'n' ]]; do
        printf "${EMG}Setting up partition ${counter}${NONE}:\n"
        printf "Enter partition UUID, mount point, file system, options, a 0 if this partition should not be 'fsck'ed. All fields should be separated by spaces.\n"
        printf "${EMY}UUID MOUNT_POINT FILE_SYSTEM OPTIONS FSCK(1 to enable)${NONE}\n"
        read -e uuid mount_point file_system options fsck
        printf "UUID=$uuid $mount_point $file_system $options 0 $fsck\n"
        printf "${EMR}Was the above information correct ([y]/n):${NONE}\n"
        read -e -i "y" confirm
   done
   (( counter++ ))
   # Default to not dumping.
   dump=0
   # fsck is 1 only for the root partition.
   if (( fsck == 1 )); then
       fsck_enabled=2
   fi
   printf "UUID=$uuid $mount_point $file_system $options $dump $fsck_enabled\n" | sudo tee -a /etc/fstab
   sudo mkdir "$mount_point"
   printf "${EMR}Do you have more partitions you want to mount ([y]/n):${NONE}\n"
   read -e -i "y" cont
done
# }}}
