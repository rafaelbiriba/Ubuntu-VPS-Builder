#!/bin/bash
# "Automated VPS Setup for Ubuntu 11.10 - Rails with Nginx"
#
# Created by: Rafael Biriba - www.rafaelbiriba.com - biribarj@gmail.com
# https://github.com/rafaelbiriba/Ubuntu-VPS-Builder/
#
# USAGE:
#
# $ chmod +x vps_builder.sh
# $ ./vps_builder.sh yourdomain.com"

echo "Updating before all"
echo "------------"
apt-get update && apt-get upgrade -y

echo "Set Hostname"
echo "------------"

echo $1 > /etc/hostname
echo "127.0.0.1 $1" >> /etc/hosts
hostname -F /etc/hostname


echo "Set Timezone"
echo "------------"

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime


echo "Install Essencials"
echo "------------------"

apt-get install build-essential zlib1g-dev libreadline6-dev libssl-dev wget git-core sudo -y


echo "Install Ruby 1.9.2"
echo "------------------"

mkdir ~/tmp && cd ~/tmp
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p125.tar.gz
tar xzvf ruby-1.9.3-p125.tar.gz
cd ruby-1.9.3-p125
./configure
make
make install
cd ~
rm -rf ~/tmp


echo "Install Passenger and Nginx"
echo "---------------------------"

mkdir ~/tmp && cd ~/tmp
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.30.tar.gz
tar xzvf pcre-8.21.tar.gz
cd pcre-8.21
./configure && make && make install
cd ~/tmp

wget http://nginx.org/download/nginx-1.2.0.tar.gz
wget http://www.grid.net.ru/nginx/download/nginx_upload_module-2.2.0.tar.gz
tar xzvf nginx-1.2.0.tar.gz
tar xzvf nginx_upload_module-2.2.0.tar.gz

gem install passenger
apt-get install libcurl4-openssl-dev -y
passenger-install-nginx-module --prefix=/opt/nginx --nginx-source-dir=/root/tmp/nginx-1.2.0 --extra-configure-flags=--add-module='/root/tmp/nginx_upload_module-2.2.0'
#passenger-install-nginx-module --auto --auto-download
cd ~
rm -rf ~/tmp


cd ~
wget https://raw.github.com/rafaelbiriba/Ubuntu-VPS-Builder/master/ubuntu_11-10_desktop/nginx-init.sh
cp nginx-init.sh /etc/init.d/nginx
rm nginx-init.sh
chmod +x /etc/init.d/nginx
/usr/sbin/update-rc.d -f nginx defaults
/etc/init.d/nginx start


echo "Configure iptables"
echo "------------------"

apt-get install iptables

wget https://raw.github.com/rafaelbiriba/Ubuntu-VPS-Builder/master/ubuntu_11-10_desktop/iptables-config -o /etc/init.d/firewall

chmod +x /etc/init.d/firewall
update-rc.d firewall defaults 99
/etc/init.d/firewall start


echo "Install MySQL"
echo "-------------"

apt-get install mysql-server mysql-client libmysqlclient-dev -y


echo "Install postfix"
echo "---------------"

# Install type: Internet Site
# Default email domain name: example.com
apt-get install postfix mailutils telnet -y
/usr/sbin/update-rc.d postfix defaults
/etc/init.d/postfix start

echo "Install gem bundler"
echo "-------------------"

gem install bundler

echo "VPS Setup Complete"
echo "------------------"
