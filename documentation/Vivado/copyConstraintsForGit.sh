#!/bin/sh
# copyConstraintsForGit
# Copy the minimal set of files from a Vivado custom IP project directory to a
# directory suitable for inclusion into a github repository
if [ $# -lt 2 ]; then
	printf "%s\n" "usage: copyConstraintsForGit.sh source_dir ip_repo_dir"
	printf "%s\n" "example: copyConstraintsForGit.sh ~/zynq/VivadoProjects/softGlue_3_TTL_7020_dma/softGlue_3_TTL_7020_dma.srcs/constrs_1/imports/src/ ./ip"
	exit
fi

source_dir=$1
ip_repo_dir=$2


source_dirname=`basename $source_dir`
if [ ! -d ${ip_repo_dir}/constraints ]; then
	echo "mkdir -p ${ip_repo_dir}/constraints"
	mkdir -p ${ip_repo_dir}/constraints
fi
cp $source_dir/*.xdc $ip_repo_dir/constraints
