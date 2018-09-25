#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PURPLE='\033[0;35m'
NC='\033[0m' # No Color
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# echo "fetching scripts..."
# curl -s https://gist.githubusercontent.com/andkirby/67a774513215d7ba06384186dd441d9e/raw --output $DIR/slack.sh
# chmod +x /usr/bin/slack

# create empty crontab if none exists
crontab -e << EOF
dG:wq!
EOF

# chmod +x $DIR/slack.sh

send_message() {
  local channel=${1}
  echo 'Sending to '${channel}'...'
  curl --silent --data-urlencode \
    "$(printf 'payload={"text": "%s", "channel": "%s", "username": "%s", "as_user": "true", "link_names": "true", "icon_emoji": "%s" }' \
        "${slack_message}" \
        "${channel}" \
        "${APP_SLACK_USERNAME}" \
        "${APP_SLACK_ICON_EMOJI}" \
    )" \
    ${APP_SLACK_WEBHOOK} || true
  echo
}

cronjob="*/10 * * * * source $DIR/slack.sh"

if grep -Fxq "$cronjob" <<< $(crontab -l)
then
    echo "IP report cronjob foundin crontab already. No changes made."
else
    echo "Creating IP report cronjob"
    # touch /usr/bin/
    crontab -l > /tmp/crontab
    echo "$cronjob" >> /tmp/crontab
    crontab /tmp/crontab
    rm /tmp/crontab
fi


printf "APP_SLACK_WEBHOOK=https://hooks.slack.com/services/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" > 

distro_name=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release)

# restart crond daemon - distribution specific code
if [ $distro_name -e "CentOS Linux 7 (Core)" ]; then
    systemctl restart crond.service
# elif []; then
# sudo service cron restart 
else
    echo -e "${PURPLE}Warning!${NC}Could not determine distribution, must manually restart crond service!"
fi