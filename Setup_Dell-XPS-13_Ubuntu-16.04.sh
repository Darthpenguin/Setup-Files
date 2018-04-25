#################################################################################################################################
#!/bin/bash
#################################################################################################################################
if [ $(lsb_release -a | grep -c "Ubuntu 16.04") -eq 0 ]; then
	echo "Warning: This does not seem to be Ubuntu 16.04 LTS. Canceling."
	read -n 1 -s -r -p "Press any key to continue"
	exit
fi
#################################################################################################################################
profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1}
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-transparent-background true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-transparency-percent 10
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" cursor-shape ibeam
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" scrollbar-policy never
#################################################################################################################################
export ALSFL=${HOME}/.bash_aliases
if [ ! -f $ALSFL ]; then
	touch $ALSFL
	ALIASES=(
		"alias exot='exit'"
		"alias bye='exit'"
		"alias goodbye='exit'"
		"alias quit='exit'"
		"alias sudo='sudo '"
		"alias ..='cd ..'"
		"alias cd.='cd ..'"
		"alias cd..='cd ..'"
		"alias cls='clear'"
		"alias cp='cp -i -r -u -v'"
		"alias copy='cp -i -r -u -v'"
		"alias rm='rm -I -d -v'"
		"alias remove='rm -I -d -v'"
		"alias del='rm -I -d -v'"
		"alias delete='rm -I -d -v'"
		"alias mv='mv -i -u -v'"
		"alias move='mv -i -u -v'"
		"alias rename='rename -v'"
		"alias mkdir='mkdir -p'"
		"alias df='df -h /'"
		"alias du='du -h'"
		"alias grep='grep -i'"
		"alias ls='ls -h --color=always'"
		"alias scp='scp -r -l 8192'"
		"alias chown='chown -v'"
		"alias chmod='chmod -v'"
		"alias chgrp='chgrp -v'"
		"alias handbrake-cli='HandBrakeCLI'"
		"alias logoff='gnome-session-quit --logout --no-prompt'"
		"alias ps='ps -A'"
		"alias apt='sudo apt'"
		"alias apt-get='sudo apt'"
		"alias upgrade='update'"
		"alias ipconfig='ifconfig'"
		"alias matrix='cmatrix -s'"
		"alias halp='help'"
		"alias uname='uname -a'"
		"alias rsync='rsync --verbose --human-readable'"
		)
	for i in "${ALIASES[@]}" ; do
		if [ $(cat $ALSFL 2>/dev/null | grep -c "$i") -eq 0 ]; then
			echo $i >> $ALSFL
		fi
	done
fi
#################################################################################################################################
GTFOPKG=(
	"account-plugin-facebook" "account-plugin-flickr" "account-plugin-google"
	"google-chrome-stable" "chromium-browser"
	"gnome-mahjongg" "gnome-mines" "gnome-sudoku" "aisleriot"
	"gnome-software" "gwakeonlan" "onboard" "totem" "ubuntu-software"
	"vino" "wakeonlan" "gallery-app" "webbrowser-app"
	"unity-scope-calculator" "unity-scope-chromiumbookmarks" "unity-scope-colourlovers" "unity-scope-devhelp" "unity-scope-gdrive" "unity-scope-manpages"
	"unity-scope-openclipart" "unity-scope-texdoc" "unity-scope-tomboy" "unity-scope-video-remote" "unity-scope-virtualbox" "unity-scope-yelp" "unity-scope-zotero"
	"unity-webapps-common" "unity-webapps-qml" "unity-scope-audacious" "unity-scope-clementine" "unity-scope-firefoxbookmarks" "unity-scope-gmusicbrowser" "unity-scope-gourmet"
	"unity-scope-musicstores" "unity-scope-musique" "unity-lens-music" "unity-lens-photos" "unity-lens-video" "unity-control-center-signon"
	"xterm" "dell-super-key" "gnome-calendar" "dell-super-key" "flashplugin-installer"
	)
for PKG in "${GTFOPKG[@]}" ; do
	if [ ! $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		sudo apt purge -y --auto-remove $PKG
	fi
done
#################################################################################################################################
sudo apt update
sudo apt -f install -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
#################################################################################################################################
if [ $(ls /etc/apt/sources.list.d/ | grep "numix-ubuntu-ppa-xenial") -eq 0 ]; then
	sudo add-apt-repository -u --yes ppa:numix/ppa
fi
if [ $(ls /etc/apt/sources.list.d/ | grep "pulb-ubuntu-mailnag-xenial") -eq 0 ]; then
	sudo add-apt-repository -u --yes ppa:pulb/mailnag
fi
#################################################################################################################################
INSTALL=(
	"numix-gtk-theme" "numix-icon-theme-circle" "ubuntu-restricted-extras" "vlc" "firefox" "mailnag" "mailnag-unity-plugin"
	)
for PKG in "${INSTALL[@]}" ; do
	if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		sudo apt install -y $PKG 2>/dev/null
	fi
done
#################################################################################################################################
NODSPLY=(
	"checkbox-converged.desktop" "dell-driver-installer.desktop" "dell-recovery-media.desktop"
	"display-im6.desktop" "itweb-settings.desktop" "nm-connection-editor.desktop" "openjdk-8-policytool.desktop" 
	"logout.desktop" "reboot.desktop" "shutdown.desktop"
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
	cp -v /usr/share/applications/display-im6.q16.desktop ${HOME}/.local/share/applications/display-im6.q16.desktop
	printf "\nNoDisplay=true" >> ${HOME}/.local/share/applications/display-im6.q16.desktop
fi
if [ -f /usr/share/applications/thunderbird.desktop ] && [ ! -f ${HOME}/.local/share/applications/thunderbird.desktop ]; then
	cp -v /usr/share/applications/thunderbird.desktop ${HOME}/.local/share/applications/thunderbird.desktop
	sed -i -e 's/Icon=thunderbird/Icon=thunderbird-branded/g' ${HOME}/.local/share/applications/thunderbird.desktop
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
#################################################################################################################################
if [ -f ${HOME}/examples.desktop ]; then rm -v ${HOME}/examples.desktop 2>/dev/null; fi
#################################################################################################################################
gsettings set org.gnome.desktop.interface gtk-theme "Numix"
gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle"
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
#################################################################################################################################
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
#################################################################################################################################
sudo bash -c "sed -e '58,65d' /usr/share/unity/scopes/applications.scope"
#################################################################################################################################
echo "reboot system when done."
#################################################################################################################################
