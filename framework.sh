#!/bin/bash

DEPLOY_HADOOP=false
DEPLOY_SPARK=false
DEPLOY_TACHYON=false

function exit_with_usage {
  echo "framework.sh - tool for setting up clusters of Hadoop / Spark / Tachyon"
  echo ""
  echo "Usage:"
  cl_options="[--action <start/stop>] [--with-hadoop] [--with-spark] [--with-tachyon] [--all]"
  echo "./framework.sh $cl_options"
  echo ""
  exit 1
}

while (( "$#" )); do
  case $1 in
    --action)
	ACTION=$2
	shift
    	;;
    --with-hadoop)
	DEPLOY_HADOOP=true
	;;   
    --with-spark)
	DEPLOY_SPARK=true
	;;
    --with-tachyon)
	DEPLOY_TACHYON=true
	;;
    --all)
      	DEPLOY_HADOOP=true
	DEPLOY_SPARK=true
	DEPLOY_TACHYON=true
	;;
    --help)
	exit_with_usage
	;;
    *)
   esac
   shift
done

# format and start HDFS
if [ "$DEPLOY_HADOOP" == true ]; then
   if [ "$ACTION" == "start" ]; then
      echo "> Start Hadoop."
      yes | $HADOOP_HOME/bin/hdfs namenode -format
      $HADOOP_HOME/sbin/start-dfs.sh
   elif [ "$ACTION" == "stop" ]; then
      $HADOOP_HOME/sbin/stop-dfs.sh
   fi
fi

if [ "$DEPLOY_SPARK" == true ]; then
   if [ "$ACTION" == "start" ]; then
      echo "> Start Spark."
      $SPARK_HOME/sbin/start-all.sh
   elif [ "$ACTION" == "stop" ]; then
      echo "> Stop Spark."
      $SPARK_HOME/sbin/stop-all.sh
  fi
fi

if [ "$DEPLOY_TACHYON" == true ]; then
   if [ "$ACTION" == "start" ]; then
      echo "Start Tachyon."
      $TACHYON_HOME/bin/tachyon format
      $TACHYON_HOME/bin/tachyon-start.sh all NoMount
   elif [ "$ACTION" == "stop" ]; then
      echo "Stop Tachyon."
      $TACHYON_HOME/bin/tachyon-stop.sh
      $HADOOP_HOME/bin/hdfs dfs -rmr /tmp
   fi
fi

echo "Hadoop="$DEPLOY_HADOOP "Spark="$DEPLOY_SPARK "Tachyon="$DEPLOY_TACHYON

