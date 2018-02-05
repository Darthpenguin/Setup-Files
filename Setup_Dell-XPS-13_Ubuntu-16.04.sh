###########################################################################################################################
#!/bin/bash
###########################################################################################################################
if [ ! -f ${HOME}/.bash_aliases ]; then
	touch ${HOME}/.bash_aliases
	ALIASES=(
		"alias sudo='sudo '" #Because sudo doesn't accept my aliases with out this. I don't know why.
		"alias cp='cp -i -r -u -v'" #Because I always want verbosity. We all want verbosity damint!
		"alias copy='cp -i -r -u -v'" #Because sometimes I type 'copy'.
		"alias rm='rm -I -d -v'"  #Again. Why is verbosity *not* the default?
		"alias remove='rm -I -d -v'" #Room a file? What the fu- Oh! *REMOVE*. Okay, fine. Whatever.
		"alias del='rm -I -d -v'" #Now it's even easier to delete files!
		"alias delete='rm -I -d -v'" #Don't know why I did this. I'll never type 'delete'
		"alias mv='mv -i -u -v'" #Cool, a movie program. No, wait... it's short for *move*. ... F@#k.
		"alias move='mv -i -u -v'" #There! Now it's not f@#k!ng ambiguious.
		"alias mkdir='mkdir -p'" #*Never* do I *not* want to do this.
		'alias rename='rename -v'" #No verbosity is an atrocity
		"alias df='df -h /'" #What's all that other sh!t that df prints? All I want is the disk usage of my drive.
		"alias grep='grep -i'" #Because screw you and your case sensitivity.
		"alias ls='ls -h --color=always'" #Yes I want it to be human readable. I'm not a F@#k!ng machine.
		"alias handbrake-cli='HandBrakeCLI'" #No terminal command should have capitals.
		"alias logoff='gnome-session-quit --logout --no-prompt'" #Because sometimes you just need to rage-quit.
		)
	for i in "${ALIASES[@]}" ; do
		if [ $(cat ${HOME}/.bash_aliases 2>/dev/null | grep -c "$i") -eq 0 ]; then
			echo $i >> ${HOME}/.bash_aliases #Err.. is that going to echo the above comments into the file? I dunno.
		fi
	done
fi
###########################################################################################################################
# All this sh!t does is make a .local/bin directory and add it to the $PATH
if [ ! -d ${HOME}/.local/bin ]; then mkdir ${HOME}/.local/bin; fi
export PROFILE=${HOME}/.profile
	if [ $(cat $PROFILE 2>/dev/null | grep -c "PATH=$PATH:${HOME}/.local/bin") -eq 0 ]; then
		echo "PATH=$PATH:${HOME}/.local/bin" >> $PROFILE
		echo "export PATH" >> $PROFILE
	fi
###########################################################################################################################
GTFOPKG=(
	"account-plugin-facebook" "account-plugin-flickr" "account-plugin-google" #Social media can go f@#k a duck.
 	"google-chrome-stable" "chromium-browser" #Why do I need Chrome and Chromium on the same system? I *DON'T*. That's why.
	"gnome-mahjongg" "gnome-mines" "gnome-software" "gnome-sudoku" "aisleriot" #Games? Who's got time for that sh!t?
	"gwakeonlan" "libreoffice-common" "onboard" "totem" "ubuntu-software" "shotwell" 
	"vino" "wakeonlan" "gallery-app" "webbrowser-app" #All this sh!t can GTFO too.
	"unity-scope-calculator" "unity-scope-chromiumbookmarks" "unity-scope-colourlovers" 		   #I just want an app launcher 
	"unity-scope-devhelp" "unity-scope-gdrive" "unity-scope-manpages" "unity-scope-openclipart"        #I don't want to search my files
	"unity-scope-texdoc" "unity-scope-tomboy" "unity-scope-video-remote" "unity-scope-virtualbox"      #I dont't want to search online
	"unity-scope-yelp" "unity-scope-zotero"	"unity-webapps-common" "unity-webapps-qml"		   #I don't want to install apps from the store
	"unity-scope-audacious"	"unity-scope-clementine" "unity-scope-firefoxbookmarks"                    #I don't want to play music
	"unity-scope-gmusicbrowser" "unity-scope-gourmet" "unity-scope-musicstores" "unity-scope-musique"  #Or whateverthefuck all this does
	"unity-lens-music" "unity-lens-photos" "unity-lens-video" 					   #It can all GTFO.
	"unity-control-center-signon" #unity-control-center-signon is the sum'bitch that shows as 'online accounts' in the system settings. Gotcha motherfucker.
	"xterm" "dell-super-key" "gnome-user-share" "gnome-calendar" "gnome-disk-utility" #F@#k all these packages.
	)
