#!/bin/bash
# "Automated VPS Setup for Ubuntu - Rails with Nginx"
#
# Created by: Rafael Biriba - www.rafaelbiriba.com - biribarj@gmail.com
# https://github.com/rafaelbiriba/Ubuntu-VPS-Builder/
#
# USAGE:
#
# $ chmod +x vps_builder.sh
# $ sudo ./vps_builder.sh yourdomain.com"

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


echo "Install Essencials - yaml for ruby"
echo "------------------"
mkdir ~/tmp && cd ~/tmp
wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
tar xzvf yaml-0.1.4.tar.gz
cd yaml-0.1.4
./configure --prefix=/usr/local
make
make install
cd ~
rm -rf ~/tmp


echo "Install Ruby 1.9.3"
echo "------------------"

mkdir ~/tmp && cd ~/tmp
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
tar xzvf ruby-1.9.3-p194.tar.gz
cd ruby-1.9.3-p194
./configure --prefix=/usr/local --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib
make
make install
cd ~
rm -rf ~/tmp


echo "Install Passenger and Nginx"
echo "---------------------------"

mkdir ~/tmp && cd ~/tmp
wget http://ftp.cs.stanford.edu/pub/exim/pcre/pcre-8.30.tar.gz
tar xzvf pcre-8.30.tar.gz
cd pcre-8.30
./configure && make && make install
cd ~/tmp

wget http://nginx.org/download/nginx-1.3.0.tar.gz
wget http://www.grid.net.ru/nginx/download/nginx_upload_module-2.2.0.tar.gz
tar xzvf nginx-1.3.0.tar.gz
tar xzvf nginx_upload_module-2.2.0.tar.gz

gem install passenger -v 3.0.21 --no-rdoc --no-ri
apt-get install libcurl4-openssl-dev -y
passenger-install-nginx-module --auto --prefix=/opt/nginx --nginx-source-dir=/root/tmp/nginx-1.3.0 --extra-configure-flags=--add-module='/root/tmp/nginx_upload_module-2.2.0'
#passenger-install-nginx-module --auto --auto-download
cd ~
rm -rf ~/tmp

#### Patch for 64 bits, ignored by 32 bits ####
sudo ln -s /usr/local/lib/libpcre.so.1 /usr/lib/libpcre.so.1

cd ~
wget https://raw.github.com/rafaelbiriba/Ubuntu-VPS-Builder/master/recipe1/nginx-init.sh
cp nginx-init.sh /etc/init.d/nginx
rm nginx-init.sh
chmod +x /etc/init.d/nginx
/usr/sbin/update-rc.d -f nginx defaults
/etc/init.d/nginx start


echo "Configure iptables"
echo "------------------"

apt-get install iptables

wget https://raw.github.com/rafaelbiriba/Ubuntu-VPS-Builder/master/recipe1/iptables-config -O /etc/init.d/firewall

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

gem install bundler --no-rdoc --no-ri

echo "VPS Setup Complete"
echo "------------------"
