echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
echo "--  Setting up dnsexit dynamic dns updating so that http://arloesol.com points to our PI  --"
echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
# setting up dnsexit dynamic DNS to link to the pi -- koenbeek & the classic passwd
cd /home/pi/tmp
wget http://downloads.dnsexit.com/ipUpdate-1.6-3.deb
sudo dpkg -i ipUpdate-1.6-3.deb
sudo perl -i.bak -p -e 's/^exit 0$/#dnsexit\n\/etc\/init.d\/ipUpdate start\n\nexit 0/' /etc/rc.local
sudo usr/sbin/dnsexit-setup.pl
sudo cp /etc/init.d/ipUpdate /etc/init.d/ipUpdate.bak
sudo cp $INSTALLDIR/files/dnsexit/init.d /etc/init.d/ipUpdate
sudo /etc/init.d/ipUpdate start
echo "---------------------------DONEDONEDONEDONEDONEDONEDONEDONE---------------------------------"
echo "---------------------------DONEDONEDONEDONEDONEDONEDONEDONE---------------------------------"
echo "---------------------------DONEDONEDONEDONEDONEDONEDONEDONE---------------------------------"
echo "--  Setting up dnsexit dynamic dns updating so that http://arloesol.com points to our PI  --"
echo "---------------------------DONEDONEDONEDONEDONEDONEDONEDONE---------------------------------"
echo "---------------------------DONEDONEDONEDONEDONEDONEDONEDONE---------------------------------"
echo "---------------------------DONEDONEDONEDONEDONEDONEDONEDONE---------------------------------"