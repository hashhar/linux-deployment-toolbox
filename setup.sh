# Variables
export HOME="/home/ashhar"
export LOCAL_SRC="${HOME}/.local/src"
export LOCAL_BIN="${HOME}/.local/bin"
export STOW_DIR="/usr/local/stow"
export INSTALL="sudo apt install -y"
export RESTORE="${HOME}/restore"
export TMP_WGET="/tmp/wget"
export FONTS_DIR="${HOME}/.fonts"

TMP_RESTORE="/tmp/restore"

UNINSTALL="sudo apt autoremove --purge -y"
DPKG_INSTALL="sudo dpkg -i"
NPM_INSTALL="npm install -g"
PIP2="sudo pip2 install"
PIP3="sudo pip3 install"
GEM="sudo gem install"
GET_DOTFILES="git clone https://github.com/hashhar/dotfiles"
ANACONDA_FILE="Anaconda3-4.2.0-Linux-x86_64.sh"

mkdir -p ${LOCAL_SRC}
mkdir -p ${LOCAL_BIN}
sudo mkdir -p ${STOW_DIR}

# Deal with data/apt
printf '%s\n' "Adding PPAs"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    # Add all the PPAs
    sudo ${RESTORE}/data/apt/ppa.list
fi

sudo apt-get install git

# Download packages not present in repositories and install them.
printf '%s\n' "Downloading and installing extra packages"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    mkdir ${TMP_WGET} && cd ${TMP_WGET}
    ${RESTORE}/data/wget/urls.list
    ${DPKG_INSTALL} ${TMP_WGET}/*.deb
    ${RESTORE}/data/wget/fonts.sh
    cd ${RESTORE}
fi

# Remove comments and blank lines from the list files and save them to ${TMP_RESTORE}
mkdir ${TMP_RESTORE}
cp ${RESTORE}/data/apt/*.list ${TMP_RESTORE}
cp ${RESTORE}/data/npm/*.list ${TMP_RESTORE}
cp ${RESTORE}/data/python/*.list ${TMP_RESTORE}
cp ${RESTORE}/data/ruby/*.list ${TMP_RESTORE}
sed -i '/^\s*#/d' ${TMP_RESTORE}/*.list

# Install the lists
printf '%s\n' "Installing DEVELOPEMENT tools"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${INSTALL} $(cat ${TMP_RESTORE}/development.list)
fi

printf '%s\n' "Installing ENVIRONMENT"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${INSTALL} $(cat ${TMP_RESTORE}/environment.list)
fi

printf '%s\n' "Installing MEDIA tools"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    ${INSTALL} $(cat ${TMP_RESTORE}/media.list)
fi

printf '%s\n' "Installing FONTS"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    ${INSTALL} $(cat ${TMP_RESTORE}/fonts.list)
fi

printf '%s\n' "Installing UTILITIES"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${INSTALL} $(cat ${TMP_RESTORE}/utilities.list)
fi

printf '%s\n' "Installing packages that also need recommended packages"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${INSTALL} --install-recommends $(cat ${TMP_RESTORE}/recommends.list)
fi

# Remove the packages to be purged
printf '%s\n' "Purging packages"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${UNINSTALL} $(cat ${TMP_RESTORE}/purge.list)
fi

# Build the packages that need to be built from source
printf '%s\n' "Compiling tools"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${RESTORE}/data/apt/build.list
    cd ${RESTORE}
fi

# Install stuff from git.
printf '%s\n' "CLONING tools"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${RESTORE}/data/git/clone.list
    cd ${RESTORE}
fi

# Install stuff into node.
printf '%s\n' "Installing NPM stuff"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${NPM_INSTALL} $(cat ${TMP_RESTORE}/npm.list)
fi

# Install stuff from pip.
printf '%s\n' "Installing PYTHON stuff"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${PIP2} $(cat ${TMP_RESTORE}/pip2.list)
    ${PIP3} $(cat ${TMP_RESTORE}/pip3.list)
fi

# Install stuff from rubygems.
printf '%s\n' "Installing RUBY stuff"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    ${GEM} $(cat ${TMP_RESTORE}/gem.list)
    ${RESTORE}/data/ruby/gem.sh
fi

# Anaconda4
printf '%s\n' "Installing ANACONDA stuff"
printf '%s\n' "Y to continue, N to skip"
read choice
if [ "$choice" == "Y" ]; then
    cd ${HOME}/Downloads
    if [ ! -f ${ANACONDA_FILE} ]; then
        wget "http://repo.continuum.io/archive/${ANACONDA_FILE}"
    else
	printf '%s\n' "Anaconda setup already present, will not download again. Starting setup."
    fi
    bash ${ANACONDA_FILE}
    cd
fi

# Install my dotfiles.
cd
${GET_DOTFILES} dotfiles
./dotfiles/install.sh

# Make all files in ${LOCAL_BIN} executable.
chmod -R 755 ${LOCAL_BIN}/*

# Setup grub
${RESTORE}/data/grub/grub.sh
