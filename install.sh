#!/data/data/com.termux/files/usr/bin/bash
echo "Checking dependencies..."
echo "Installing dependencies..."
pkg install proot-distro termux-x11-nightly x11-repo perl wget pulseaudio
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
CPASS=`perl -e "print crypt(\"${password}\", \"salt\"),\"\n\""`
echo "Configurating proot..."
echo -e "apt update
apt install fakeroot sudo xfce4 firefox
pip install customtkinter --break-system-packages
useradd -m -p '${CPASS}' ${username}" | proot-distro login ubuntu
echo "
#!/data/data/com.termux/files/usr/bin/bash
TERMUX_PREFIX=\${PREFIX}

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null &
if [ -f \"\${TERMUX_PREFIX}/tmp/isDE\" ];then
  echo \"Desktop already started, exiting now...\"
  exit 0
fi
echo ubuntu> \"\${TERMUX_PREFIX}/tmp/isDE\"
echo \"Starting Ubuntu xfce desktop...\"
pulseaudio --start
termux-x11 :1 &
X11_PID=\$!
echo -e \"export DISPLAY=:1\nxfwm4&\nx11-splash.py & \nsudo service dbus start\nxfce4-session \" | proot-distro login --user \"${username}\" ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports &>/dev/null
kill $X11_PID
rm \"\${TERMUX_PREFIX}/tmp/isDE\"
echo \"Desktop closed\"
" >"${PREFIX}/bin/ubuntu"
chmod +x "${PREFIX}/bin/ubuntu"
mkdir -p "${HOME}/.shortcuts/tasks"
echo "bash -c ubuntu" > "${HOME}/.shortcuts/tasks/Ubuntu"
