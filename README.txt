This file is the README file of the package SEISM, which
contains the code of the segmentation evaluation measures presented in:

Jordi Pont-Tuset, Ferran Marques,
"Supervised Evaluation of Image Segmentation and Object Proposal Techniques,"
IEEE Transactions on Pattern Analysis and Machine Intelligence (TPAMI), 2015.

Jordi Pont-Tuset, Ferran Marques,
"Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
Computer Vision and Pattern Recognition (CVPR), 2013.

All the results, figures, and tables of the paper are reproducible
using this code.

To use the package:

1) BUILD: For mac64 and linux64 architectures, the library comes pre-built.
   If for some reason you need to rebuild it, see "build.m"

2) INSTALL: Run the script "install.m", which adds the needed folders to the
   MATLAB path and checks the dependencies. You can add the paths permanently 
   if you do not want to run this script each time. This script checks for 
   the dependencies needed and will prompt any error it finds.

For a basic use of the mesures use "eval_segm" (see "demo.m")

To evaluate your method in the precision-recall environment (recommended), see "pr_curves.m".

Enjoy! (And please cite the paper if you use this code.)
