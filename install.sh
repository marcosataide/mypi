
# keep directory from which install.sh was started in $INSTALLDIR
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  INSTALLDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
export INSTALLDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# basic setup of home directories + my bin scripts
mkdir /home/pi/bin
mkdir /home/pi/tmp
mkdir /home/pi/logs
cp -r $INSTALLDIR/bin/* /home/pi/bin

echo "---------------------------"
echo "-- Installing gmail SMTP --"
echo "---------------------------"
sudo apt-get -y install ssmtp mailutils sharutils
sudo cp /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.bak
sudo cp $INSTALLDIR/files/ssmtp.txt /etc/ssmtp/ssmtp.conf
sudo perl -i.bak -p -e "s/AuthPass=ms_gmail_auth/AuthPass=$ms_gmail_auth/" /etc/ssmtp/ssmtp.conf



echo "----------------------------------------------------------------------"
echo "----------------------------------------------------------------------"
echo "----------------------------------------------------------------------"
echo "-- Creating a ssh key for some automagic login to stuff like github --"
echo "----------------------------------------------------------------------"
echo "----------------------------------------------------------------------"
echo "----------------------------------------------------------------------"
mkdir /home/pi/.ssh
cd /home/pi/.ssh
ssh-keygen -t rsa -C "marcos@ataide.com.br" -N "" -f /home/pi/.ssh/id_rsa
(echo "add this key to github here : https://github.com/settings/ssh
"; cat /home/pi/.ssh/id_rsa.pub) | mail -s "add this raspberry public key to github" marcos@ataide.com.br; 

chmod 700 /home/pi/.ssh
chmod 600 /home/pi/.ssh/authorized_keys
touch /home/pi/.ssh/authorized_keys
cat $INSTALLDIR/files/chromeos.pub | tee -a /home/pi/.ssh/authorized_keys

# setting up dnsexit dynamic DNS to link to the pi -- koenbeek & classic passwd
. $INSTALLDIR/install/dnsexit.sh

echo "------------------------------------------------------------------------------------------------------"
echo "-- installing VNC server - use it with VNC viewer - short passwd - start on server with vncstart.sh --"
echo "------------------------------------------------------------------------------------------------------"
sudo apt-get -y install tightvncserver
/home/pi/bin/vncstart.sh

# Update the PI with the latest from the apt repositories
. $INSTALLDIR/install/updateapt.sh

echo "----------------------------------------------------------"
echo "-- Setting a static address of 192.168.25.128 for our PI --"
echo "----------------------------------------------------------"
# get a STATIC IP ADDRESS 192.168.25.128 for ETH0 for our pi assuming gateway = 192.168.25.1
# You should also take a look at the file /etc/resolv.conf
# and check it has a nameserver entry (probably pointing at your default gateway)
# nameserver 192.168.25.1
#sudo perl -i.bak -p -e 's/iface eth0 inet dhcp/iface eth0 inet static\naddress 192.168.25.128\nnetmask 255.255.255.0\ngateway 192.168.25.1\nmtu 1492\n/' /etc/network/interfaces

# PowerDNS server
. $INSTALLDIR/install/powerdns.sh

echo "-------------------------------------------"
echo "-- Installing a light webserver lighttpd --"
echo "-------------------------------------------"
sudo apt-get -y install lighttpd
cd /etc/lighttpd
sudo cp lighttpd.conf lighttpd.bak
sudo cp $INSTALLDIR/files/lighttpd.conf lighttpd.conf
# permissions for web server
sudo chown www-data:www-data /var/www
sudo chmod 775 /var/www
sudo usermod -a -G www-data pi
sudo usermod -a -G usb1 www-data
# make disk available via web
sudo service lighttpd restart

echo "--------------------"
echo "-- installing php --"
echo "--------------------"
sudo apt-get -y install php5-common php5-cgi php5 php5-mcrypt
sudo lighty-enable-mod fastcgi-php
sudo service lighttpd force-reload

echo "-----------------------"-
echo "          mysql         "
echo "------------------------"
sudo apt-get -y install mysql-server
sudo apt-get -y install php5-mysql phpmyadmin **/


#echo "----------------"
#echo "-- postgresql --"
#echo "----------------"
#sudo apt-get -y install postgresql
#sudo apt-get -y install php5-pgsql phppgadmin
#echo "ALTER USER postgres with password '"$ms_postgres_passwd"';" | sudo -u postgres psql postgres
#sudo perl -i.bak -p -e "s/extra_login_security'\] = true;/extra_login_security'\] = false;/" /usr/share/phppgadmin/conf/config.inc.php
#sudo ln -s /usr/share/phppgadmin /var/www/phppgadmin


