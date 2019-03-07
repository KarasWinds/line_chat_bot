#!/bin/bash
yum -y update

username="ec2-user"
adduser $username
usermod -a -G wheel $username
echo "$username:$username" | chpasswd

# install package
yum -y install git
yum -y install docker
service docker start
usermod -a -G docker $username
curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# start line_chat_bot(docker-compose)
cd /home/$username/
git clone https://github.com/KarasWinds/line_chat_bot.git
sleep 5
docker-compose -f /home/$username/line_chat_bot/docker-compose.yml up -d

# create secret_key
sleep 5
curl -s "localhost:4040/api/tunnels" | awk -F',' '{print $3}' | awk -F'"' '{print $4}' | awk -F'//' '{print $2}' > NURL 
NURL=`cat ./NURL`
cat << EOF > /home/$username/line_chat_bot/code/chatbot/line_secret_key
{
 "channel_access_token":"",
  "secret_key":"",
  "self_user_id":"",
  "rich_menu_id":"",
  "server_url":"$NURL"
}
EOF
rm -f ./NURL

chown -R $username line_chat_bot/
chmod 777 -R line_chat_bot/*