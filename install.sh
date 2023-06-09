#!/usr/bin/env bash

configurePacman() {
    echo "Configuring pacman"
    sudo sed -i "s/#Color/Color/g" /etc/pacman.conf
    sudo sed -i "s/#VerbosePkgLists/VerbosePkgLists/g" /etc/pacman.conf
    sudo sed -i "s/#ParallelDownloads/ParallelDownloads/g" /etc/pacman.conf
    yes | sudo pacman -Syu
}

installPackages() {
    echo "Installing packages"
    sudo pacman -S --needed base-devel cmake git bash-completion yay mc kvantum kvantum-theme-matcha htop matcha-gtk-theme ttf-dejavu oxygen || exit
    yes | yay -S --needed xfce4-dpr-changer-git
}

configureUserData() {
    echo "Configuring user data"
    if [[ -f "$HOME/.profile" ]]; then
        sed -i '/QT_QPA_PLATFORMTHEME/d' "$HOME/.profile" # We don't use it
        sed -i '/EDITOR/d' "$HOME/.profile" # We have EDITOR in /etc/environment
    fi

    grep "getGitBranch" "$HOME/.bashrc" > /dev/null
    if [[ $? != 0 ]]; then
        echo -n "Do you want to set git info in bash prompt? [y/N] "
        read response
        if [[ $response == 'y' || $response == 'Y' ]]; then
            cat "data/git.bashrc" >> "$HOME/.bashrc"
        fi
    fi

    echo -n "Do you want to load xfce4-terminal configuration? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        cp -r "data/terminal" "$HOME/.config/xfce4"
    fi

    echo -n "Do you want to load Kvantum configuration? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        cp -r "data/Kvantum" "$HOME/.config"
    fi

    sudo rm -f /etc/fonts/conf.d/10-sub-pixel-rgb.conf
}

function xfce4Settings()
{
    echo "Configuring Xfce4"

    dconf write /org/blueman/plugins/powermanager/auto-power-on false # Blueman

    WINDOW_SCALING_FACTOR=$(xfconf-query -c xsettings -p /Gdk/WindowScalingFactor)

    xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Oxygen_Zion"
    xfconf-query -c xsettings -p /Gtk/DecorationLayout -s "close,minimize,maximize:menu"
    xfconf-query -c xsettings -p /Gtk/FontName -s "DejaVu Sans 10"
    xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "DejaVu Sans Mono 10"

    xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
    xfconf-query -c xsettings -p /Net/ThemeName -s "Matcha-dark-azul"

    xfconf-query -c xsettings -p /Xft/HintStyle -s "hintslight"

    xfconf-query -c thunar -p /misc-date-style -s "THUNAR_DATE_STYLE_SHORT"
    xfconf-query -c thunar -p /misc-highlighting-enabled -s false -t bool -n

    xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -s false -t bool -n
    xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -s false -t bool -n
    xfconf-query -c xfce4-desktop -p /desktop-icons/primary -s true -t bool -n
    xfconf-query -c xfce4-desktop -p /desktop-icons/show-tooltips -s false -t bool -n
    xfconf-query -c xfce4-desktop -p /desktop-menu/show-delete -s false -t bool -n

    xfconf-query -c xfwm4 -p /general/workspace_count -s 2

    # Xfwm4 settings
    if [[ $WINDOW_SCALING_FACTOR == 2 ]]; then
        xfconf-query -c xfwm4 -p /general/theme -s "Matcha-dark-azul-hdpi"
    else
        xfconf-query -c xfwm4 -p /general/theme -s "Matcha-dark-azul"
    fi
    xfconf-query -c xfwm4 -p /general/title_font -s "DejaVu Sans Bold 9"
    xfconf-query -c xfwm4 -p /general/title_alignment -s "center"
    xfconf-query -c xfwm4 -p /general/button_layout -s "CHM|O"

    xfconf-query -c xfwm4 -p /general/click_to_focus -s true
    xfconf-query -c xfwm4 -p /general/focus_new -s true
    xfconf-query -c xfwm4 -p /general/raise_on_focus -s true
    xfconf-query -c xfwm4 -p /general/raise_on_click -s true

    xfconf-query -c xfwm4 -p /general/snap_to_border -s true
    xfconf-query -c xfwm4 -p /general/snap_to_windows -s true
    xfconf-query -c xfwm4 -p /general/snap_width -s 9
    xfconf-query -c xfwm4 -p /general/wrap_workspaces -s false
    xfconf-query -c xfwm4 -p /general/wrap_windows -s false
    xfconf-query -c xfwm4 -p /general/box_move -s false
    xfconf-query -c xfwm4 -p /general/box_resize -s false
    xfconf-query -c xfwm4 -p /general/double_click_action -s "maximize"

    # Xfwm4 tweaks
    xfconf-query -c xfwm4 -p /general/cycle_minimum -s true
    xfconf-query -c xfwm4 -p /general/cycle_minimized -s false
    xfconf-query -c xfwm4 -p /general/cycle_hidden -s true
    xfconf-query -c xfwm4 -p /general/cycle_workspaces -s false
    xfconf-query -c xfwm4 -p /general/cycle_draw_frame -s true
    xfconf-query -c xfwm4 -p /general/cycle_raise -s false
    xfconf-query -c xfwm4 -p /general/cycle_tabwin_mode -s 1

    xfconf-query -c xfwm4 -p /general/prevent_focus_stealing -s false
    xfconf-query -c xfwm4 -p /general/focus_hint -s true
    xfconf-query -c xfwm4 -p /general/activate_action -s "switch"

    xfconf-query -c xfwm4 -p /general/easy_click -s "Mod4"
    xfconf-query -c xfwm4 -p /general/raise_with_any_button -s false
    xfconf-query -c xfwm4 -p /general/borderless_maximize -s true
    xfconf-query -c xfwm4 -p /general/titleless_maximize -s false
    xfconf-query -c xfwm4 -p /general/tile_on_move -s true
    xfconf-query -c xfwm4 -p /general/snap_resist -s true
    xfconf-query -c xfwm4 -p /general/mousewheel_rollup -s false
    xfconf-query -c xfwm4 -p /general/urgent_blink -s false

    xfconf-query -c xfwm4 -p /general/scroll_workspaces -s false
    xfconf-query -c xfwm4 -p /general/toggle_workspaces -s false
    xfconf-query -c xfwm4 -p /general/wrap_layout -s false
    xfconf-query -c xfwm4 -p /general/wrap_cycle -s false

    xfconf-query -c xfwm4 -p /general/placement_mode -s "center"
    xfconf-query -c xfwm4 -p /general/placement_ratio -s 20

    xfconf-query -c xfwm4 -p /general/use_compositing -s false

    # Xfwm4 key bindings
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_1" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_2" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_3" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_4" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_5" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_6" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_7" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_8" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>KP_9" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>Up" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Super>Up" -n -t string -s "tile_up_key"
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>Down" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Super>Down" -n -t string -s "tile_down_key"
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>Left" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Super>Left" -n -t string -s "tile_left_key"
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>Right" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Super>Right" -n -t string -s "tile_right_key"
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>d" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Super>d" -n -t string -s "show_desktop_key"
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Alt>Insert" -r
    xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Alt>Delete" -r
}

