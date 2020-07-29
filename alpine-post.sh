#!/bin/sh
    #Uncomment all repos, so you would be abble to use main,testing and comunity repos
    sed -i 's/#http/http/g' /etc/apk/repositories
    apk update
    
    setup-xorg-minimal
    #Install base packages 
    apk add git patch curl doas dbus less wpa_supplicant networkmanager make 
    
    #Libs
    apk add xf86-input-evdev xf86-input-synaptics xf86-video-fbdev xf86-video-intel mesa mesa-dri-intel 
    
    #Audio setup
    apk add alsa-utils alsa-utils-doc alsa-lib alsaconf
    rc-update add alsa
    rc-service alsa start
    
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
    
adduser  zezin

#doas config
echo "permit zezin as root" >> /etc/doas.conf
echo "permit persist zezin" >> /etc/doas.conf

#Nescessary directories
#TODO tirar os su zezin -c e dividir o script --root e --user (talvez, depois desse teste )

su zezin -c "cd /home/zezin"
su zezin -c "mkdir ~/.local"
su zezin -c "mkdir ~/.local/share/"
su zezin -c "mkdir ~/.cache"
su zezin -c "mkdir ~/pix"
su zezin -c "mkdir ~/pix/scrot"
su zezin -c "mkdir ~/dl"
su zezin -c "mkdir ~/code"
su zezin -c "mkdir ~/dox"
su zezin -c "mkdir ~/music"
su zezin -c "mkdir ~/.config"
 
# ~/ cleanup
su zezin -c "mkdir ~/.local/share/task"
su zezin -c "touch ~/.local/share/taskrc"
su zezin -c "mkdir ~/.config/less"
su zezin -c "touch ~/.config/less/lesskey"
su zezin -c "mkdir ~/.config/readline"
su zezin -c "touch ~/.config/readline/inputrc"
su zezin -c "mkdir ~/.local/share/zsh/"
su zezin -c "touch ~/.local/share/zsh/history"
su zezin -c "mkdir ~/.local/share/gnupg"
su zezin -c "mkdir ~/.local/share/pass" 

#Configs
su zezin -c "git clone https://github.com/MrExcaliburBr/voidrice"
su zezin -c "mv voidrice/zshrc ."
su zezin -c "doas mv voidrice/xinitrc /etc/X11/xinit/"
su zezin -c "mv zshrc .zshrc"
su zezin -c "mv voidrice/config/* .config"

#Goodies
su zezin -c "doas apk add sxiv nnn youtube-dl cmus xrandr dunst sxhkd xbacklight tlp unclutter-xfixes slock scrot tmux task transmission weechat python3 zathura zathura-pdf-poppler mpv fzf gnupg pass newsboat tuir htop redshift "
su zezin -c "doas rc-update add dbus"
dbus-uuidgen > /var/lib/dbus/machine-id

#My scripts
su zezin -c "mkdir code/scripts"
su zezin -c "git clone https://github.com/MrExcaliburBr/scripts code/scripts"

#Suckless software 
##Dependencies
su zezin -c "doas apk add tcc libx11-dev libxft-dev libxinerama-dev ncurses dbus-x11 freetype-dev gcc g++"
su zezin -c "doas apk del gcc g++"

##Directories
su zezin -c "rm -rf .config/suckless/*"
su zezin -c "mkdir .config/suckless/dwm" 
su zezin -c "mkdir .config/suckless/st"
su zezin -c "mkdir .config/suckless/dmenu"

##dwm
su zezin -c "git clone https://github.com/MrExcaliburBr/my-dwm .config/suckless/dwm"
su zezin -c "cd .config/suckless/dwm"
su zezin -c "doas make install CC=tcc"
su zezin -c "cd /home/zezin"

##st
su zezin -c "git clone https://github.com/MrExcaliburBr/my-st .config/suckless/st"
su zezin -c "cd .config/suckless/st"
su zezin -c "doas make install CC=tcc"
su zezin -c "cd /home/zezin"

##dmenu 
su zezin -c "git clone https://github.com/MrExcaliburBr/my-dmenu .config/suckless/dmenu"
su zezin -c "cd .config/suckless/dmenu"
su zezin -c "doas make install CC=tcc"
su zezin -c "cd /home/zezin"

#tremc (transmission client)
su zezin -c "mkdir .config/gitstuff"
su zezin -c "mkdir .config/gitstuff/tremc"
su zezin -c "git clone https://github.com/tremc/tremc .config/gitstuff/tremc"
su zezin -c "cd tremc"
su zezin -c "doas make install"
su zezin -c "cd /home/zezin"

#straw-viewer
su zezin -c "mkdir .config/gitstuff/straw-viewer"
su zezin -c "doas apk add perl"
su zezin -c "git clone https://github.com/trizen/straw-viewer .config/gitstuff/straw-viewer"
su zezin -c "cd .config/gitstuff/straw-viewer"
su zezin -c "perl Build.PL"
su zezin -c "./Build installdeps"
su zezin -c "./Build install"
su zezin -c "cd /home/zezin"

#oh-my-zsh
su zezin -c "curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
su zezin -c "ZSH=~/.config/oh-my-zsh RUNZSH='no' ./install.sh --keep-zshrc"
su zezin -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
su zezin -c "git clone https://github.com/softmoth/zsh-vim-mode .config/oh-my-zsh/custom/plugins/zsh-vim-mode"
#TODO Clean home directory 

