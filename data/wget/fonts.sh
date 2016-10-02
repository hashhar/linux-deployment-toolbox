#!/usr/bin/env bash
FONTS_DIR="${HOME}/.fonts"
cd ${FONTS_DIR}

file-roller -h ${FONTS_DIR}/dina.zip
file-roller -h ${FONTS_DIR}/droid-sans-mono.zip &
file-roller -h ${FONTS_DIR}/fira.zip &
file-roller -h ${FONTS_DIR}/fira-code.zip &
file-roller -h ${FONTS_DIR}/font-awesome.tar.gz &
file-roller -h ${FONTS_DIR}/gohufont-pcf.tar.gz &
file-roller -h ${FONTS_DIR}/hack-ttf.tar.gz &
file-roller -h ${FONTS_DIR}/iosevka.zip &
file-roller -h ${FONTS_DIR}/octicons.tar.gz &
file-roller -h ${FONTS_DIR}/source-code-pro.tar.gz &

# Enable bitmap fonts
sudo ${RESTORE}/data/wget/bitmap-fonts.sh

# Cleanup
find ${FONTS_DIR} ! -iname "*.ttf" ! -iname "*.fon" ! -iname "*.bdf" ! -iname "*.otf" ! -iname "*.pcf.gz" -print0 | xargs -0 rm -d
find ${FONTS_DIR} ! -iname "*.ttf" ! -iname "*.fon" ! -iname "*.bdf" ! -iname "*.otf" ! -iname "*.pcf.gz" -print0 | xargs -0 rm -d
