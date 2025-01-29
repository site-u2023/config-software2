#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

# タイムゾーンデータ
country_timezones="
US United States UTC-5 UTC-6 UTC-7 UTC-8 UTC-9 UTC-10 UTC-11
CA Canada UTC-3 UTC-4 UTC-5 UTC-6 UTC-7 UTC-8 UTC-9
JP Japan UTC+9
DE Germany UTC+1 UTC+2
NL Netherlands UTC+1 UTC+2
IT Italy UTC+1 UTC+2
PT Portugal UTC-1 UTC+0 UTC+1
LU Luxembourg UTC+1 UTC+2
NO Norway UTC+1 UTC+2
FI Finland UTC+2 UTC+3
DK Denmark UTC+1 UTC+2
CH Switzerland UTC+1 UTC+2
CZ Czech Republic UTC+1 UTC+2
ES Spain UTC+1 UTC+2
GB United Kingdom UTC+0 UTC+1
KR Republic of Korea UTC+9
CN China UTC+8
FR France UTC+1 UTC+2
HK Hong Kong UTC+8
SG Singapore UTC+8
TW Taiwan UTC+8
BR Brazil UTC-3 UTC-4 UTC-5
IL Israel UTC+2 UTC+3
SA Saudi Arabia UTC+3
LB Lebanon UTC+2
AE United Arab Emirates UTC+4
ZA South Africa UTC+2
AR Argentina UTC-3
AU Australia UTC+8 UTC+9 UTC+10 UTC+11 UTC+12
AT Austria UTC+1 UTC+2
BO Bolivia UTC-4
CL Chile UTC-3 UTC-4 UTC-5
GR Greece UTC+2 UTC+3
IS Iceland UTC+0
IN India UTC+5:30
IE Ireland UTC+0 UTC+1
KW Kuwait UTC+3
LI Liechtenstein UTC+1 UTC+2
LT Lithuania UTC+2 UTC+3
MX Mexico UTC-6 UTC-7 UTC-8
MA Morocco UTC+0 UTC+1
NZ New Zealand UTC+12 UTC+13
PL Poland UTC+1 UTC+2
PR Puerto Rico UTC-4
SK Slovak Republic UTC+1 UTC+2
SI Slovenia UTC+1 UTC+2
TH Thailand UTC+7
UY Uruguay UTC-3
PA Panama UTC-5
RU Russia UTC+3 UTC+4 UTC+5 UTC+6 UTC+7 UTC+8 UTC+9 UTC+10 UTC+11
EG Egypt UTC+2
TT Trinidad and Tobago UTC-4
TR Turkey UTC+3
CR Costa Rica UTC-6
EC Ecuador UTC-5
HN Honduras UTC-6
KE Kenya UTC+3
UA Ukraine UTC+2 UTC+3
VN Vietnam UTC+7
BG Bulgaria UTC+2 UTC+3
CY Cyprus UTC+2 UTC+3
EE Estonia UTC+2 UTC+3
MU Mauritius UTC+4
RO Romania UTC+2 UTC+3
CS Serbia and Montenegro UTC+1 UTC+2
ID Indonesia UTC+7 UTC+8 UTC+9
PE Peru UTC-5
VE Venezuela UTC-4
JM Jamaica UTC-5
BH Bahrain UTC+3
OM Oman UTC+4
JO Jordan UTC+2
BM Bermuda UTC-4
CO Colombia UTC-5
DO Dominican Republic UTC-4
GT Guatemala UTC-6
PH Philippines UTC+8
LK Sri Lanka UTC+5:30
SV El Salvador UTC-6
TN Tunisia UTC+1
PK Pakistan UTC+5
QA Qatar UTC+3
DZ Algeria UTC+1
"

# 引数チェック
if [ -z "$1" ]; then
  echo "Usage: $0 <country_code>"
  exit 1
fi

# 国コードを検索
country_code="$1"
found_entry=$(echo "$country_timezones" | grep -E "^$country_code " )

if [ -n "$found_entry" ]; then
  echo "$found_entry"
else
  echo "Country code not found."
  exit 1
fi
