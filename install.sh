
echo "Checking dependencies..."
if [! -f "${PREFIX}/bin/proot-distro"]; then
	INSTALL_PROOT="proot-distro"
	PKG="true"
fi
if [! -f "${PREFIX}/bin/wget" ];then
	INSTALL_WGET="wget"
	PKG="true"
fi
if [ "${PKG}" == "true" ];then
	echo "Installing missing packages..."
	pkg install "${INSTALL_PROOT}" "${INSTALL_WGET}"
fi
echo "Installing ubuntu proot..."
proot-distro install ubuntu || exit 2
UBUNTU_DIR="${PREFIX}/var/lib/proot-distro/installed-rootfs/ubuntu"
cd "${UBUNTU_DIR}/usr/bin"
wget -q --show-progress https://raw.githubusercontent.com/pi-dev500/termuxubuntu-x11/raw/main/x11-splash.py
