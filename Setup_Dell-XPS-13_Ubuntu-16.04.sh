###########################################################################################################################
#!/bin/bash
###########################################################################################################################
if [ ! -f ${HOME}/.bash_aliases ]; then
	touch ${HOME}/.bash_aliases
	ALIASES=(
		"alias sudo='sudo '"
		"alias cp='cp -i -r -u -v'"
		"alias copy='cp -i -r -u -v'"
		"alias rm='rm -I -d -v'"
		"alias remove='rm -I -d -v'"
		"alias del='rm -I -d -v'"
		"alias delete='rm -I -d -v'"
		"alias mv='mv -i -u -v'"
		"alias move='mv -i -u -v'"
		"alias df='df -h / /mnt'"
		"alias grep='grep -i'"
		"alias ls='ls -h --color=always'"
		"alias handbrake-cli='HandBrakeCLI'"
		"alias logoff='gnome-session-quit --logout --no-prompt'"
		)
	for i in "${ALIASES[@]}" ; do
		if [ $(cat ${HOME}/.bash_aliases 2>/dev/null | grep -c "$i") -eq 0 ]; then
			echo $i >> ${HOME}/.bash_aliases
		fi
	done
fi
###########################################################################################################################
if [ ! -d ${HOME}/.local/bin ]; then mkdir ${HOME}/.local/bin; fi
export PROFILE=${HOME}/.profile
	if [ $(cat $PROFILE 2>/dev/null | grep -c "PATH=$PATH:${HOME}/.local/bin") -eq 0 ]; then
		echo "PATH=$PATH:${HOME}/.local/bin" >> $PROFILE
		echo "export PATH" >> $PROFILE
	fi
###########################################################################################################################
GTFOPKG=(
	"account-plugin-facebook" "account-plugin-flickr" "account-plugin-google"
 	"google-chrome-stable" "chromium-browser" "gnome-disk-utility" "rhythmbox"
	"gnome-mahjongg" "gnome-mines" "gnome-software" "gnome-sudoku" "aisleriot"
	"gwakeonlan" "libreoffice-common" "onboard" "totem" "ubuntu-software" "shotwell"
	"vino" "wakeonlan" "gallery-app" "webbrowser-app"
	"unity-scope-calculator" "unity-scope-chromiumbookmarks" "unity-scope-colourlovers"
	"unity-scope-devhelp" "unity-scope-gdrive" "unity-scope-manpages" "unity-scope-openclipart"
	"unity-scope-texdoc" "unity-scope-tomboy" "unity-scope-video-remote" "unity-scope-virtualbox"
	"unity-scope-yelp" "unity-scope-zotero"	"unity-webapps-common" "unity-webapps-qml"
	"unity-scope-audacious"	"unity-scope-clementine" "unity-scope-firefoxbookmarks"
	"unity-scope-gmusicbrowser" "unity-scope-gourmet" "unity-scope-musicstores" "unity-scope-musique"
	"unity-lens-music" "unity-lens-photos" "unity-lens-video" "unity-control-center-signon"
	"xterm" "ux-term" "dell-super-key" "gnome-user-share" "gnome-calendar"
	)
