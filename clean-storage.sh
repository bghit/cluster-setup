#!/bin/bash


cmd=`cat dashosts`

set -- $cmd

for var in $@
do
	echo $var
	ssh $var rm -rf /local/bghit/hdfs-*
done
