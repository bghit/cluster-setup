#!/bin/bash


DIR="$(cd "`dirname "$0"`"; pwd)"

HOSTS=$DIR/dashosts

HADOOP_CONF=$HADOOP_HOME/etc/hadoop
SPARK_CONF=$SPARK_HOME/conf/
TACHYON_CONF=$TACHYON_HOME/conf
PARTITION="\/local\/$USER\/hdfs-`date +%s`"

cmd=`cat $HOSTS`
set -- $cmd
MASTER=$1
shift

IP=`ssh $MASTER /sbin/ifconfig ib0 | grep 'inet ' | awk '{print $2}'`
echo "Master: " $MASTER $IP

rm $HADOOP_CONF/slaves $SPARK_CONF/slaves $TACHYON_CONF/workers

for var in $@
do
   echo "Worker: " $var
   echo $var >> $HADOOP_CONF/slaves
   echo $var >> $SPARK_CONF/slaves
   echo $var >> $TACHYON_CONF/workers
done

echo $PARTITION
## update Hadoop core-site.xml: IP address of the namenode and the local storage.
cp $DIR/templates/core-site.xml $HADOOP_CONF
sed -i "s/%%MASTER%%/hdfs:\/\/${IP}/g" $HADOOP_CONF/core-site.xml
cp $DIR/templates/hdfs-site.xml $HADOOP_CONF
sed -i "s/%%STORAGE%%/${PARTITION}/g" $HADOOP_CONF/hdfs-site.xml

## update Spark default parameters: master IP address and the username
cp $DIR/templates/spark-defaults.conf $SPARK_CONF
cp $DIR/templates/spark-env.sh $SPARK_CONF
sed -i "s/%%MASTER%%/${MASTER}/g" $SPARK_CONF/spark-defaults.conf
sed -i "s/%%MYUSERNAME%%/${USER}/g" $SPARK_CONF/spark-defaults.conf

## update Tachyon configuration file: namenode IP address and the username
cp $DIR/templates/tachyon-env.sh $TACHYON_CONF
sed -i "s/%%MASTER%%/${IP}/g" $TACHYON_CONF/tachyon-env.sh
sed -i "s/%%MYUSERNAME%%/${USER}/g" $TACHYON_CONF/tachyon-env.sh


