#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

BASE_URL="${BASE_URL:-https://raw.githubusercontent.com/site-u2023/aios/main}"
BASE_DIR="${BASE_DIR:-/tmp/aios}"
SUPPORTED_VERSIONS="${SUPPORTED_VERSIONS:-19 21 22 23 24 SN}"

color_code_map() {
  local color=$1
  case $color in
    "red") echo "\033[1;31m" ;;
    "green") echo "\033[1;32m" ;;
    "yellow") echo "\033[1;33m" ;;
    "blue") echo "\033[1;34m" ;;
    "magenta") echo "\033[1;35m" ;;
    "cyan") echo "\033[1;36m" ;;
    "white") echo "\033[1;37m" ;;
    "red_underline") echo "\033[4;31m" ;;
    "green_underline") echo "\033[4;32m" ;;
    "yellow_underline") echo "\033[4;33m" ;;
    "blue_underline") echo "\033[4;34m" ;;
    "magenta_underline") echo "\033[4;35m" ;;
    "cyan_underline") echo "\033[4;36m" ;;
    "white_underline") echo "\033[4;37m" ;;
    "red_white") echo "\033[1;41m" ;;
    "green_white") echo "\033[1;42m" ;;
    "yellow_white") echo "\033[1;43m" ;;
    "blue_white") echo "\033[1;44m" ;;
    "magenta_white") echo "\033[1;45m" ;;
    "cyan_white") echo "\033[1;46m" ;;
    "white_black") echo "\033[7;40m" ;;
    "reset") echo "\033[0;39m" ;;
    *) echo "\033[0;39m" ;;
  esac
}

color() {
  local color=$(color_code_map "$1")
  shift
  echo -e "${color}$*$(color_code_map "reset")"
}

check_version() {
    RELEASE_VERSION=$(awk -F"'" '/DISTRIB_RELEASE/ {print $2}' /etc/openwrt_release | cut -c 1-2)
    
    echo "${RELEASE_VERSION}" > "${BASE_DIR}/check_version"
    
    if ! echo "${SUPPORTED_VERSIONS}" | grep -qw "${RELEASE_VERSION}"; then
        echo "Unsupported OpenWrt version: ${RELEASE_VERSION}"
        echo "Supported versions: ${SUPPORTED_VERSIONS}"
        exit 1
    fi
}

# case "$SELECTED_LANGUAGE" in
#      "ja" | "zh-cn" | "zh-tw") ;;  # そのまま維持
#      *) SELECTED_LANGUAGE="en" ;;  # それ以外は英語扱い
# esac

normalize_language() {
    if [ -f "${BASE_DIR}/check_language" ]; then
        SELECTED_LANGUAGE=$(cat "${BASE_DIR}/check_language")
    else
        SELECTED_LANGUAGE="en"  # デフォルト値
    fi

    case "$SELECTED_LANGUAGE" in
        "ja") ;;  # 日本語はそのまま
        *) SELECTED_LANGUAGE="en" ;;  # それ以外は英語扱い
    esac

    echo "normalize_language:$SELECTED_LANGUAGE"
}


