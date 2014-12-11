echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "----------- installing torrent client - transmission-daemon -------------"
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
sudo apt-get -y install transmission-daemon
sudo service transmission-daemon stop
sudo usermod -a -G debian-transmission pi 
sudo usermod -a -G usb1 debian-transmission
cd /etc/transmission-daemon
sudo cp settings.json settings.json.bak
sudo cp $INSTALLDIR/files/transmission/settings.json settings.json
sudo chown debian-transmission -R /var/lib/transmission-daemon
sudo chown debian-transmission -R /etc/transmission-daemon
sudo chmod 664 /etc/transmission-daemon/settings.json 
sudo service transmission-daemon start
echo "---------------------DONEDONEDONEDONEDONEDONEDONE------------------------"
echo "---------------------DONEDONEDONEDONEDONEDONEDONE------------------------"
echo "---------------------DONEDONEDONEDONEDONEDONEDONE------------------------"
echo "----------- installing torrent client - transmission-daemon -------------"
echo "---------------------DONEDONEDONEDONEDONEDONEDONE------------------------"
echo "---------------------DONEDONEDONEDONEDONEDONEDONE------------------------"
echo "---------------------DONEDONEDONEDONEDONEDONEDONE------------------------"
