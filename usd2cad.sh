#!/bin/bash

main() {
  local userAgent="User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:26.0) Gecko/20100101 Firefox/26.0"
  local accept="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
  local acceptLanguage="Accept-Language: en-US,en;q=0.5"
  local acceptEncoding="Accept-Encoding: gzip, deflate"
  local dnt="DNT: 1"
  local referer="Referer: http://www.xe.com/currencyconverter"

  local soup=$(curl -H "$userAgent" -H "$accept" -H "$acceptLanguage" -H "$acceptEncoding" -H "$dnt" -H "$referer" 'http://www.xe.com/currencyconverter/convert/?Amount=1&From=USD&To=CAD' 2>/dev/null | gunzip | grep -A 2 '<tr class="uccResUnit">')

  local usd=$(printf %s "$soup" | egrep -o \>[0-9]+.+USD.+CAD\< | egrep -o "[^<>]+")
  local cad=$(printf %s "$soup" | egrep -o \>[0-9]+.+CAD.+USD\< | egrep -o "[^<>]+")

  printf "${usd//&nbsp;/ }\n"
  printf "${cad//&nbsp;/ }\n"
}

main $@
