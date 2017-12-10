#!/bin/bash

# compress all directories created by LANS

olddir=$(pwd)

if [ -z "$1" ]
then 
	newdir=$(pwd)
else
	newdir=$1
fi

cd $newdir

ls -d */ | while read dname
do
	dname=$(echo $dname |sed 's/\///') 
	echo "Backing up $dname"
	tar --exclude=*.*im* --exclude-backups -zcf "$dname.tar.gz" $dname
done

echo "List of created tar-balls in $newdir:"
ls -la *.tar.gz

cd $olddir