function configureSystem()
{
    echo "Setting MAKEFLAGS"
    printf "export MAKEFLAGS=-j\$((\$(nproc)))\n" | sudo tee /etc/profile.d/makeflags.sh > /dev/null

    echo "Setting 'nice' limits"
    sudo install -D -m 644 "data/limits-99-nice.conf" "/etc/security/limits.d/99-nice.conf"

    echo -n "Do you want to configure systemd? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        echo "Disabling coredump"
        sudo mkdir -p /etc/systemd/coredump.conf.d
        printf "[Coredump]\nStorage=none\nCompress=no\n" | sudo tee /etc/systemd/coredump.conf.d/custom.conf > /dev/null

        echo "Disabling man-db service and man-db timer"
        sudo systemctl mask man-db.service man-db.timer

        echo "Disabling /tmp tmpfs"
        sudo systemctl mask tmp.mount
    fi

    echo -n "Do you want to load sysctl config? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        echo "Loading sysctl config"
        sudo install -D -m 644 "data/sysctl.conf" "/etc/sysctl.d/50-default.conf"
    fi

    echo -n "Do you want to load environment config? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        echo "Loading environment config"
        sudo install -D -m 644 "data/environment" "/etc/environment"
    fi

    echo -n "Do you want to set realtime for pipewire? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        echo "Loading pipewire config"
        sudo install -D -m 644 "data/pipewire-client-rt.conf" "/etc/pipewire/client.conf.d/client-rt.conf"
    fi

    echo -n "Do you want to install pacman orphans hook? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        sudo install -D -m 644 data/orphans.hook /etc/pacman.d/hooks/orphans.hook
    fi
}

function installOtherPackages
{
    echo -n "Do you want to install pipewire? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        yes | sudo pacman -S --needed wireplumber manjaro-pipewire rtkit realtime-privileges pipewire-v4l2 pipewire-pulse pipewire-jack lib32-pipewire
        yes | sudo pacman -R pulseaudio-alsa 2> /dev/null
    fi

    echo -n "Do you want to install VA-API and Vulkan opensource drivers? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        yes | sudo pacman -S --needed vulkan-intel lib32-vulkan-intel vulkan-radeon vulkan-mesa-layers lib32-vulkan-radeon lib32-vulkan-mesa-layers libva-mesa-driver libva-intel-driver intel-media-driver libva-utils
    fi

    echo -n "Do you want to install other packages? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        yes | sudo pacman -S --needed mesa-utils vulkan-tools pavucontrol helvum seahorse qalculate-gtk ksysguard spectacle kimageformats kcolorchooser okteta kolourpaint kwrite kate easyeffects remmina lib32-libpulse engrampa pluma
        yes | sudo pacman -R mousepad
    fi

    echo -n "Do you want to install xfce4-mate-applet-loader-plugin? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        yes | sudo pacman -S --needed mate-applets mate-sensors-applet
        yes | yay -S --needed xfce4-mate-applet-loader-plugin-git
    fi

    echo -n "Do you want to install QDRE Compositor? [y/N] "
    read response
    if [[ $response == 'y' || $response == 'Y' ]]; then
        yes | yay -S --needed qdre-compositor-git qdre-compositor-autostart
        dconf write /org/qdre/compositor/prevent-window-transparency-exceptions "['Mozilla Firefox$', 'Chromium$']"
    fi
}

export LANG=C # Needed for "yes"

echo -n "It will change your system behavior! Start script? [y/N] "
read response
if [[ $response != 'y' && $response != 'Y' ]]; then
    exit
fi

configurePacman
installPackages
configureUserData
xfce4Settings
installOtherPackages
configureSystem

echo "Please reboot the computer!"
