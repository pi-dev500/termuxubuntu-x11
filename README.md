# termuxubuntu-x11
 bring easely a xubuntu desktop on termux (ANDROID)

## Installation
 - First, you need to install **Termux** and **Termux:Widgets** on your Android device using [F-Droid](https://f-droid.org) (Google play versions are not supported)
 - You will also need to install **Termux-x11**. Universal APK can be found [there](https://github.com/termux/termux-x11/releases/download/nightly/app-universal-debug.apk).
 
 - Then, you need to launch Termux app and run:
 ```
 pkg install wget
 wget -qO- https://raw.githubusercontent.com/pi-dev500/termuxubuntu-x11/main/install.sh | bash
 ```
 - Now, if you followed correctly the instructions, you should have a working ubuntu desktop that can be started by running ```ubuntu``` in termux.
 
## Shortcut
 - If you want to have a direct shortcut to your ubuntu desktop, you should create a widget and select <b>Termux:Widgets</b>:
 <img src="https://github.com/pi-dev500/termuxubuntu-x11/blob/main/screen-widget.png?raw=true" width="200">screenshot</img>
 - Then select <b>Termux shortcut</b> (for most of android lauchers, hold and place on homescreen)
 - It will open a window whith a file browser. Click on <b>tasks</b>, then on <b>Ubuntu</b>.
 - A new icon will appear at the bottom of your screen. Hold down a click on it and move it to the desired position on your home screen.
 - This icon will permit to access directly to your linux desktop after a little wait.
