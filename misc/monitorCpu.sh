# watch -t -n 0.2 'bash ~/Documents/scc/getCpu.sh'
watch -t -n 0.2 'bash ~/Documents/scc/getCpu.sh >> currentCpu.txt && echo "$(tail --lines 10 currentCpu.txt)" > currentCpu.txt' 