#!bin/bash
curl localhost:4040/api/tunnels > tunnels.json
cat ./tunnels.json | awk -F',' '{print $3}' | awk -F'"' '{print $4}' | awk -F'//' '{print $2}'
