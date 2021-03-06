#!/bin/bash
set -e
set -x

CFG=$1
EPOCH=$2
FEAT_LIST=$3 # e.g.: "feat5", "feat4 feat5". If leave empty, the default is "feat5"
GPUS=${4:-8}
WORK_DIR=$(echo ${CFG%.*} | sed -e "s/configs/work_dirs/g")/

if [ ! -f $WORK_DIR/epoch_${EPOCH}.pth ]; then
    echo "ERROR: File not exist: $WORK_DIR/epoch_${EPOCH}.pth"
    exit
fi

bash tools/dist_extract.sh $CFG $GPUS --checkpoint $WORK_DIR/epoch_${EPOCH}.pth

bash benchmarks/svm_tools/eval_svm_full.sh $WORK_DIR $FEAT_LIST

bash benchmarks/svm_tools/eval_svm_lowshot.sh $WORK_DIR $FEAT_LIST
