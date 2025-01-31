#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

BASE_URL="https://raw.githubusercontent.com/site-u2023/aios/main"
BASE_DIR="/tmp/aios"
SUPPORTED_VERSIONS="19 21 22 23 24 SN"

if [ ! -f "${BASE_DIR}/common-functions.sh" ]; then
  wget --no-check-certificate -O "${BASE_DIR}/common-functions.sh" "${BASE_URL}/common-functions.sh"
fi
source "${BASE_DIR}/common-functions.sh"

main_menu() {
        if [ "${SELECTED_LANGUAGE}" = "en" ]; then
            MENU0="Internet Settings"
            MENU1="OCN Virtual Connect, V6 Plus, IPv6 Option automatic setup (multi-session support)"
            MENU2="NURO Hikari MAP-e automatic setup (partially supported: under verification)"
            MENU3="Transix automatic setup"
            MENU4="CrossPass automatic setup"
            MENU5="v6 Connect automatic setup"
            MENU6="PPPoE (IPv4・IPv6): Requires authentication ID (username) and password"
            MENU00="Back"
        elif [ "${SELECTED_LANGUAGE}" = "ja" ]; then
            MENU0="インターネット設定"
            MENU1="OCNバーチャルコネクト・V6プラス・IPv6オプション自動設定（マルチセッション対応）"
            MENU2="NURO光 MAP-e自動設定 (一部のみ対応：検証中)"
            MENU3="トランジックス自動設定"
            MENU4="クロスパス自動設定"
            MENU5="v6 コネクト自動設定"
            MENU6="PPPoE (iPv4・IPv6): 要認証ID (ユーザー名)・パスワード"
            MENU00="戻る"
        fi

        TARGET1="map_e"
        TARGET2="map_e_nuro"
        TARGET3="ds_lite_transix"
        TARGET4="ds_lite_xpass"
        TARGET5="ds_lite_v6connect"
        TARGET6="pppoe"
        TARGET00="return"

        while :; do
            echo -e "$(color "white" "------------------------------------------------------")"
            echo -e "$(color "white" "${MENU0}")"
            echo -e "$(color "blue" "[m]: ${MENU1}")"
            echo -e "$(color "yellow" "[n]: ${MENU2}")"
            echo -e "$(color "green" "[t]: ${MENU3}")"
            echo -e "$(color "magenta" "[x]: ${MENU4}")"
            echo -e "$(color "red" "[v]: ${MENU5}")"
            echo -e "$(color "cyan" "[p]: ${MENU6}")"
            echo -e "$(color "white" "[b]: ${MENU00}")"
            echo -e "$(color "white" "------------------------------------------------------")"
            read -p "$(color "white" "Select an option: ")" option
            case "${option}" in
                "m") ${TARGET1} ;;
                "n") ${TARGET2} ;;
                "t") ${TARGET3} ;;
                "x") ${TARGET4} ;;
                "v") ${TARGET5} ;;
                "p") ${TARGET6} ;;
                "b") return;;
                *) echo "$(color "red" "Invalid option. Please try again.")" ;;
            esac
        done
    }
    