check_language() {
    # データベースから情報を取得
    source "${BASE_DIR}/country-zonename.sh"
    country_zonename_data

    # 言語選択画面を表示
    echo -e "$(color "white" "------------------------------------------------------")"
    echo -e "$(color "white" "Select your language")"
    echo -e "$(color "blue" "[en]: English")"
    echo -e "$(color "red" "[ja]: 日本語")"
    echo -e "$(color "green" "[bg]: български")"
    echo -e "$(color "yellow" "[ca]: Català")"
    echo -e "$(color "cyan" "[cs]: Čeština")"
    echo -e "$(color "magenta" "[de]: Deutsch")"
    echo -e "$(color "lightblue" "[el]: Ελληνικά")"
    echo -e "$(color "white" "[es]: Español")"
    echo -e "$(color "lightred" "[fr]: Français")"
    echo -e "$(color "lightgreen" "[he]: עִבְרִית")"
    echo -e "$(color "lightcyan" "[hi]: हिंदी")"
    echo -e "$(color "lightmagenta" "[hu]: Magyar")"
    echo -e "$(color "lightyellow" "[it]: Italiano")"
    echo -e "$(color "lightwhite" "[ko]: 한국어")"
    echo -e "$(color "brown" "[mr]: मराठी")"
    echo -e "$(color "pink" "[ms]: Bahasa Melayu")"
    echo -e "$(color "gray" "[no]: Norsk")"
    echo -e "$(color "blue" "[pl]: Polski")"
    echo -e "$(color "green" "[pt]: Português")"
    echo -e "$(color "red" "[pt-br]: Português do Brasil")"
    echo -e "$(color "yellow" "[ro]: Română")"
    echo -e "$(color "cyan" "[ru]: Русский")"
    echo -e "$(color "magenta" "[sk]: Slovenčina")"
    echo -e "$(color "lightblue" "[sv]: Svenska")"
    echo -e "$(color "white" "[tr]: Türkçe")"
    echo -e "$(color "lightred" "[uk]: Українська")"
    echo -e "$(color "lightgreen" "[vi]: Tiếng Việt")"
    echo -e "$(color "lightcyan" "[zh-cn]: 简体中文")"
    echo -e "$(color "lightmagenta" "[zh-tw]: 繁體中文")"
    echo -e "$(color "lightyellow" "[ar]: العربية")"
    echo -e "$(color "lightwhite" "[bn]: বাংলা")"
    echo -e "$(color "brown" "[da]: Dansk")"
    echo -e "$(color "pink" "[fi]: Suomi")"
    echo -e "$(color "gray" "[nl]: Nederlands")"
    echo -e "$(color "white" "------------------------------------------------------")"

    # ユーザーの入力を取得
    read -p "Choose an option: " lang_choice

    # 選択された言語がリストにあるか確認
    found_entry=$(echo "$country_zonename" | awk '{print $2}' | grep -wx "$lang_choice")

    if [ -n "$found_entry" ]; then
        SELECTED_LANGUAGE="$lang_choice"
    else
        SELECTED_LANGUAGE="xx"
        echo -e "$(color "red" "Invalid choice. Defaulting to 'xx'.")" >&2
    fi

    # 言語を check_language ファイルに書き込む
    echo "$SELECTED_LANGUAGE" > "${BASE_DIR}/check_language"

    # 言語の標準化（ja 以外は en 扱い）
    normalize_language

    # 言語に応じたメッセージの出力
    case "$SELECTED_LANGUAGE" in
        "ja") echo -e "$(color "white" "日本語を選択しました。")" ;;
        *) echo -e "$(color "white" "You selected $(echo "$SELECTED_LANGUAGE" | tr '[:lower:]' '[:upper:]') (Processed as English).")" ;;
    esac

echo "check_language: $SELECTED_LANGUAGE"
echo "check_language result: $(source ${BASE_DIR}/check_language; echo $?)"

}




XXcheck_language() {
while true; do
    echo -e "$(color "white" "------------------------------------------------------")"
    echo -e "$(color "white" "Select your language")"
    echo -e "$(color "blue" "[en]: English")"
    echo -e "$(color "red" "[ja]: 日本語")"
    echo -e "$(color "white" "------------------------------------------------------")"
    read -p "Choose an option [en/ja]: " lang_choice
    case "${lang_choice}" in
        "en") SELECTED_LANGUAGE="en"; break ;;
        "ja") SELECTED_LANGUAGE="ja"; break ;;
         *) echo "Invalid choice." ;;
   esac
done
echo "${SELECTED_LANGUAGE}" > ${BASE_DIR}/check_language
}

check_package_manager() {
    if command -v apk >/dev/null 2>&1; then
        PACKAGE_MANAGER="APK"
        echo "${PACKAGE_MANAGER}" > ${BASE_DIR}/check_package_manager
    elif command -v opkg >/dev/null 2>&1; then
        PACKAGE_MANAGER="OPKG"
        echo "${PACKAGE_MANAGER}" > ${BASE_DIR}/check_package_manager
    else
        echo "No package manager found"
        exit 1
    fi
}

language_parameter() {
SELECTED_LANGUAGE=$1
if [ -n "${SELECTED_LANGUAGE}" ]; then
  echo "${SELECTED_LANGUAGE}" > "${BASE_DIR}/check_language"
fi

echo "language_parameter: $SELECTED_LANGUAGE"
echo "language_parameter result: $(source ${BASE_DIR}/check_language; echo $?)"
}

XXcheck_common() {
        # バージョン情報の取得
    if [ -f "${BASE_DIR}/check_version" ]; then
        RELEASE_VERSION=$(cat "${BASE_DIR}/check_version")
    fi
    [ -z "$RELEASE_VERSION" ] && check_version

    # データベースから情報を取得
    source "${BASE_DIR}/country-zonename.sh"
    country_zonename_data

    # 言語がセットされていない場合はデフォルトでenをセット
   # if [ -z "$SELECTED_LANGUAGE" ]; then
    #    SELECTED_LANGUAGE="en"
    #fi
    # 言語選択の判定
    if [ -n "$1" ]; then
        found_entry=$(echo "$country_zonename" | awk '{print $2}' | grep -wx "$1")
        if [ -n "$found_entry" ]; then
            SELECTED_LANGUAGE="$1"
        else
            SELECTED_LANGUAGE="xx"
            echo "Invalid language selection. Defaulting to 'xx'."
        fi
    elif [ -f "${BASE_DIR}/check_language" ]; then
        SELECTED_LANGUAGE=$(cat "${BASE_DIR}/check_language")
    fi

    # 言語設定の確認
#    echo "Selected language: ${SELECTED_LANGUAGE}"
    
    # 次の処理に進む
    # 他の処理...
echo "check_common: $SELECTED_LANGUAGE"
echo "check_common: $(source ${BASE_DIR}/check_language; echo $?)"
}




