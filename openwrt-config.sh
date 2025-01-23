#! /bin/sh
# License: CC0
# OpenWrt >= 19.07

BASE_URL="https://raw.githubusercontent.com/site-u2023/config-software2/main/"
BASE_DR="/etc/config-software/"

wget --no-check-certificate -O "${BASE_DR}maine_colors.sh" "${BASE_URL}maine_colors.sh"

. "${BASE_DR}maine_colors.sh"

download_and_execute() {
    local script_name="$1"
    local url="$2"
    echo "$(color "blue" "Downloading and executing: ${script_name}")"
    wget --no-check-certificate -O "${BASE_DR}${script_name}" "${url}"
    sh "${BASE_DR}${script_name}"
}

menu_option() {
    local description="$1"
    local script_name="$2"
    local url="$3"
    while :; do
        echo "$(color "white" "${description}")"
        read -p "$(color "cyan" "Do you want to proceed? [y/n]: ")" choice
        case "${choice}" in
            "y") download_and_execute "${script_name}" "${url}"; break ;;
            "n") break ;;
        esac
    done
}

delete_and_exit() {
    echo "$(color "red" "Deleting script and exiting.")"
    rm -rf "${BASE_DR}" /usr/bin/confsoft
    exit
}

check_openwrt_version() {
    local supported_versions="19 21 22 23 24"
    local release=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
    if echo "${supported_versions}" | grep -q "${release}"; then
        echo "$(color "white" "OpenWrt version: ${release} - Supported")"
    else
        echo "$(color "red" "Unsupported OpenWrt version: ${release}")"
        echo "$(color "white" "Supported versions: ${supported_versions}")"
        exit 1
    fi
}

color_code() {
for i in `seq 30 38` `seq 40 47` ; do
    for j in 0 1 2 3 4 5 6 7 ; do
        printf "\033[${j};${i}m"
        printf " ${j};${i} "
        printf "\033[0;39;49m"
        printf " "
    done
    printf "\n"
done
}

display_system_info() {
    local available_memory=$(free | awk '/Mem:/ { print int($4 / 1024) }')
    local available_flash=$(df | awk '/overlayfs:\/overlay/ { print int($4 / 1024) }')
    local usb_devices=$(ls /sys/bus/usb/devices | grep -q usb && echo "Detected" || echo "Not detected")

    echo "$(color "white" "OpenWrt-Config Information")"
    echo "$(color "white" "Available Memory: ${available_memory} MB")"
    echo "$(color "white" "Available Flash Storage: ${available_flash} MB")"
    echo "$(color "white" "USB Devices: ${usb_devices}")"
    echo "$(color "red_white" "Disclaimer: Use this script at your own risk.")"
}

echo "$(color "white" "OpenWrt Configuration Menu")"
echo "$(color "blue" "[i]: Internet Configuration (Japan Only)")"
echo "$(color "yellow" "[s]: Initial System Setup")"
echo "$(color "green" "[p]: Install Recommended Packages")"
echo "$(color "magenta" "[b]: Install and Configure Ad Blocker")"
echo "$(color "red" "[a]: Configure Access Point")"
echo "$(color "cyan" "[e]: Execute Other Scripts")"
echo "$(color "white" "[q]: Exit the Script")"
echo "$(color "white_black" "[d]: Delete the Script and Exit")"



main_menu() {
    while :; do
        echo "$(color "white" "-------------------------------------------------------")"
        echo "$(color "white" "OpenWrt Configuration Menu")"
        echo "$(color "blue" "[i]: Internet Configuration (Japan Only)")"
        echo "$(color "yellow" "[s]: Initial system setup")"
        echo "$(color "green" "[p]: Install recommended packages")"
        echo "$(color "magenta" "[b]: Install and Configure Ad Blocker")"
        echo "$(color "red" "[a]: Configure access point")"
        echo "$(color "cyan" "[o]: Execute other scripts")"
        echo "$(color "white" "[e]: Exit the Script")"
        echo "$(color "white_black" "[d]: Delete scripts and exit")"
        echo "$(color "white" "-------------------------------------------------------")"
        read -p "$(color "white" "Select an option: ")" option
        case "${option}" in
            "i") menu_option "Internet Configuration (Japan Only)" "internet-config.sh" "${BASE_URL}internet-config.sh" ;;
            "s") menu_option "Initial system setup" "system-config.sh" "${BASE_URL}system-config.sh" ;;
            "p") menu_option "Install recommended packages" "package-config.sh" "${BASE_URL}package-config.sh" ;;
            "b") menu_option "Install and Configure Ad Blocker" "ad-dns-blocking-config.sh" "${BASE_URL}ad-dns-blocking-config.sh" ;;
            "a") menu_option "Configure access point" "accesspoint-config.sh" "${BASE_URL}accesspoint-config.sh" ;;
            "o") menu_option "Execute other scripts" "etc-config.sh" "${BASE_URL}etc-config.sh" ;;
            "e") exit ;;
            "d") delete_and_exit ;;
        esac
    done
}

check_openwrt_version
color_code
display_system_info
main_menu
