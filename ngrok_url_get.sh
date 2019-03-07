#!/bin/bash

# create line_secret_key
curl -s "localhost:4040/api/tunnels" | awk -F',' '{print $3}' | awk -F'"' '{print $4}' | awk -F'//' '{print $2}' > NURL
NURL=`cat ./NURL`
cat << EOF > ./code/chatbot/line_secret_key
{
 "channel_access_token":"",
  "secret_key":"",
  "self_user_id":"",
  "rich_menu_id":"",
  "server_url":"$NURL"
}
EOF
rm -f ./NURL