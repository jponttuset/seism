[OUTDATED README - TODO]

This file is the README file of the package "SEISM.zip", which
contains the code of the segmentation evaluation measures presented in:

Jordi Pont-Tuset, Ferran Marques,
"Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
Computer Vision and Pattern Recognition (CVPR), 2013.

All the results, figures, and tables of the paper are reproducible
using this code.

To install the package:

1) Uncompress "SEISM.tgzÄù for instance to:
   /home/$usr/seism
   This should contain six folders "bsds500", "cvpr2013", "doc", "lib", "results", and "src".

2) Modify the file seism_root.m to point to the path where the package was
   extracted (in the example /home/$usr$/seism)

3) BUILD: For mac64 and linux64 architectures, the library comes pre-built.
   If for some reason you need to rebuild it, see "build.m"

4) INSTALL: Read the header of the file "install.m" and modify the dependency
   path where you have BSDS300 segbench installed.

5) Run the script "install.m", which adds the needed folders to the
   MATLAB path and checks the dependencies. You can add the paths permanently 
   if you do not want to run this script each time. This script checks for 
   the dependencies needed and will prompt any error it finds.

For a basic use of the mesures use "eval_segm" (see "demo.m")

To evaluate your method in the precision-recall environment (recommended), see "pr_curves.m".

To reproduce the full results of the paper: see the folder "cvpr2013".

Enjoy! (And please cite the paper if you use this code.)
