#!/bin/bash
######################################################################################################
gsettings set org.gnome.desktop.session idle-delay 0 #Disable screensaver
gsettings set org.gnome.desktop.screensaver lock-enabled false
######################################################################################################
export ALIASFILE=${HOME}/.bash_aliases
if [ ! -f $ALIASFILE ]; then
	touch $ALIASFILE
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
      		"alias transmission='transmission-remote-cli'"
      		"alias handbrake-cli='HandBrakeCLI'"
      		"alias logoff='gnome-session-quit --logout --no-prompt'"
      		)
	for ALS in "${ALIASES[@]}" ; do
		if [ $(cat $ALIASFILE 2>/dev/null | grep -c "$ALS") -eq 0 ]; then
			echo $ALS >> $ALIASFILE
		fi
	done
fi
######################################################################################################
if [ ! -d ${HOME}/.local/bin ]; then mkdir ${HOME}/.local/bin; fi
export PROFILE=${HOME}/.profile
	if [ $(cat $PROFILE 2>/dev/null | grep -c "PATH=$PATH:${HOME}/.local/bin") -eq 0 ]; then
		echo "PATH=$PATH:${HOME}/.local/bin" >> $PROFILE
		echo "export PATH" >> $PROFILE
	fi
######################################################################################################
GTFOPKG=(
      	"account-plugin-facebook" "account-plugin-flickr" "account-plugin-google"
       	"chromium-browser" "gnome-disk-utility" "rhythmbox" "firefox" "remmina"
      	"gnome-mahjongg" "gnome-mines" "gnome-software" "gnome-sudoku" "aisleriot"
      	"gwakeonlan" "libreoffice-common" "onboard" "totem" "ubuntu-software" "shotwell"
      	"vino" "wakeonlan" "thunderbird" "gallery-app" "transmission-gtk" "webbrowser-app"
      	"unity-scope-calculator" "unity-scope-chromiumbookmarks" "unity-scope-colourlovers"
      	"unity-scope-devhelp" "unity-scope-gdrive" "unity-scope-manpages" "unity-scope-openclipart"
      	"unity-scope-texdoc" "unity-scope-tomboy" "unity-scope-video-remote" "unity-scope-virtualbox"
      	"unity-scope-yelp" "unity-scope-zotero"	"unity-webapps-common" "unity-webapps-qml"
         "unity-scope-audacious" "unity-scope-clementine" "unity-scope-firefoxbookmarks"
         "unity-scope-gmusicbrowser" "unity-scope-gourmet" "unity-scope-musicstores" "unity-scope-musique"
         "unity-lens-music" "unity-lens-photos" "unity-lens-video" "xterm"
         )
for PKG in "${GTFOPKG[@]}" ; do
	if [ ! $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		sudo apt purge -y --auto-remove $PKG
	fi
done
######################################################################################################
sudo apt update
sudo apt -f install -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
######################################################################################################
PPALIST=(numix team-xbmc)
for PPA in "${PPALIST[@]}" ; do
	if ! grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -q $PPA ; then
		sudo add-apt-repository -u --yes ppa:$PPA/ppa
	fi
done
######################################################################################################
if [ $(dpkg-query -W -f='${Status}' "google-chrome-stable" 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
	if [ ! -f ${HOME}/Downloads/google-chrome-stable_current_amd64.deb ]; then
    		wget -P ${HOME}/Downloads --show-progress https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	fi
	sudo dpkg -i --force-depends ${HOME}/Downloads/google-chrome-stable_current_amd64.deb
	rm ${HOME}/Downloads/google-chrome-stable_current_amd64.deb
fi
######################################################################################################
INSTALL=(
	      "numix-gtk-theme" "numix-icon-theme-circle" "ubuntu-restricted-extras" "gnome-mpv" "handbrake"
      	"handbrake-cli" "kodi" "gparted" "mdadm" "tilda" "openssh-server" "samba"
      	"transmission-remote-cli" "transmission-remote-gtk" "transmission-daemon" "transmission-cli"
      	)
for PKG in "${INSTALL[@]}" ; do
	if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		sudo apt install -y $PKG 2>/dev/null
	fi
done
#######################################################################################################
NODSPLY=(
	"checkbox-converged.desktop" "dell-driver-installer.desktop" "dell-recovery-media.desktop"
	"display-im6.desktop" "openjdk-8-java.desktop"
      	"openjdk-8-policytool.desktop" "logout.desktop" "reboot.desktop" "shutdown.desktop"
      	"unity-user-accounts-panel.desktop" "unity-wacom-panel.desktop" "xdiagnose.desktop"
      	"software-properties-drivers.desktop" "ccsm.desktop" "mpv.desktop" "tilda.desktop"
      	)
for i in "${NODSPLY[@]}"; do 
if [ -f /usr/share/applications/$i ] && [ ! -f ${HOME}/.local/share/applications/$i ]; then 
	    cp -v /usr/share/applications/$i ${HOME}/.local/share/applications/$i
	    echo NoDisplay=true >> ${HOME}/.local/share/applications/$i 
fi
done
if [ -f /usr/share/applications/display-im6.q16.desktop ] && [ ! -f ${HOME}/.local/share/applications/display-im6.q16.desktop ]; then
      cp -v /usr/share/applications/display-im6.q16.desktop ${HOME}/.local/share/applications/display-im6.q16.desktop
      echo >> ${HOME}/.local/share/applications/display-im6.q16.desktop
      echo NoDisplay=true >> ${HOME}/.local/share/applications/display-im6.q16.desktop
fi
if [ -f /usr/share/applications/gnome-mpv.desktop ] && [ ! -f ${HOME}/.local/share/applications/gnome-mpv.desktop ]; then
  		cp -v /usr/share/applications/gnome-mpv.desktop ${HOME}/.local/share/applications/gnome-mpv.desktop
  		sed -i -e 's/Icon=gnome-mpv/Icon=totem/g' ${HOME}/.local/share/applications/gnome-mpv.desktop
fi
#######################################################################################################
if [ -f ${HOME}/examples.desktop ]; then rm -v ${HOME}/examples.desktop 2>/dev/null; fi
#######################################################################################################
gsettings set org.gnome.desktop.interface gtk-theme "Numix"
gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle"
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
gsettings set com.canonical.Unity.Launcher favorites "['application://org.gnome.Nautilus.desktop', 'application://google-chrome.desktop', 'application://gedit.desktop', 'application://kodi.desktop', 'application://gnome-terminal.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
