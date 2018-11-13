ssh -t -i ~/.ssh/nectar.key hpcuser@140.221.236.178 ssh -A -t sccuser@104.40.5.79 ssh -i ~/.ssh/Azure ccuser@104.42.37.222

eval `ssh-agent -s`
ssh-add ~/.ssh/cyclecloud.pem

ssh -t -i ~/.ssh/nectar.key hpcuser@140.221.236.178 eval `ssh-agent -s` && ssh-add /home/hpctop/.ssh/cyclecloud.pem && ssh -A -t sccuser@104.40.5.79