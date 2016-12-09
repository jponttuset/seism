![seism](seism.png)

Code package that implements the image segmentation measures and reproduces all results from the papers:

**Supervised Evaluation of Image Segmentation and Object Proposal Techniques**<br/>
Jordi Pont-Tuset and Ferran Marques, TPAMI 2015.

**Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation**<br/>
Jordi Pont-Tuset and Ferran Marques, CVPR 2013.

The [project page](http://vision.ee.ethz.ch/~biwiproposals/seism/) contains updated evaluation, and browsable results from all techniques.

###Version history:
**v3.0**: Generalization to Pascal Context, Pascal VOC, SBD.

**v2.1**: Bug fixes over 2.0. Stable release.

**v2.0**: Beta release that includes all experiments on the PAMI paper. It includes the following improvements:
- Easily evaluate any type of format via input converters.
- Contour detectors can also be included in the precision/recall curves.
- Updated list of state-of-the-art pre-computed results (up to ICCV 2015).
- Removed dependency from BSR.

**v1.1**: Stable release, bug fixes over v1.0, still at the CVPR level.

**v1.0**: Original beta release of the code, reproducing results of the CVPR paper.
