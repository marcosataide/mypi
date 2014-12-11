echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "------------------- Installing deluge torrent client --------------------"
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu precise main 
deb-src http://ppa.launchpad.net/deluge-team/ppa/ubuntu precise main" | sudo tee -a /etc/apt/sources.list
sudo apt-key adv --recv-keys --keyserver pgp.surfnet.nl 249AD24C
sudo apt-get update
sudo apt-get -y install -t precise deluge-common deluged deluge-web deluge-console
sudo apt-get -y install -t precise libtorrent-rasterbar6 python-libtorrent

sudo adduser --system --group --home /var/lib/deluge deluge
sudo adduser pi deluge
sudo adduser deluge usb1

sudo cp $INSTALLDIR/files/deluge/default.deluge-daemon.sh /etc/default/deluge-daemon
sudo cp $INSTALLDIR/files/deluge/init.d.deluge-daemon.sh /etc/init.d/deluge-daemon
sudo cp $INSTALLDIR/files/deluge/logrotate.txt /etc/logrotate.d/deluge
sudo chmod 755 /etc/init.d/deluge-daemon
sudo update-rc.d deluge-daemon defaults
sudo mkdir -p /var/log/deluge/daemon
sudo mkdir /var/log/deluge/web
sudo chmod -R 755 /var/log/deluge
sudo chown -R deluge /var/log/deluge
sudo chmod -R 755 /var/lib/deluge
sudo chown -R deluge /var/lib/deluge


sudo invoke-rc.d deluge-daemon start
echo "----------------------DONEDONEDONEDONEDONE-------------------------------"
echo "----------------------DONEDONEDONEDONEDONE-------------------------------"
echo "----------------------DONEDONEDONEDONEDONE-------------------------------"
echo "------------------- Installed deluge torrent client ---------------------"
echo "-------------- to set up go to http://192.168.1.128:8112 ----------------"
echo "----------------------DONEDONEDONEDONEDONE-------------------------------"
echo "----------------------DONEDONEDONEDONEDONE-------------------------------"
echo "----------------------DONEDONEDONEDONEDONE-------------------------------"
