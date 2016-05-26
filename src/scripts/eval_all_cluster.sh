# qsub -N evalFb -t 1-10 eval_in_cluster.py HED     read_one_cont_png fb 1 10
qsub -N evalFb -t 1-10 eval_in_cluster.py LEP     read_one_lep      fb 0 10
qsub -N evalFb -t 1-10 eval_in_cluster.py MCG     read_one_ucm      fb 0 10
# qsub -N evalFb -t 1-10 eval_in_cluster.py ISCRA   read_one_ucm      fb 0 10
qsub -N evalFb -t 1-10 eval_in_cluster.py gPb-UCM read_one_ucm      fb 0 10
qsub -N evalFb -t 1-10 eval_in_cluster.py NWMC    read_one_ucm      fb 0 10
qsub -N evalFb -t 1-10 eval_in_cluster.py IIDKL   read_one_ucm      fb 0 10
qsub -N evalFb -t 1-10 eval_in_cluster.py EGB     read_one_prl      fb 0 10
qsub -N evalFb -t 1-10 eval_in_cluster.py MShift  read_one_prl      fb 0 10
qsub -N evalFb -t 1-10 eval_in_cluster.py NCut    read_one_prl      fb 0 10