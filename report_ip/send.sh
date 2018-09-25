#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OLD_IP="$DIR/old_ip.txt"
GETIPADDR="dig +short myip.opendns.com @resolver1.opendns.com"
LOG="$DIR/ip_address_monitor.log"
timestamp=$( date +%T )
curDate=$( date +"%m-%d-%y" )
APP_SLACK_WEBHOOK="https://hooks.slack.com/services/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"
channel="dell-server-messages"
APP_SLACK_USERNAME="dell_poweredge"
APP_SLACK_ICON_EMOJI="🖳"

if [ -f $NOWIPADDR ]; then
  if [[ `$GETIPADDR` = $(< $NOWIPADDR) ]]; then
    echo $curDate $timestamp " IP address check: " $(< $NOWIPADDR) >> $LOG
  else
    $GETIPADDR > $NOWIPADDR
    send_message $NOWIPADDR
fi
else
  curl $GETIPADDR > $NOWIPADDR
  send_message $NOWIPADDR
fi

send_message() {
  # echo 'Sending to '${channel}'...'
  curl --silent --data-urlencode \
    "$(printf 'payload={"text": "%s", "channel": "%s", "username": "%s", "as_user": "true", "link_names": "true", "icon_emoji": "%s" }' \
        "$0" \
        "${channel}" \
        "${APP_SLACK_USERNAME}" \
        "${APP_SLACK_ICON_EMOJI}" \
    )" \
    ${APP_SLACK_WEBHOOK} || true
}