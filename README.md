# Cluster setup tools.
#############
@author: Bogdan Ghit
@date: 19.09.2015

1. reserve.sh
Simple script for reserving nodes from SLURM using prun.
Generates a file with the hostnames of the reserved nodes (dashosts).

2. configure-all.sh
Uses the dashosts file from (1) to update configuration files in Hadoop, Spark, Tachyon.
Pushes the hostnames to the config directories of each framework.

3. setup.sh
Script for starting / stopping an instance of any framework.
e.g. ./setup.sh --start --with-hadoop --with-spark

- 
