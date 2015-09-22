#!/bin/bash

DIR="$(cd "`dirname "$0"`"; pwd)"
HOSTS=$DIR/dashosts

# default parameter values
WALLTIME="00:30:00"
NP=5

function exit_with_usage {
  echo "reserve.sh - tool for reserving nodes from the local cluster"
  echo ""
  echo "Usage:"
  echo "./reserve.sh [--np] [--time]"
  echo ""
  exit 1
}

rm $HOSTS

while (( "$#" )); do
  case $1 in
    --time)
	WALLTIME=$2
        shift
	;;
    --np)
	NP=$2
	shift
	;;
    --help)
        exit_with_usage
	;;
    *)
   esac
   shift
done

echo $NP $WALLTIME
preserve -t $WALLTIME -np $NP #-q gpu.q
sleep 2

cmd=`preserve -llist | grep $USER`
set -- $cmd

for var in $@
do
   echo $var | grep "node" >> $HOSTS
done
