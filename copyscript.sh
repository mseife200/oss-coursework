#!/bin/bash

#If there is not exactly one parameter given show message and exit.
if [ $# -ne 1 ] 
then
echo "Usage: copyscript.sh <filename>"
echo "Easy as that."
exit
fi

#check if a file was provided as parameter
if [ ! -f $1 ]
then
echo Parameter must be a file.
exit
fi

#check if httpd is already running. If not start httpd
#grep here only shows httpd processes run with UID apache.

httpd_processes=`ps -ef | grep '^apache.*httpd'`
if [ -z "$httpd_processes" ]
then
echo Trying to start httpd
service httpd start
else
echo httpd is already running
fi


#check if one of the temporary files used already exist
if [ -f /tmp/inputfile.sha1 -o -f /tmp/inputfile.md5 ]
then
echo One of the temporary files already exists please remove them first.
exit
fi

#create hashes to compare downloaded and given files
#awk removes the file names at the end of the hash

sha1sum $1 | awk '{print $1}' > /tmp/inputfile.sha1
md5sum $1 | awk '{print $1}' > /tmp/inputfile.md5

#copy the file to the new serving directory
cp $1 /var/www/html/sub/

#Download the file via http from localhost
curl http://localhost/sub/$1 > /tmp/downloadfile.tmp

#Create diff of both hashes
#awk again removes the file names

sha1diff=`sha1sum /tmp/downloadfile.tmp | awk '{print $1}' | diff /tmp/inputfile.sha1 -`
md5diff=`md5sum /tmp/downloadfile.tmp | awk '{print $1}' | diff /tmp/inputfile.md5 -`

#Checking if the diff of both hashes is empty. If so, the download was succesful
if [ -z $sha1diff -a -z $md5diff ]
then
echo md5 and sha1 both are matching. Download succesful
else
echo Found difference in hashes. Download was not successful
fi 

#remove temporary files
rm /tmp/inputfile.sha1
rm /tmp/inputfile.md5
