#!/bin/bash

# de-compress all *.tar.gz files created by lans_backup.sh

ls *.tar.gz | while read fname
do
	echo "Decompressing $fname"
	tar -zxf $fname
done

