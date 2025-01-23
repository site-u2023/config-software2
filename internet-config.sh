#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

BASE_URL="https://raw.githubusercontent.com/site-u2023/config-software2/main/"
BASE_DR="/etc/config-software2/"

. "${BASE_DR}main_colors.sh"

# Define Language Selections
LANGUAGES='"en" "ja" "cn"'
SELECTED_LANGUAGE="ja"  # Default language

map_e() {

# Set language-dependent text for menu
if [ "${SELECTED_LANGUAGE}" = "en" ]; then
    exit
elif [ "${SELECTED_LANGUAGE}" = "ja" ]; then
    NEMU000="要HGW直結"
    MENU0="OCNバーチャルコネクト・V6プラス・IPv6オプション"
    MENU1="OCNバーチャルコネクト・V6プラス・IPv6オプション自動設定（マルチセッション対応）"
    MENU2="OCNバーチャルコネクト・V6プラス・IPv6オプション設定削除及び以前の設定復元"
    MENU00="戻る"
elif [ "${SELECTED_LANGUAGE}" = "cn" ]; then
    exit
fi

TARGET1="map_e"
TARGET2="map_e_nuro"
TARGET00="exit"
	
 while :; do
    echo -e "$(color "white" "-------------------------------------------------------")"
    echo -e "$(color "blue" "[s]: ${MENU1}")"
    echo -e "$(color "red" "[r]: ${MENU2}")"
    echo -e "$(color "white" "[b]: ${MENU00}")"
    echo -e "$(color "white" "-------------------------------------------------------")"
    read -p "$(color "white" "Select an option: ")" option
    case "${option}" in
        "s") menu_option ${TARGET1} ;;
        "r") menu_option ${TARGET2} ;;
        "b") exit ;;
        *) echo "$(color "red" "Invalid option. Please try again.")" ;;
    esac
done
}

# Check OpenWrt version
check_openwrt_version() {
    local supported_versions="19 21 22 23 24 SN"
    local release=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
    if echo "${supported_versions}" | grep -q "${release}"; then
        echo -e "$(color "white" "OpenWrt version: ${release} - Supported")"
    else
        echo -e "$(color "red" "Unsupported OpenWrt version: ${release}")"
        echo -e "$(color "white" "Supported versions: ${supported_versions}")"
        exit 1
    fi
}

main_menu() {

# Set language-dependent text for menu
if [ "${SELECTED_LANGUAGE}" = "en" ]; then
    exit
elif [ "${SELECTED_LANGUAGE}" = "ja" ]; then
    MENU0="インターネット設定"
    MENU1="OCNバーチャルコネクト・V6プラス・IPv6オプション自動設定（マルチセッション対応）"
    MENU2="NURO光 MAP-e自動設定 (一部のみ対応：検証中)"
    MENU3="トランジックス自動設定"
    MENU4="クロスパス自動設定"  
    MENU5="v6 コネクト自動設定" 
    MENU6="PPPoE (iPv4・IPv6): 要認証ID (ユーザー名)・パスワード"
    MENU00="戻る"
elif [ "${SELECTED_LANGUAGE}" = "cn" ]; then
    exit
fi

TARGET1="map_e"
TARGET2="map_e_nuro"
TARGET3="ds_lite_transix"
TARGET4="ds_lite_xpass"
TARGET5="ds_lite_v6connect"
TARGET6="pppoe"
TARGET00="exit"
	
 while :; do
    echo -e "$(color "white" "-------------------------------------------------------")"
    echo -e "$(color "white" "${MENU0}")"
    echo -e "$(color "blue" "[m]: ${MENU1}")"
    echo -e "$(color "yellow" "[n]: ${MENU2}")"
    echo -e "$(color "green" "[t]: ${MENU3}")"
    echo -e "$(color "magenta" "[x]: ${MENU4}")"
    echo -e "$(color "red" "[v]: ${MENU5}")"
    echo -e "$(color "cyan" "[p]: ${MENU6}")"
    echo -e "$(color "white" "[b]: ${MENU00}")"
    echo -e "$(color "white" "-------------------------------------------------------")"
    read -p "$(color "white" "Select an option: ")" option
    case "${option}" in
        "m") menu_option ${TARGET1} ;;
        "n") menu_option ${TARGET2} ;;
        "t") menu_option ${TARGET3} ;;
        "x") menu_option ${TARGET4} ;;
        "v") menu_option ${TARGET5} ;;
        "p") menu_option ${TARGET6} ;;
        "b") exit ;;
        *) echo "$(color "red" "Invalid option. Please try again.")" ;;
    esac
done
}

check_openwrt_version
main_menu
