cldDir=$(pwd)
cd ~
mkdir .bkupCfgs
mv ~/.config/* ~/.bkupCfgs
cat <<"EOF"
__        __   _                          _ 
\ \      / /__| | ___ ___  _ __ ___   ___| |
 \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \ |
  \ V  V /  __/ | (_| (_) | | | | | |  __/_|
   \_/\_/ \___|_|\___\___/|_| |_| |_|\___(_)
                                            
EOF

echo -e "\e[1;92m1:\e[0m Updating pacman..."
read -n 1 -p "Proceed with updates [Y,n]? "
fi
echo
[[ $REPLY != 'n' ]] && sudo pacman -Syu
huh=$?
[[ $huh != 0 ]] && echo -e "\e[1;31m1:\e[0m \e[91mSomething went wrong, Shell returned $huh :(\e[0m"

which yay > /dev/null
yaynot=$?
echo -e "\e[1;92m2:\e[0m Checking for yay... \e[1;33m$([[ $yaynot == 0 ]] && echo "(Already Installed!)")\e[0m"

if [[ $yaynot > 0 ]]; then
    echo -e "\e[1;31m:: [WARNING]\e[0m \e[91myay not installed. Installing a new one...\e[0m"
    git clone https://aur.archlinux.org/yay.git > /dev/null
    cd yay
    makepkg -si
    cd ..
fi
keycheck() {
    read -t 1 -rs -N 1 Event1
    case "$Event1" in
        [[:graph:]])    Event="$Event1" ;;
        $'\n')          Event="ENTER"   ;;
        ' ')            Event="SPACE"   ;;
        [[:blank:]])    Event="TAB"     ;;
        *)
            read -t 0.01 -rsn5 Event2
            case "$Event2" in

                "[A")           Event="UP"          ;;
                "[B")           Event="DOWN"        ;;
                "[D")           Event="LEFT"        ;;
                "[C")           Event="RIGHT"       ;;
                "[Z")           Event="SHIFT+TAB"   ;;
                "[P"|"[3~")     Event="DELETE"      ;;
                "[4h"|"[2~")    Event="INSERT"      ;;
                "[4~"|"[F")     Event="END"         ;;
                "[H"|"[1~")     Event="HOME"        ;;
                "[5~")          Event="PAGE UP"     ;;
                "[6~")          Event="PAGE DOWN"   ;;
                "OP"|"[[A")     Event="F1"          ;;
                "OQ"|"[[B")     Event="F2"          ;;
                "OR"|"[[C")     Event="F3"          ;;
                "OS"|"[[D")     Event="F4"          ;;
                "[15~"|"[[E")   Event="F5"          ;;
                "[17~")         Event="F6"          ;;
                "[18~")         Event="F7"          ;;
                "[19~")         Event="F8"          ;;
                "[20~")         Event="F9"          ;;
                "[21~")         Event="F10"         ;;
                "[23~")         Event="F11"         ;;
                "[24~")         Event="F12"         ;;

                *)
                    case "$Event1$Event2" in 
                        $'\E')      Event="ESCAPE"      ;;
                        $'\177')  Event="BACKSPACE"     ;;
                        *) Event="Unknown"              ;;
                    esac
                    ;;
            esac
    esac
    echo $Event
}
echo -e "\e[1;92m3:\e[0m GPU Drivers"
echo
choice=0
prevchoice=0
while [[ $choice != -1 ]]; do
    case "$(keycheck)" in
        "UP"|"LEFT"|"SHIFT+TAB")
            if [[ $choice == 0 ]]; then
                choice=2
            else
                choice=$(expr $choice - 1)
            fi
        ;;
        "DOWN"|"RIGHT"|"TAB")
            if [[ $choice == 2 ]]; then
                choice=0
            else
                choice=$(expr $choice + 1)
            fi
        ;;
        "ENTER"|"SPACE") choice=-1 ;;
    esac
    case "$choice" in
        0) echo -ne "\e[1;92mAMD\e[0m\tNvidia\tCancel\r" ;;
        1) echo -ne "AMD\t\e[1;92mNvidia\e[0m\tCancel\r" ;;
        2) echo -ne "AMD\tNvidia\t\e[1;92mCancel\e[0m\r" ;;
        -1)
            case "$prevchoice" in
                0) sudo pacman -S mesa ;;
                1) 
                    sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils egl-wayland libva-nvidia-driver
                    echo ":: Editing /etc/mkinitcpio.conf"
                    sudo sed -i -e "s#MODULES=()#MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)#" /etc/mkinitcpio.conf
                    sudo echo "options nvidia_drm modeset=1 fbdev=1" > /etc/modprobe.d/nvidia.conf
                    sudo mkinitcpio -P
                    echo -e "env = LIBVA_DRIVER_NAME,nvidia\nenv = __GLX_VENDOR_LIBRARY_NAME,nvidia\nenv = NVD_BACKEND,direct\ncursor {\n    no_hardware_cursors = true\n}" > ~/.config/hypr/hyprland.conf
                ;;
            esac
        ;;
    esac
    prevchoice=$choice
done
echo

echo -e "\e[1;92m4:\e[0m \e[92mInstalling everything [My favorite part :)]\e[0m"

yay -S \
    hyprland hyprlock xdg-desktop-portal-hyprland xdg-desktop-portal-gtk kitty \
    thunar neovim firefox \
    hyprshot wf-recorder \
    gnome-clocks gnome-calendar gnome-calculator snapshot gnome-characters gnome-connections gnome-disk-utility loupe gnome-maps gnome-music gnome-weather totem \
    rofi-wayland \
    ttf-cascadia-code ttf-cascadia-code-nerd ttf-segoe-ui-variable \
    pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-jack pamixer pavucontrol \
    pacman-contrib \
    networkmanager nm-connection-editor \
    pipewire wireplumber \
    power-profiles-daemon \
    figlet qt5-wayland qt6-wayland

huh=$?
if [[ $huh != 0 ]]; then
    echo -e "\e[1;31m[ERROR]\e[0m \e[91mThe install did not go to plan. Shell returned $huh :(\e[0m"
    echo -e "\e[1;33m[WARNING]\e[0m \e[93mLet's hope nothing goes wrong from now on\e[0m"
fi

echo
echo -e "\e[94m$(figlet "HyprPanel dependencies")\e[0m"
echo

curl -fsSL https://bun.sh/install | bash; sudo ln -s $HOME/.bun/bin/bun /usr/local/bin/bun

yay -S hyprpicker matugen hyprsunset-git hypridle-git libgtop bluez bluez-utils btop cmake rust dart-sass wl-clipboard brightnessctl swww python gnome-bluetooth-3.0 power-profiles-daemon gvfs ripgrep luarocks wget npm bluetoothctl zip unzip


echo
echo "\e[94m$(figlet "Hyprspace")\e[0m"
echo

git clone https://github.com/KZDKM/Hyprspace.git; cd Hyprspace; make all; cd ..;

echo ":: Don't mind if I give your gtk a 'deprecated' catppuccin mocha look :)"
git clone https://github.com/catppuccin/gtk; cd gtk; python install.py mocha blue; cd ..; rm -rf gtk

echo ":: Intalling HyprPanel"
git clone https://github.com/Jas-Singh-FSU/HyprPanel.git; ~/HyprPanel/make_agsv1.sh; ln -s ~/HyprPanel ~/.config/ags

echo -e "\e[3mAnd finally...\e[0m"
figlet "My Configuration"
echo
echo ":: Setup is copying files..."

if [[ -e "~/.config/hypr/hyprland.conf" ]]; then
    echo -e "$(cat $cldDir/.files/hypr/hyprland.conf)\n$(cat ~/.config/hypr/hyprland.conf)" > ~/.config/hypr/hyprland.conf
    rm $cldDir/.files/hypr/hyprland.conf
fi
cp -r "$cldDir/.files/*" "$HOME/.config"

echo ":: Done! Will reboot in 5 seconds..."
sleep 5
reboot
