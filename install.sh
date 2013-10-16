#!/bin/bash

munindir="/etc/munin"
muninhtmldir="/var/lib/munin/www"

sed -i -e 's/htmldir.*/htmldir ${muninhtmldir}/g' `pwd`/munin-mobile.conf

echo ""
echo "Mobile Munin Template Installer"
echo ""
echo "This will create the following directories: "
echo " .${muninhtmldir}/mobile"
echo " .${munindir}/templates-mobiles"
echo ""
echo "And copy the following files:"
echo " ./munin-mobile.conf   -> ${munindir}/munin-mobile.conf"
echo " ./templates-mobiles/* -> ${munindir}/templates-mobiles/"
echo " ./mobile-www/*        -> ${muninhtmldir}/mobile/*"
echo " ./update-mobile.sh    -> ${munindir}/update-mobile.sh"
echo ""
echo "It also sets the permissions to the same as your munin files"
echo ""
echo "############################################################"
echo ""

if [ $1 ]
then
    if [ $1 == "--auto" ]
    then
	    echo "- Auto-continue supplied as argument"
	    continue='Y'
     else
	echo -n "Continue? [Y]: "
	read continue
     fi
else
    echo -n "Continue? [y]: "
    read continue
fi

if [[ $continue == "Y" || $continue == "y" ]]; then
        echo "- Continuing..."
        echo ""
else
        echo "OK, exiting."
        exit
fi

if [ -f ${munindir}/munin-mobile.conf ]
then
    echo "-  ${munindir}/munin-mobile.conf       - file exists! (not copied)"
else
    echo "- ./munin-mobile.conf -> ${munindir}/munin-mobile.conf"
    cp `pwd`/munin-mobile.conf ${munindir}/munin-mobile.conf    
    chown ${munindir}/munin-mobile.conf --reference=${munindir}/munin.conf
fi    

echo "- ./templates-mobiles                 -> ${munindir}/templates-mobiles"

if [ ! -d ${munindir}/templates-mobiles ]
then
    mkdir ${munindir}/templates-mobiles
fi

cp `pwd`/templates-mobiles/* ${munindir}/templates-mobiles/
chown -R ${munindir}/templates-mobiles --reference=${munindir}/templates

echo "- ./mobile-www                        -> ${muninhtmldir}/mobile"

if [ ! -d ${muninhtmldir}/mobile ]
then
    mkdir ${muninhtmldir}/mobile
fi

cp -r `pwd`/mobile-www/* ${muninhtmldir}/mobile
chown -R ${muninhtmldir}/mobile --reference=${muninhtmldir}

echo "- ./update-mobile.sh                 -> ${munindir}/update-mobile.sh"

cp update-mobile.sh ${munindir}/
chown ${munindir}/update-mobile.sh --reference=${munindir}/munin-mobile.conf

chmod 755 ${munindir}/update-mobile.sh

echo ""
echo "Finished!"