map_e() {
    # Set language-dependent text for menu
    if [ "${SELECTED_LANGUAGE}" = "en" ]; then
        MENU000="Requires direct connection to HGW"
        MENU0="OCN Virtual Connect, V6 Plus, IPv6 Option"
        MENU1="OCN Virtual Connect, V6 Plus, IPv6 Option automatic setup (multi-session support)"
        MENU2="Delete OCN Virtual Connect, V6 Plus, IPv6 Option settings and restore previous settings"
        MENU00="Back"
    elif [ "${SELECTED_LANGUAGE}" = "ja" ]; then
        MENU000="要HGW直結"
        MENU0="OCNバーチャルコネクト・V6プラス・IPv6オプション"
        MENU1="OCNバーチャルコネクト・V6プラス・IPv6オプション自動設定（マルチセッション対応）"
        MENU2="OCNバーチャルコネクト・V6プラス・IPv6オプション設定削除及び以前の設定復元"
        MENU00="戻る"
    fi

    TARGET1="map_e_confirmation"
    TARGET2="map_e_reconstruction"

    while :; do
        echo -e "$(color "white" "------------------------------------------------------")"
        echo -e "$(color "yellow" "${MENU000}")"
        echo -e "$(color "white" "${MENU0}")"
        echo -e "$(color "blue" "[s]: ${MENU1}")"
        echo -e "$(color "red" "[r]: ${MENU2}")"
        echo -e "$(color "white" "[b]: ${MENU00}")"
        echo -e "$(color "white" "------------------------------------------------------")"
        read -p "$(color "white" "Select an option: ")" option
        case "${option}" in
            "s") ${TARGET1} ;;
            "r") ${TARGET2} ;;
            "b") main_menu ;;
            *) echo "$(color "red" "Invalid option. Please try again.")" ;;
        esac
    done
}

map_e_confirmation() {

    # Set language-dependent text for menu
    if [ "${SELECTED_LANGUAGE}" = "en" ]; then
        echo EN
    elif [ "${SELECTED_LANGUAGE}" = "ja" ]; then
        MENU0="OCNバーチャルコネクト・V6プラス・IPv6オプションの設定（マルチセッション対応）とインストールとを実行します"
        MENU1="インストール: map"
        MENU2="インストール: bash"
        MENU3="宜しいですか [y/n]"
    fi

    TARGET1="map_e_installation"
    
    while :; do
        echo -e "$(color "white" "------------------------------------------------------")"
        echo -e "$(color "blue" "${MENU0}")"
        echo -e "$(color "white" "${MENU1}")"
        echo -e "$(color "white" "${MENU2}")"
        echo -e "$(color "white" "${MENU3}")"
        echo -e "$(color "white" "------------------------------------------------------")"
        read -p "$(color "white" "Select an option: ")" option
        case "${option}" in
            "y") ${TARGET1} ;;
            "n") map_e ;;
            *) echo "$(color "red" "Invalid option. Please try again.")" ;;
        esac
    done
}

map_e_installation() {
    local supported_versions="SN"
    if echo "${supported_versions}" | grep -q "${release}"; then
        apk update
        apk add bash
        apk add map
    else
        opkg update
        opkg install bash
        opkg install map
    fi

    cp /lib/netifd/proto/map.sh /lib/netifd/proto/map.sh.old

    local supported_versions="19"
    if echo "${supported_versions}" | grep -q "${release}"; then
        wget -6 --no-check-certificate -O /lib/netifd/proto/map.sh ${MAPE_URL}map19.sh.new
    else
        wget -6 --no-check-certificate -O /lib/netifd/proto/map.sh ${MAPE_URL}map.sh.new
    fi
    wget -6 --no-check-certificate -O ${BASE_DIR}/map-e.sh ${BASE_URL}/map-e.sh
    bash ${BASE_DIR}/map-e.sh 2> /dev/null

    if [ "${SELECTED_LANGUAGE}" = "en" ]; then
        echo EN
    elif [ "${SELECTED_LANGUAGE}" = "ja" ]; then
         read -p "何かキーを押してデバイスを再起動してください"
    elif [ "${SELECTED_LANGUAGE}" = "cn" ]; then
        echo CN
    fi
    
    reboot
}

map_e_reconstruction() {
# 作成中
exit
}

# Check OpenWrt version
check_openwrt_version() {
    local release=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
    if echo "${SUPPORTED_VERSIONS}" | grep -q "${release}"; then
        echo -e "$(color "white_black" "OpenWrt version: ${release} - Supported")"
    else
        echo -e "$(color "red_black" "Unsupported OpenWrt version: ${release}")"
        echo -e "$(color "white_black" "Supported versions: ${SUPPORTED_VERSIONS}")"
        exit 1
    fi
}

download_common
check_common "$1"
main_menu
