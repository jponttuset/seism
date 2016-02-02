% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  June 2013
% ------------------------------------------------------------------------ 
%  Code obtained from:
%  https://imatge.upc.edu/web/resources/supervised-evaluation-image-segmentation
% ------------------------------------------------------------------------
% This file is part of the SEISM package presented in:
%    Jordi Pont-Tuset, Ferran Marques,
%    "Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
%    Computer Vision and Pattern Recognition (CVPR), 2013.
% If you use this code, please consider citing the paper.
% ------------------------------------------------------------------------ 
% Dependencies:
% - BSDS300 segbench code
% (http://www.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/code/segbench.tar.gz)
% 
% The path below corresponds to the folder where the package is installed.
% ------------------------------------------------------------------------ 

% Check that 'seism_root' has been set
if ~exist(seism_root,'dir')
    error('Error installing the package, try updating the value of seism_root in the file "seism_root.m"')
end

% Check that 'seism_root' has the needed folder
if ~exist(fullfile(seism_root,'lib'),'dir')
    error('Error installing the package, the folder "lib" not found')
end
if ~exist(fullfile(seism_root,'src'),'dir')
    error('Error installing the package, the folder "src" not found')
end

% Install own lib
addpath(seism_root);
addpath(fullfile(seism_root,'lib'));
addpath(genpath(fullfile(seism_root,'src')));

% Check that the needed functions are compiled
if exist('correspondPixels')~=3 %#ok<EXIST>
    disp('The needed function (correspondPixels) not found in piotr_edges.')
end
if exist('mex_eval_segm')~=3 %#ok<EXIST>
    error('The needed function (mex_eval_segm) not found. Have you build the package properly?')
end
if exist('mex_prl_read')~=3 %#ok<EXIST>
    error('The needed function (mex_prl_read) not found. Have you build the package properly?')
end
if exist('mex_prl_write')~=3 %#ok<EXIST>
    error('The needed function (mex_prl_write) not found. Have you build the package properly?')
end
disp('SEISM installed properly');