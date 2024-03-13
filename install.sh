
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
if [! -f "${PREFIX}/bin/termux-x11" ];then
	INSTALL_X11="termux-x11-nightly"
	PKG="true"
fi
if [ "${PKG}" == "true" ];then
	echo "Installing missing packages..."
	pkg install "${INSTALL_PROOT}" "${INSTALL_WGET}" "${INSTALL_PERL}" "${INSTALL_X11}"
fi
echo "Installing ubuntu proot..."
proot-distro install ubuntu || exit 2
UBUNTU_DIR="${PREFIX}/var/lib/proot-distro/installed-rootfs/ubuntu"
cd "${UBUNTU_DIR}/usr/bin"
wget -q https://raw.githubusercontent.com/pi-dev500/termuxubuntu-x11/main/x11-splash.py -O x11-splash.py
mkdir -p "${UBUNTU_DIR}/usr/share/backgrounds"
cd "${UBUNTU_DIR}/usr/share/backgrounds"
wget -q "https://github.com/pi-dev500/termuxubuntu-x11/blob/main/start.jpg?raw=true" -O start.jpg
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
# crypt password to make it understandable by adduser
CPASS=`perl -e 'print crypt("${password}", "salt"),"\n"'`
echo "Configurating proot..."
echo -e "apt install sudo xfce4 firefox \n useradd -m -p '${CPASS}' ${username}" | proot-distro login ubuntu
echo "
TERMUX_PREFIX=\${PREFIX}
if [ -f \"\${TERMUX_PREFIX}/tmp/isDE\" ];then
  echo \"Desktop already started, exiting now...\"
  exit 0
fi
echo ubuntu> \"\${TERMUX_PREFIX}/tmp/isDE\"
echo \"Starting Ubuntu xfce desktop...\"
bash ~/.sound
termux-x11 :1 &
X11_PID=\$!
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null
echo -e \"export DISPLAY=:1\nxfwm4&\nx11-splash.py & \nsudo service dbus start\nxfce4-session \" | proot-distro login --user \"${username}\" ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports &>/dev/null
kill $X11_PID
rm \"\${TERMUX_PREFIX}/tmp/isDE\"
echo \"Desktop closed\"
" >"${PREFIX}/bin/ubuntu"
chmod +x "${PREFIX}/bin/ubuntu"
mkdir -p "${HOME}/.shortcuts/tasks"
echo "bash -c ubuntu" > "${HOME}/.shortcuts/tasks/Ubuntu"
