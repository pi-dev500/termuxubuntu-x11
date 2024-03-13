
echo "Checking dependencies..."
if [! -f "${PREFIX}/bin/proot-distro"]; then
	INSTALL_PROOT="proot-distro"
	PKG="true"
fi
if [! -f "${PREFIX}/bin/wget" ];then
	INSTALL_WGET="wget"
	PKG="true"
fi
if [! -f "${PREFIX}/bin/perl" ];then
	INSTALL_PERL="perl"
	PKG="true"
fi
if [ "${PKG}" == "true" ];then
	echo "Installing missing packages..."
	pkg install "${INSTALL_PROOT}" "${INSTALL_WGET}" "${INSTALL_PERL}"
fi
echo "Installing ubuntu proot..."
proot-distro install ubuntu || exit 2
UBUNTU_DIR="${PREFIX}/var/lib/proot-distro/installed-rootfs/ubuntu"
cd "${UBUNTU_DIR}/usr/bin"
wget -q https://raw.githubusercontent.com/pi-dev500/termuxubuntu-x11/raw/main/x11-splash.py -O x11-splash.py
chmod +x x11-splash.py
clear
echo "Input the credentials you want:"
echo -n "USERNAME: "
read username
echo -n "PASSWORD: "
read -s password
echo -n "CONFIRM PASSWORD: "
read -s cpassword
if [ ! "${password}" == "${cpassword}" ];then
	echo "Passwords don't match, please retry: "
	echo -n "PASSWORD: "
	read -s password
	echo -n "CONFIRM PASSWORD: "
	read -s cpassword
	if [ ! "${password}" == "${cpassword}" ];then
		echo "Passwords don't match, exiting..."
		exit 203
	fi
fi
CPASS=`perl -e 'print crypt("${password}", "salt"),"\n"'`
