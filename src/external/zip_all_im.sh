#!/bin/bash

# compress all im separately to im.zip files

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
	echo "Compressing im files in $dname"
	cd $dname
	ls *.im | while read imname
	do
		echo "Compressing $imname"
		zip "$imname".zip "$imname"
		echo "Removing $imname"
		rm "$imname"
	done
	ls -la *.zip
	cd ..
done

cd $olddir

