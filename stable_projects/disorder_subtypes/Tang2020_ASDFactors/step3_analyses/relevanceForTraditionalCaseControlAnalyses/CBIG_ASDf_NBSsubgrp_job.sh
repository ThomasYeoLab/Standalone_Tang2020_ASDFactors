#!/bin/sh
#
# Script to submit jobs to cluster to perform NBS for comparing RSFC between ASD & controls in subgroups
#
# Written by Siyi Tang and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

tThresh=$1
id_asd_subgrp=$2
id_con_subgrp=$3
id_asd=$4
id_con=$5
sub_info_file=$6
Nperm=$7
output_name=$8
output_dir=$9

CODE_DIR=${CBIG_CODE_DIR}/stable_projects/disorder_subtypes/Tang2020_ASDFactors
script_dir=${CODE_DIR}/step3_analyses/relevanceForTraditionalCaseControlAnalyses

mkdir -p ${output_dir}/job_logs
LF=${output_dir}/job_logs/${output_name}.log
date >> $LF

progressFile=${output_dir}/progressFile.txt
rm -rf ${progressFile}
touch ${progressFile}

echo "====SOFTWARE VERSION====" >> $LF
env | grep FREESURFER_HOME >> $LF
env | grep FSL_DIR >> $LF
env | grep CBIG_SPM_DIR >> $LF


########## Run Network-based statistic ############

/apps/sysapps/TORQUE/bin/qsub -V -q circ-spool << EOJ


#!/bin/sh

#PBS -N 'nbs'
#PBS -l walltime=5:00:0
#PBS -l mem=8gb
#PBS -e ${output_dir}/job_logs/${output_name}.err
#PBS -o ${output_dir}/job_logs/${output_name}.out

        cd ${script_dir}
        matlab -nodisplay -nosplash -nodesktop -r \
        "clear all;close all;clc; \
        CBIG_ASDf_FCDiffInSubgrp_NBS(${tThresh},'${id_asd_subgrp}',\
        '${id_con_subgrp}','${id_asd}','${id_con}','${sub_info_file}', \
        ${Nperm},'${output_name}');exit;" >> $LF
        echo -e "Completed" >> ${progressFile}
EOJ

