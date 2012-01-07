#!/bin/bash
# "Automated VPS Setup for Ubuntu 11.10 - Rails with Nginx"
#
# Created by: Rafael Biriba - www.rafaelbiriba.com - biribarj@gmail.com
#
# USAGE:
#
# $ chmod +x vps.sh
# $ ./vps.sh yourdomain.com"

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
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz
tar xzvf ruby-1.9.2-p290.tar.gz
cd ruby-1.9.2-p290
./configure
make
make install
cd ~
rm -rf ~/tmp


echo "Install Passenger and Nginx"
echo "---------------------------"

gem install passenger
apt-get install libcurl4-openssl-dev -y
passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx

cd ~
wget https://raw.github.com/gist/644217/a59effaaacf8ef2634743f744c532e704652e48c/nginx
cp nginx /etc/init.d/nginx
rm nginx
chmod +x /etc/init.d/nginx
/usr/sbin/update-rc.d -f nginx defaults
/etc/init.d/nginx start


echo "Configure iptables"
echo "------------------"

apt-get install iptables

tee /etc/init.d/firewall <<ENDOFFILE
#!/bin/bash

start(){
# Accepting all connections made on the special lo - loopback - 127.0.0.1 - interface
iptables -A INPUT -p tcp -i lo -j ACCEPT

# Rule which allows established tcp connections to stay up
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH:
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# DNS:
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT

# HTTP e HTTPS:
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 7080 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Block others ports
iptables -A INPUT -p tcp --syn -j DROP
iptables -A INPUT -p udp --dport 0:1023 -j DROP

}
stop(){
iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
}

case "\$1" in
"start") start ;;
"stop") stop ;;
"restart") stop; start ;;
*) echo "start or stop params"
esac
ENDOFFILE

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


echo "VPS Setup Complete"
echo "------------------"
