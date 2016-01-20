#!/usr/bin/python

# qsub -t 1-50 soa_eval.py LEP 50
# ----- Parameters passed to the cluster -------
#$ -S /usr/bin/python
#$ -l h_rt=0:59:00
#$ -l h_vmem=5000M
#$ -o /scratch_net/neo/jpont/logs/
#$ -e /scratch_net/neo/jpont/logs/
#$ -j y

# ------------Hard-Coded Parameters ------------
database = 'bsds500'
gt_set   = 'test'

# ----------------- Imports --------------------
import os
import numpy as np
import math
import sys

# ---------------- Functions -------------------
def file_len(fname):
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return i + 1

def file_subpart(fname,id_start,id_end):
    lines = [line.strip() for line in open(fname)]
    return lines[id_start:id_end+1]


# ------------- Get the parameters -------------
if len(sys.argv)<2:
	print "ERROR: Not enough input parameters"
  	exit(1)
else:
  	method = sys.argv[1] # Name of the folder containing the partitions or contours

if len(sys.argv)>2:
  	n_jobs = int(sys.argv[2])
else:
  	n_jobs = 1

# ---- Get the working folder (code folder) ----
code_folder = os.getcwd()
print code_folder
# Check that we are in the right folder
if not os.path.isdir(code_folder + "/datasets/"):
	print "ERROR: datasets folder not found, are you in the code folder of SEISM?"
	exit(1)
if not os.path.isdir(code_folder + "/src/") or not os.path.exists(code_folder + "/install.m"):
	print "ERROR: Source code not found, are you in the code folder of SEISM?"
	exit(1)


# ---------------- Main code -------------------
ids_file = code_folder + "/" + database + "/ids_" + gt_set + ".txt"
par_file    = code_folder + "/datasets/"+method+"/params.txt"

task_id = int(os.getenv("SGE_TASK_ID", "0"))
if task_id==0:
    task_id = 1
    n_jobs = 1
if task_id>n_jobs:
    exit(1)

print "Process " + str(task_id) + " out of " + str(n_jobs)
sys.stdout.flush()

# Get the total number of images
n_pars = file_len(par_file)
n_ims  = file_len(ids_file)
print n_ims
exit()
# Get the positions that this process will handle
jobs_per_child = int(math.floor(float(n_pars)/n_jobs))
remainder = n_pars%n_jobs

# We put the remainder to the first 'remainder' jobs
if task_id<=remainder:
    id_start = (jobs_per_child+1)*(task_id-1)+1
    id_end   = (jobs_per_child+1)*(task_id)
else:
    id_start = (jobs_per_child+1)*remainder + jobs_per_child*(task_id-1-remainder) + 1
    if task_id==n_jobs:
        id_end = n_pars
    else:
        id_end = id_start+jobs_per_child-1

print 'id_start='+str(id_start)
print 'id_end='+str(id_end)

# Get all parameters
all_params = [line.rstrip('\n') for line in open(par_file)]

# Run the actual code
os.chdir(code_folder)
for ii in range(id_start-1,id_end):
    res_file = code_folder + "/results/"+method+"/test_fb_"+all_params[ii]+".txt"
    run = 1;
    if os.path.isfile(res_file):
        print 'Found: ' + res_file
        if file_len(res_file)==n_ims:
            run = 0;

    if run==1:
        command_to_run = "/usr/sepp/bin/matlab -nodesktop -nodisplay -nosplash -r \"install;eval_method('"+method+"','"+all_params[ii]+"','fb',@read_one_cont_png,'"+gt_set+"',"+str(n_ims)+",1);exit\""
        os.system(command_to_run)