for PKG in "${GTFOPKG[@]}" ; do
	if [ ! $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		sudo apt purge -y --auto-remove $PKG
	fi
done
###########################################################################################################################
sudo apt update
sudo apt -f install -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
###########################################################################################################################
if ! grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -q numix ; then
	sudo add-apt-repository -u --yes ppa:numix/ppa
fi
if ! grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -q mailnag ; then
	sudo add-apt-repository -u --yes ppa:pulb/mailnag
fi
###########################################################################################################################
INSTALL=(
	"numix-gtk-theme" "numix-icon-theme-circle" "ubuntu-restricted-extras" "gnome-mpv" "handbrake"
	"handbrake-cli" "gparted" "tilda" "firefox" "mailnag" "mailnag-unity-plugin" "compizconfig-settings-manager"
	)
for PKG in "${INSTALL[@]}" ; do
	if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		sudo apt install -y $PKG 2>/dev/null
	fi
done
###########################################################################################################################
NODSPLY=(
	"checkbox-converged.desktop" "dell-driver-installer.desktop" "dell-recovery-media.desktop"
	"display-im6.desktop" "display-im6.q16.desktop" "itweb-settings.desktop" "nm-connection-editor.desktop"
	"openjdk-8-policytool.desktop" "logout.desktop" "reboot.desktop" "shutdown.desktop"
	"unity-user-accounts-panel.desktop" "unity-wacom-panel.desktop" "xdiagnose.desktop"
	"software-properties-drivers.desktop" "ccsm.desktop" "mpv.desktop" "tilda.desktop"
	"mailnag-config.desktop" "ccsm.desktop" "unity-credentials-panel.desktop"
	)
for i in "${NODSPLY[@]}"; do 
if [ -f /usr/share/applications/$i ] && [ ! -f ${HOME}/.local/share/applications/$i ]; then 
	cp -v /usr/share/applications/$i ${HOME}/.local/share/applications/$i
	echo NoDisplay=true >> ${HOME}/.local/share/applications/$i 
fi
done
if [ -f /usr/share/applications/display-im6.q16.desktop ] && [ ! -f ${HOME}/.local/share/applications/display-im6.q16.desktop ]; then
	cp -v /usr/share/applications/display-im.q16.desktop ${HOME}/.local/share/applications/display-im6.q16.desktop
	printf "\nNoDisplay=true" >> ${HOME}/.local/share/applications/display-im6.q16.desktop
fi
if [ -f /usr/share/applications/thunderbird.desktop ] && [ ! -f ${HOME}/.local/share/applications/thunderbird.desktop ]; then
	cp -v /usr/share/applications/thunderbird.desktop ${HOME}/.local/share/applications/thunderbird.desktop
	sed -i -e 's/Icon=thunderbird/Icon=thunderbird-branded/g' ${HOME}/.local/share/applications/thunderbird.desktop
fi
if [ -f /usr/share/applications/gnome-mpv.desktop ] && [ ! -f ${HOME}/.local/share/applications/gnome-mpv.desktop ]; then
	cp -v /usr/share/applications/gnome-mpv.desktop ${HOME}/.local/share/applications/gnome-mpv.desktop
	sed -i -e 's/Icon=gnome-mpv/Icon=totem/g' ${HOME}/.local/share/applications/gnome-mpv.desktop
fi
#################################################################################################################################
if [ -f /usr/share/gconf/defaults/40_oem-superkey-workaround ]; then
	sudo rm -rf /usr/share/gconf/defaults/40_oem-superkey-workaround
fi
#################################################################################################################################
if [ $(dpkg-query -W -f='${Status}' google-chrome-stable 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
	rm -v ${HOME}/.gnome/apps/chrome-*-Default.desktop 2>/dev/null
	rm -v ${HOME}/.config/google-chrome/chrome_shutdown_ms.txt 2>/dev/null 
	rm -v ${HOME}/.local/share/icons/hicolor/16x16/apps/chrome-*-Default.png 2>/dev/null 
	rm -v ${HOME}/.local/share/icons/hicolor/128x128/apps/chrome-*-Default.png 2>/dev/null 
	rm -v ${HOME}/.local/share/applications/chrome-*-Default.desktop 2>/dev/null  
fi
###########################################################################################################################
if [ -f ${HOME}/examples.desktop ]; then rm -v ${HOME}/examples.desktop 2>/dev/null; fi
###########################################################################################################################
gsettings set org.gnome.desktop.interface gtk-theme "Numix"
gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle"
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
gsettings set com.canonical.Unity.Launcher favorites "['application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'application://thunderbird.desktop', 'application://gedit.desktop', 'application://gnome-terminal.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
###########################################################################################################################
if [ ! -f /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla ]; then
sudo bash -c "/bin/cat << EOF > /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes
[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes
EOF"
fi
###########################################################################################################################
