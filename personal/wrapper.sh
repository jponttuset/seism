#!/bin/bash

for i in {1..20}
	do
		qsub -N FbRNSBD_$i -t 1-101 src/scripts/eval_in_cluster.py  ResNet50-mod-pc_40000  SBD  read_one_cont_png fb 1 101 $i
	done
