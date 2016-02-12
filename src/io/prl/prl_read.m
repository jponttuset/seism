function partition = prl_read( filename )
% partition = prl_read( filename )
%  Reads a partition saved in PRL (Partition Run Length). See 'doc' for description of the format
%
% INPUT
%   filename  : File where the partition is stored
% OUTPUT
%   partition : Output partition in unsigned 32-bit integers (uint32)
% ------------------------------------------------------------------------
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  June 2013
% ------------------------------------------------------------------------ 
%  Code available at:
%  https://imatge.upc.edu/web/resources/supervised-evaluation-image-segmentation
% ------------------------------------------------------------------------
%  This file is part of the SEISM package presented in:
%    Jordi Pont-Tuset, Ferran Marques,
%    "Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
%    Computer Vision and Pattern Recognition (CVPR), 2013.
%  If you use this code, please consider citing the paper.
% ------------------------------------------------------------------------ 
partition = mex_prl_read(filename);
