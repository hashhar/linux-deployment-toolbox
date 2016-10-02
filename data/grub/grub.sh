#!/bin/bash

cp boot.png /boot
patch /etc/default/grub grub.patch
update-grub

