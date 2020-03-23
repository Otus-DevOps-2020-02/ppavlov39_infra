#!/bin/bash

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
apt update
apt install -y mongodb-org
systemctl enable mongod && sudo systemctl start mongod
apt install -y ruby-full ruby-bundler build-essential

useradd appuser -s /bin/bash -m -G sudo
echo "appuser:asdadjhsdjhsdfkjhsdjf" | sudo chpasswd
su -c 'cd /home/appuser && git clone -b monolith https://github.com/express42/reddit.git' appuser
cd /home/appuser/reddit/ && sudo bundle install
chown appuser:appuser -R /home/appuser

su -c 'cd /home/appuser/reddit && puma -d'


