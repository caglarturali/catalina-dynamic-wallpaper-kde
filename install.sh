#!/bin/bash
set -ueo pipefail

###
# Installs Catalina Dynamic Wallpaper.
##

BIN_DIR="${HOME}/bin"
THEMES_DIR="${HOME}/.local/share/wallpapers"
AUTOSTART_DIR="${HOME}/.config/autostart"

usage() {
    printf "%s\n" "Usage: $0 [OPTIONS...]"
    printf "\n%s\n" "OPTIONS:"
    printf "  %-25s%s\n" "-k, --kde" "Install for KDE Plasma 5 environment."
    printf "  %-25s%s\n" "-d, --dde" "Install for Deepin Desktop Environment."
    printf "  %-25s%s\n" "-h, --help" "Show this help."
}

install_base() {
    echo "Installing Catalina Dynamic Wallpaper..."
    
    # Copy theme.
    [ ! -d ${THEMES_DIR} ] && mkdir -p ${THEMES_DIR}
    cp -fr CatalinaDynamic ${THEMES_DIR}
    
    [ ! -d ${BIN_DIR} ] && mkdir -p ${BIN_DIR}
    chmod +x ./bin/*
    cp -f ./bin/catalina* ${BIN_DIR}
}

install_kde() {
    cp -f ./bin/setwallpaper_kde ${BIN_DIR}/setwallpaper
}

install_dde() {
    cp -f ./bin/setwallpaper_dde ${BIN_DIR}/setwallpaper
    
    # Create autostart shortcut.
    echo "[Desktop Entry]" >                                                              ${AUTOSTART_DIR}/catalina.desktop
    echo "Encoding=UTF-8" >>                                                              ${AUTOSTART_DIR}/catalina.desktop
    echo "Type=Application" >>                                                            ${AUTOSTART_DIR}/catalina.desktop
    echo "Name=Catalina" >>                                                               ${AUTOSTART_DIR}/catalina.desktop
    echo "Comment=Catalina Dynamic Wallpaper" >>                                          ${AUTOSTART_DIR}/catalina.desktop
    echo "Exec=/home/${USER}/.config/autostart-scripts/catalina_dynamic" >>               ${AUTOSTART_DIR}/catalina.desktop
    echo "Icon=wallpaper" >>                                                              ${AUTOSTART_DIR}/catalina.desktop
    echo "Terminal=false" >>                                                              ${AUTOSTART_DIR}/catalina.desktop
    echo "Hidden=false" >>                                                                ${AUTOSTART_DIR}/catalina.desktop
    echo "NoDisplay=true" >>                                                              ${AUTOSTART_DIR}/catalina.desktop
    echo "StartupNotify=false" >>                                                         ${AUTOSTART_DIR}/catalina.desktop
    echo "X-GNOME-Autostart-enabled=true" >>                                              ${AUTOSTART_DIR}/catalina.desktop
}

install_complete() {
    # Start it.
    ${HOME}/bin/catalina --start
    echo -e "Installation complete. See \e[1m~/bin/catalina --help\e[0m for more information."
}

while [[ $# -gt 0 ]]; do
    case "${1}" in
        -k|--kde)
            install_base
            install_kde
            install_complete
            exit 0
        ;;
        -d|--dde)
            install_base
            install_dde
            install_complete
            exit 0
        ;;
        -h|--help)
            usage
            exit 0
        ;;
        *)
            echo "ERROR: Unrecognized installation option '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
        ;;
    esac
done




