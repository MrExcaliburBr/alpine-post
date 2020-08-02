#!/bin/sh

[[ -z "$1" ]] && echo "--user or --root"

[ $1 = "--root" ] && {
    [[ $(id -u) != 0 ]] && {
        printf "Only for 'root'.\n" "%s"
        exit 1
    }

    #Uncomment all repos, so you would be abble to use main,testing and comunity repos
    sed -i 's/#http/http/g' /etc/apk/repositories
    apk update
    
    setup-xorg-base
    #Install base packages 
    apk add git patch curl doas dbus less wpa_supplicant networkmanager make xsetroot
    doas rc-update add dbus
    dbus-uuidgen > /var/lib/dbus/machine-id

    #Libs
    apk add xf86-input-evdev xf86-input-synaptics xf86-video-fbdev xf86-video-intel mesa mesa-dri-intel 
    
    #Audio setup
    apk add alsa-utils alsa-utils-doc alsa-lib alsaconf
    rc-update add alsa
    rc-service alsa start
    
    #Extra stuff for VMs
    read -p Are you in a VM? [y/N] virt
    case $virt in
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
    
    adduser  zezin

    #doas config
    echo "permit zezin as root" >> /etc/doas.conf
    echo "permit persist zezin" >> /etc/doas.conf
    mv alpine-post /home/zezin/
}


[ $1 = "--user" ] && {
    [[ $(id -u) != 1000 ]] && {
        printf "Only for 'normal user'.\n" "%s"
        exit 1
    }
    cd /home/zezin
    mkdir ~/.local
    mkdir ~/.local/share/
    mkdir ~/.cache
    mkdir ~/pix
    mkdir ~/pix/scrot
    mkdir ~/dl
    mkdir ~/code
    mkdir ~/dox
    mkdir ~/music
    mkdir ~/.config
     
    # ~/ cleanup
    mkdir ~/.local/share/task
    touch ~/.local/share/taskrc
    mkdir ~/.config/less
    touch ~/.config/less/lesskey
    mkdir ~/.config/readline
    touch ~/.config/readline/inputrc
    mkdir ~/.local/share/zsh/
    touch ~/.local/share/zsh/history
    mkdir ~/.local/share/gnupg
    mkdir ~/.local/share/pass 
    
    #Configs
    git clone https://github.com/MrExcaliburBr/voidrice
    mv voidrice/zshrc .
    doas mv voidrice/xinitrc /etc/X11/xinit/
    mv zshrc .zshrc
    mv voidrice/config/* .config
    
    #Goodies
    doas apk add cargo sxiv nnn youtube-dl cmus xrandr dunst sxhkd xbacklight tlp unclutter-xfixes slock scrot tmux task weechat python3 zathura zathura-pdf-poppler mpv fzf gnupg pass newsboat tuir htop redshift ttf-dejavu vimb ripgrep fd
    
    #My scripts
    mkdir code/scripts
    git clone https://github.com/MrExcaliburBr/scripts code/scripts
    
    #Suckless software 
    ##Dependencies
    doas apk add tcc libx11-dev libxft-dev libxinerama-dev ncurses dbus-x11 freetype-dev gcc g++
   #TODO fix tcc linking problem  

    ##Directories
    rm -rf .config/suckless/*
    mkdir .config/suckless/dwm
    mkdir .config/suckless/st
    mkdir .config/suckless/dmenu
    
    ##dwm
    git clone https://github.com/MrExcaliburBr/my-dwm
    cd .config/suckless/dwm-flexipatch
    doas make install
    cd /home/zezin
    
    ##st
    git clone https://github.com/MrExcaliburBr/my-dwm
    cd .config/suckless/dwm-flexipatch
    doas make install
    cd /home/zezin
    
    ##dmenu 
    git clone https://git.suckless.org/dmenu .config/suckless/dmenu
    mv alpine-post/patches/dmenu-diff.diff .config/suckless/dmenu
    cd .config/suckless/dmenu
    patch < dmenu-diff.diff
    doas make install
    cd /home/zezin
    
    doas apk del gcc g++

   # #oh-my-zsh
   # curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
   # doas ZSH=~/.config/oh-my-zsh RUNZSH='no' ./install.sh --keep-zshrc
   # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
   # git clone https://github.com/softmoth/zsh-vim-mode .config/oh-my-zsh/custom/plugins/zsh-vim-mode
   # #TODO Clean home directory 
    doas apk upgrade --update-cache --available
    rm -rf voidrice
    }
