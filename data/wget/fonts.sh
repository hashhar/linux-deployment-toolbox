#!/usr/bin/env bash
FONTS_DIR="${HOME}/.fonts"
cd ${FONTS_DIR}

file-roller -h ${FONTS_DIR}/font-awesome.tar.gz &
file-roller -h ${FONTS_DIR}/hack-ttf.tar.gz &
file-roller -h ${FONTS_DIR}/octicons.tar.gz &
file-roller -h ${FONTS_DIR}/droid-sans-mono.zip &
file-roller -h ${FONTS_DIR}/fira.zip &
file-roller -h ${FONTS_DIR}/source-code-pro.tar.gz &

shopt -s extglob
shopt -s globstar
rm -d **/!(*.ttf)
rm *.tar.gz *.zip
shopt -u extglob
shopt -u globstar