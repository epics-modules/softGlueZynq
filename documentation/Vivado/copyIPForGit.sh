#!/bin/sh
# copyIPForGit
# Copy the minimal set of files from a Vivado custom IP project directory to a
# directory suitable for inclusion into a github repository
if [ $# -lt 2 ]; then
	printf "%s\n" "usage: copyIPForGit.sh source_dir ip_repo_dir"
	printf "%s\n" "example: copyIPForGit.sh ~/zynq/VivadoProjects/ip_repo/IP/gateDly ./ip"
	exit
fi

source_dir=$1
ip_repo_dir=$2

source_dirname=`basename $source_dir`
if [ ! -d ${ip_repo_dir}/$source_dirname ]; then
	echo "mkdir -p ${ip_repo_dir}/$source_dirname"
	mkdir -p ${ip_repo_dir}/$source_dirname
fi
cp $source_dir/component.xml ${ip_repo_dir}/$source_dirname

if [ ! -d ${ip_repo_dir}/$source_dirname/src ]; then
	echo "mkdir -p ${ip_repo_dir}/$source_dirname/src"
	mkdir -p ${ip_repo_dir}/$source_dirname/src
fi
cp $source_dir/src/* ${ip_repo_dir}/$source_dirname/src

if [ ! -d ${ip_repo_dir}/$source_dirname/xgui ]; then
	echo "mkdir -p ${ip_repo_dir}/$source_dirname/xgui"
	mkdir -p ${ip_repo_dir}/$source_dirname/xgui
fi
cp $source_dir/xgui/* ${ip_repo_dir}/$source_dirname/xgui