echo "-----------------------------"
echo "-- installing node and npm --"
echo "-----------------------------"
cd /home/pi/tmp
nodeurl=$(curl http://nodejs.org/dist/latest/ | grep arm | perl -pe 's/^.*href="([^"]+)".*$/$1/')
wget http://nodejs.org/dist/latest/$nodeurl
cd /usr/local
sudo tar xzvf /home/pi/tmp/node-v*-linux-arm-pi.tar.gz --strip=1
echo "-----------------------------"
echo "-- node and npm installed  --"
echo "-----------------------------"

 
echo "----------------------------------"
echo "-- installing ftp server vsftpd --"
echo "----------------------------------"
sudo apt-get -y install vsftpd
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
sudo cp $INSTALLDIR/files/vsftpd.conf.txt /etc/vsftpd.conf
sudo service vsftpd restart
echo "-----------------------"
echo "-- vsftpd installed  --"
echo "-----------------------"


echo "----------------------------"
echo "-- installing go language --"
echo "----------------------------"
sudo apt-get -y install golang
echo "---------------------------"
echo "-- go language installed --"
echo "---------------------------"


# torrent client
. $INSTALLDIR/install/deluge.sh
#. $INSTALLDIR/install/transmission.sh

echo "---------------------------"
echo "-- installing vim editor --"
echo "---------------------------"
sudo apt-get -y install vim
sudo cp $INSTALLDIR/files/vim/distinguished.vim /usr/share/vim/vim??/colors
sudo cp /etc/vim/vimrc /etc/vim/vimrc.bak
sudo cp $INSTALLDIR/files/vim/.vimrc /etc/vim/vimrc
echo "--------------------------"
echo "-- vim editor installed --"
echo "--------------------------"

echo "-------------------------"
echo "-- Installing miniDLNA --"
echo "-------------------------"
sudo apt-get -y install minidlna
sudo usermod -a -G usb1 minidlna
sudo cp /etc/minidlna.conf /etc/minidlna.conf.bak
echo "media_dir=V,/home/pi/Movies\nmedia_dir=V,/home/pi/Series\n" | sudo tee -a >/etc/minidlna.conf
sudo service minidlna force-reload
echo "------------------------"
echo "-- miniDLNA INSTALLED --"
echo "------------------------"

echo "------------------------"
echo "-- GateOne SSH on web --"
echo "------------------------"
cd /home/pi/tmp
rm -fr /home/pi/tmp/*
wget https://github.com/downloads/liftoff/GateOne/gateone_1.1-1_all.deb
sudo dpkg -i gateone_1.1-1_all.deb 
sudo apt-get -y install python-tornado python-imaging dtach
sudo cp /opt/gateone/server.conf /opt/gateone/server.conf.bak
sudo cp $INSTALLDIR/files/gateone.server.conf.txt /opt/gateone/server.conf
sudo service gateone start
echo "------------------------"
echo "-- GateOne SSH on web --"
echo "------------------------"


echo "------------------------"
echo "-- Midnight Commander --"
echo "------------------------"
sudo apt-get -y install mc
echo "------------------------"
echo "-- Midnight Commander --"
echo "------------------------"


echo "------------------------------"
echo "-- Installing unrar-nonfree --"
echo "------------------------------"
echo "deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
cd /home/pi/tmp
sudo apt-get -y build-dep unrar-nonfree
sudo apt-get -y source -b unrar-nonfree
sudo dpkg -i unrar_4.1.4-1_armhf.deb
rm -fr /home/pi/tmp/*
echo "-----------------------------"
echo "-- unrar-nonfree installed  --"
echo "-----------------------------"


echo "---------------------"
echo "-- get moar memory --"
echo "---------------------"
echo "gpu_mem=16" | sudo tee -a /boot/config.txt  # we don't need freaking GPU mem - OK maybe 16kB

echo "---------------------"
echo "-- Install No-ip --"
echo "---------------------"
mkdir /home/pi/noip
cd /home/pi/noip
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
tar vzxf noip-duc-linux.tar.gz
cd noip-2.1.9-1
sudo make
sudo make install
sudo cp $INSTALLDIR/files/noip /etc/init.d/
sudo chmod 755 /etc/init.d/noip
sudo update-rc.d noip defaults
sudo /etc/init.d/start start


echo "-------------------------------"
echo "-- update raspberry firmware --"
echo "-------------------------------"
sudo rpi-update


echo "-----------------------------------------------------------"
echo "everything done - rebooting to get everything nice and tidy"
echo "-----------------------------------------------------------"
sudo reboot