check_common() {
  if [ -f "${BASE_DIR}/check_version" ]; then
    RELEASE_VERSION=$(cat "${BASE_DIR}/check_version")
  fi
  [ -z "$RELEASE_VERSION" ] && check_version

  if [ -n "$1" ] && { [ "$1" = "ja" ] || [ "$1" = "en" ]; }; then
    SELECTED_LANGUAGE="$1"
    echo "${SELECTED_LANGUAGE}" > "${BASE_DIR}/check_language"
  elif [ -f "${BASE_DIR}/check_language" ]; then
    SELECTED_LANGUAGE=$(cat "${BASE_DIR}/check_language")
  fi
  [ -z "${SELECTED_LANGUAGE}" ] && check_language

  if [ -f "${BASE_DIR}/check_package_manager" ]; then
    PACKAGE_MANAGER=$(cat "${BASE_DIR}/check_package_manager")
  fi
  [ -z "$PACKAGE_MANAGER" ] && check_package_manager
}

ask_confirmation() {
    local message_key="$1"
    local message

    if [ "${SELECTED_LANGUAGE}" = "en" ]; then
        case "$message_key" in
            "download") message="Execute download?" ;;
            "exit") message="Are you sure you want to exit?" ;;
            "delete") message="Are you sure you want to delete the script and exit?" ;;
            *) message="Are you sure?" ;;
        esac
    elif [ "${SELECTED_LANGUAGE}" = "ja" ]; then
        case "$message_key" in
            "download") message="ダウンロードを実行しますか？" ;;
            "exit") message="終了してもよろしいですか？" ;;
            "delete") message="スクリプトを削除して終了しますか？" ;;
            *) message="実行しますか？" ;;
        esac
    fi

    while true; do
        read -p "$(color "white" "${message} [y/n]: ")" choice
        case "${choice}" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo -e "$(color "white" "Invalid choice, please enter 'y' or 'n'.")" ;;
        esac
    done
}

show_notification() {
    local message_key="$1"
    local message
    local lang="${SELECTED_LANGUAGE:-en}"
    
    if [ "$lang" = "en" ]; then
        case "$message_key" in
            "download_success") message="Download successful." ;;
            "download_failure") message="Download failed." ;;
            "exit_cancelled") message="Exit operation cancelled." ;;
            "delete_cancelled") message="Delete operation cancelled." ;;
            "delete_success") message="Script and configuration deleted." ;;
            "download_cancelled") message="Download operation cancelled." ;;
            "exit") message="Exit operation completed." ;;
            "delete") message="Delete operation completed." ;;
            *) message="Operation completed." ;;
        esac
    elif [ "$lang" = "ja" ]; then
        case "$message_key" in
            "download_success") message="ダウンロードが成功しました。" ;;
            "download_failure") message="ダウンロードに失敗しました。" ;;
            "exit_cancelled") message="終了操作がキャンセルされました。" ;;
            "delete_cancelled") message="削除操作がキャンセルされました。" ;;
            "delete_success") message="スクリプトと設定が削除されました。" ;;
            "download_cancelled") message="ダウンロード操作がキャンセルされました。" ;;
            "exit") message="終了操作が完了しました。" ;;
            "delete") message="削除操作が完了しました。" ;;
            *) message="操作が完了しました。" ;;
        esac
    fi

    echo -e "$(color "white" "${message}")"
}

menu_option() {
    local action="$1"
    local description="$2"
    local script_name="$3"

    echo -e "$(color "white" "${description}")"

    case "${action}" in
        "exit")
            if ask_confirmation "exit"; then
                show_notification "exit"
                exit 0
            else
                show_notification "exit_cancelled"
            fi
            ;;
        "delete")
            if ask_confirmation "delete"; then
                rm -rf "${BASE_DIR}" /usr/bin/aios /tmp/aios.sh
                show_notification "delete_success"
                exit 0
            else
                show_notification "delete_cancelled"
            fi
            ;;
        "download")
            if ask_confirmation "download"; then
                if wget --quiet -O "${BASE_DIR}/${script_name}" "${BASE_URL}/${script_name}"; then
                    show_notification "download_success"
                    . "${BASE_DIR}/${script_name}"
                else
                    show_notification "download_failure"
                fi
            else
                show_notification "download_cancelled"
            fi
            ;;
        *)
            echo -e "$(color "red" "Unknown action.")"
            ;;
    esac
}
