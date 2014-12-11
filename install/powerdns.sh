echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
echo "------ Install powerdns server to redirect arloesol.no-ip.org to the PI for chromeos -------"
echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
# info from here http://www.ducky-pond.com/posts/2013/Oct/how-to-setup-a-dns-server-with-powerdns-on-raspberry-pi/
sudo apt-get -y install pdns-server
sudo apt-get -y install dnsutils

sudo sed -i 's/# recursor=/recursor=8.8.8.8/g' /etc/powerdns/pdns.conf
sudo sed -i 's/allow-recursion=127.0.0.1/allow-recursion=127.0.0.1,192.168.0.0\/24,192.168.1.0\/24/g' /etc/powerdns/pdns.conf

sudo mkdir /etc/powerdns/bind
sudo cp $INSTALLDIR/files/powerdns/bindbackend.txt /etc/powerdns/bindbackend.conf
# arloesol.com
sudo cp $INSTALLDIR/files/powerdns/arloesol.com.txt /etc/powerdns/bind/arloesol.com.zone 
# spanish.arloesol.com
sudo cp $INSTALLDIR/files/powerdns/spanish.arloesol.com.txt /etc/powerdns/bind/spanish.arloesol.com.zone 


sudo service pdns restart
echo "------------------------DONEDONEDONEDONEDONEDONEDONEDONEDONE--------------------------------"
echo "------------------------DONEDONEDONEDONEDONEDONEDONEDONEDONE--------------------------------"
echo "------------------------DONEDONEDONEDONEDONEDONEDONEDONEDONE--------------------------------"
echo "------ Install powerdns server to redirect arloesol.com to the PI needed for chromeos ------"
echo "------------------------DONEDONEDONEDONEDONEDONEDONEDONEDONE--------------------------------"
echo "------------------------DONEDONEDONEDONEDONEDONEDONEDONEDONE--------------------------------"
echo "------------------------DONEDONEDONEDONEDONEDONEDONEDONEDONE--------------------------------"
echo "TODO   TODO   TODO   TODO"
echo "TODO   TODO   TODO   TODO"
echo "TODO   TODO   TODO   TODO"
echo "   Set DNS on chromeos to 192.168.1.128 "
echo "   follow http://www.pocketables.com/2013/03/how-to-use-change-the-dns-settings-on-your-chromebook-and-use-googles.html"
echo "   chrome://flags  --- set 'Expirimental static ip configuration' to enabled  --- restart  -- change connection settings"
echo "TODO   TODO   TODO   TODO"
echo "TODO   TODO   TODO   TODO"
echo "TODO   TODO   TODO   TODO"
