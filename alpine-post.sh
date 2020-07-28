#!/bin/sh
    #Uncomment all repos, so you would be abble to use main,testing and comunity repos
    sed -i 's/#http/http/g' /etc/apk/repositories
    apk update
    
    #Install base packages 
    apk add git patch curl doas man man-pages less wpa_supplicant networkmanager 
    
    #Libs
    apk add xf86-input-evdev xf86-input-synaptics xf86-video-fbdev xf86-video-intel mesa mesa-dri-intel 
    
    #Audio setup
    apk add alsa-utils alsa-utils-doc alsa-lib alsaconf
    rc-service alsa start
    rc-update add alsa
    
    #Extra stuff for VMs
    read -p "Are you in a VM? [y/N]" virt
    case "$virt" in
        n|N ) rc-update delete dhcpcd default
	      rc-update add NetworkManager
	      ;;
        y|Y ) apk add xf86-video-vboxvideo virtualbox-guest-additions virtualbox-guest-modules-virt virtualbox-guest-additions-openrc xf86-input-synaptics xf86-video-vesa
    	      echo vboxpci >> /etc/modules
              echo vboxdrv >> /etc/modules
              echo vboxnetflt >> /etc/modules
              rc-update add virtualbox-guest-additions default
    	      apk upgrade --update-cache --available
    	      ;;
    esac
    
#Add user
adduser -h /home/zezin zezin

#doas config
cat "permit zezin as root" >> /etc/doas.conf
cat "permit persist zezin" >> /etc/doas.conf

#Nescessary directories
su -c "mkdir ~/.local" zezin
su -c "mkdir ~/.local/share/" zezin
su -c "mkdir ~/.cache" zezin
su -c "mkdir ~/pix" zezin
su -c "mkdir ~/pix/scrot" zezin
su -c "mkdir ~/dl" zezin
su -c "mkdir ~/code" zezin
su -c "mkdir ~/dox" zezin
su -c "mkdir ~/music" zezin
su -c "mkdir ~/.config" zezin
su -c "mkdir ~/.vim" zezin
 
# ~/ cleanup
su -c "mkdir ~/.local/share/task" zezin
su -c "touch ~/.local/share/taskrc" zezin
su -c "mkdir ~/.config/less" zezin
su -c "touch ~/.config/less/lesskey" zezin
su -c "mkdir ~/.config/readline" zezin
su -c "touch ~/.config/readline/inputrc" zezin
su -c "mkdir ~/.local/share/zsh/" zezin
su -c "touch ~/.local/share/zsh/history" zezin
su -c "mkdir ~/.local/share/gnupg" zezin
su -c "mkdir ~/.local/share/pass" zezin 

#Configs
su -c "git clone https://github.com/MrExcaliburBr/voidrice" zezin
su -c "mv voidrice/zshrc ." zezin
su -c "doas mv voidrice/xinitrc /etc/X11/xinit/" zezin
su -c "mv zshrc .zshrc" zezin
su -c "mv voidrice/config/* .config" zezin

#Goodies
su -c "doas apk add dbus sxiv nnn youtube-dl cmus xrandr qutebrowser dunst sxhkd xbacklight tlp unclutter-xfixes slock scrot tmux task transmission weechat python3 zathura zathura-pdf-poppler mpv fzf gnupg pass newsboat tuir htop redshift " zezin
su -c "rc-update add dbus" zezin
su -c "dbus-uuidgen > /var/lib/dbus/machine-id" zezin

#Suckless software 
##Dependencies
su -c "apk add tcc libx11-dev libxft-dev libxinerama-dev ncurses dbus-x11 freetype-dev" zezin

##Directories
su -c "rm -rf .config/suckless/*" zezin
su -c "mkdir .config/suckless/dwm-flexipatch" zezin 
su -c "mkdir .config/suckless/st-flexipatch" zezin
su -c "mkdir .config/suckless/dmenu" zezin

##dwm
su -c "git clone https://github.com/bakkeby/flexipatch-finalizer" zezin
su -c "mv flexipatch-finalizer/flexipatch-finalizer.sh ." zezin
su -c "rm -rf flexipatch-finalizer" zezin
su -c "git clone https://github.com/bakkeby/dwm-flexipatch .config/suckless/dwm-flexipatch" zezin
su -c "rm .config/suckless/dwm-flexipatch/patches.def.h" zezin
su -c "mv alpine-post/patches/dwm-patches alpine-post/patches/patches.def.h" zezin
su -c "mv alpine-post/patches/patches.def.h .config/suckless/dwm-flexipatch" zezin
su -c "cd .config/suckless/dwm-flexipatch" zezin
#TODO test with mk instead of make 
su -c "doas make install CC=tcc" zezin
su -c "cd /home/zezin/" zezin 
su -c "./flexipatch-finalizer.sh -r -d .config/suckless/dwm-flexipatch -o .config/suckless/dwm" zezin
su -c "cd .config/suckless/dwm" zezin
su -c "doas make install CC=tcc" zezin
su -c "cd /home/zezin/" zezin
su -c "rm -rf .config/suckless/dwm-flexipatch" zezin

##st
su -c "git clone https://github.com/bakkeby/st-flexipatch" zezin
su -c "rm .config/suckless/st-flexipatch/patches.def.h" zezin
su -c "mv alpine-post/patches/st-patches alpine-post/patches/patches.def.h" zezin
su -c "mv alpine-post/patches/patches.def.h .config/suckless/st-flexipatch" zezin
su -c "cd .config/suckless/st-flexipatch" zezin
su -c "doas make install CC=tcc" zezin
su -c "cd /home/zezin/" zezin
su -c "./flexipatch-finalizer.sh -r -d .config/suckless/st-flexipatch -o .config/suckless/st" zezin
su -c "cd .config/suckless/dwm" zezin
su -c "doas make install CC=tcc" zezin
su -c "cd /home/zezin/" zezin
su -c "rm -rf .config/suckless/st-flexipatch" zezin

##dmenu 
su -c "git clone git://git.suckless.org/dmenu .config/suckless/dmenu" zezin
su -c "rm .config/suckless/dmenu/config.def.h" zezin
su -c "mv alpine-post/patches/dmenu-diff.diff .config/suckless/dmenu" zezin
su -c "cd .config/suckless/dmenu" zezin
su -c "patch dmenu-diff.diff" zezin
su -c "doas make install CC=tcc" zezin
su -c "cd /home/zezin" zezin

#tremc (transmission client)
su -c "mkdir .config/gitstuff" zezin
su -c "mkdir .config/gitstuff/tremc" zezin
su -c "git clone https://github.com/tremc/tremc .config/gitstuff/tremc" zezin
su -c "cd tremc" zezin
su -c "doas make install" zezin
su -c "cd /home/zezin" zezin

#straw-viewer
su -c "mkdir .config/gitstuff/straw-viewer" zezin
su -c "doas apk add perl" zezin
su -c "git clone https://github.com/trizen/straw-viewer .config/gitstuff/straw-viewer" zezin
su -c "cd .config/gitstuff/straw-viewer" zezin
su -c "perl Build.PL" zezin
su -c "./Build installdeps" zezin
su -c "./Build install" zezin
su -c "cd /home/zezin" zezin

#oh-my-zsh
su -c "curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" zezin
su -c "ZSH=~/.config/oh-my-zsh RUNZSH='no' ./install.sh --keep-zshrc" zezin
su -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting" zezin
su -c "git clone https://github.com/softmoth/zsh-vim-mode .config/oh-my-zsh/custom/plugins/zsh-vim-mode" zezin
#TODO Clean home directory 

