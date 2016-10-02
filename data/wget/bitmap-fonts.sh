#!/usr/bin/env sh

cd /etc/fonts/conf.d
if [ -f "70-no-bitmaps.conf" -a ! -f "70-yes-bitmaps.conf" ]; then
	rm 70-no-bitmaps.conf
	ln -s ../conf.avail/70-yes-bitmaps.conf .
	dpkg-reconfigure fontconfig-config
	dpkg-reconfigure fontconfig
fi
