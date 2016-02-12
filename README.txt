
This file is the README file of the package SEISM, which
contains the code of the segmentation evaluation measures presented in:

Jordi Pont-Tuset, Ferran Marques,
"Supervised Evaluation of Image Segmentation and Object Proposal Techniques,"
IEEE Transactions on Pattern Analysis and Machine Intelligence (TPAMI), 2015.

Jordi Pont-Tuset, Ferran Marques,
"Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
Computer Vision and Pattern Recognition (CVPR), 2013.

Visit the project page at:
http://vision.ee.ethz.ch/~biwiproposals/seism/

All the results, figures, and tables of the paper are reproducible
using this code.


#################### USAGE ####################

1) BSDS500: Download the dataset from:
   http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html
   Then edit the file "src/gt_wrappers/db_root_dir.m" to point to the 'BSDS500'
   uncompressed folder, where there is a folder named "data."

2) BUILD: For mac64, linux64, and win64 architectures, the library comes pre-built.
   If for some reason you need to rebuild it, see "build.m."

3) INSTALL: Run the script "install.m", which adds the needed folders to the
   MATLAB path and checks the dependencies. You can add the paths permanently 
   if you do not want to run this script each time.


See "demo.m" for a basic use of the mesures use "eval_segm".
See "pr_curves.m" to evaluate your method in the precision-recall environment (recommended).

###############################################

Enjoy! (And please cite the paper if you use this code.)