for PKG in "${GTFOPKG[@]}" ; do
	if [ ! $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		sudo apt purge -y --auto-remove $PKG
	fi
done
# I wonder if I could just use "sudo apt purge -y autoremove "${GTFOPKG[@]}" instead of that for loop. meh.
###########################################################################################################################
# Just making damn sure everything is updated and all cruft is gone.
sudo apt update
sudo apt -f install -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
###########################################################################################################################
#Add numix ppa. Ima use it later.
if ! grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -q numix ; then
	sudo add-apt-repository -u --yes ppa:numix/ppa
fi
#Need mailnag.
if ! grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -q mailnag ; then
	sudo add-apt-repository -u --yes ppa:pulb/mailnag
fi
###########################################################################################################################
INSTALL=(
	"numix-gtk-theme" "numix-icon-theme-circle" #Need this to replace shitty default theme.
	"ubuntu-restricted-extras" "gnome-mpv" #Video stuff. Also let's me play mp3s methinks. Why I can play mp3s outta box? dunno.
	"handbrake-cli" "handbrake" #handbrake is good program. mostly just use cli version. Not sure I need gui... meh.
	"gparted" "tilda" "firefox" "mailnag" "mailnag-unity-plugin" "compizconfig-settings-manager" #Install all these things!
	)
for PKG in "${INSTALL[@]}" ; do
	if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		sudo apt install -y $PKG 2>/dev/null
	fi
done
#Again with the for loop.. overly complicated?
###########################################################################################################################
NODSPLY=(
	"checkbox-converged.desktop" "dell-driver-installer.desktop" "dell-recovery-media.desktop"
	"display-im6.desktop" "itweb-settings.desktop" "nm-connection-editor.desktop" "openjdk-8-policytool.desktop" 
	"logout.desktop" "reboot.desktop" "shutdown.desktop" #Look, in the top right corner. Do you see the power menu? DO YOU!? Why in God's name are these in the applications menu? WHY!?
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
#Superkey no worky on Dell-XPS13. Need to remove this and make change in ccsm. Can I do it programatically? hmmm.
#################################################################################################################################
#If Chrome is gone, and is should be, get rid of these other files. This is called the Dead Horse Beater subroutine.
if [ $(dpkg-query -W -f='${Status}' google-chrome-stable 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
	rm -v ${HOME}/.gnome/apps/chrome-*-Default.desktop 2>/dev/null
	rm -v ${HOME}/.config/google-chrome/chrome_shutdown_ms.txt 2>/dev/null 
	rm -v ${HOME}/.local/share/icons/hicolor/16x16/apps/chrome-*-Default.png 2>/dev/null 
	rm -v ${HOME}/.local/share/icons/hicolor/128x128/apps/chrome-*-Default.png 2>/dev/null 
	rm -v ${HOME}/.local/share/applications/chrome-*-Default.desktop 2>/dev/null  
fi
###########################################################################################################################
#Coding 101. Lesson 1. This is how you delete examples, for example.
if [ -f ${HOME}/examples.desktop ]; then rm -v ${HOME}/examples.desktop 2>/dev/null; fi
###########################################################################################################################
gsettings set org.gnome.desktop.interface gtk-theme "Numix" #Things look better now. I'm happy.
gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle" #Even better still.
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true #Why is this not default behaviour?
gsettings set com.canonical.Unity.Launcher favorites "['application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'application://thunderbird.desktop', 'application://gedit.desktop', 'application://gnome-terminal.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
###########################################################################################################################
#Allow system to hibernate
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
echo "reboot system when done."
###########################################################################################################################
