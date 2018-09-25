#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PURPLE='\033[0;35m'
NC='\033[0m' # No Color
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# create empty crontab if none exists
crontab -e << EOF
dG:wq!
EOF

# chmod +x $DIR/slack.sh

cronjob="*/1 * * * * source $DIR/report_ip.sh"

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


distro_name=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release)

# restart crond daemon - distribution specific code
if [ $distro_name -e "CentOS Linux 7 (Core)" ]; then
    systemctl restart crond.service
# elif []; then
# sudo service cron restart 
else
    echo -e "${PURPLE}Warning!${NC}Could not determine distribution, must manually restart crond service!"
fi