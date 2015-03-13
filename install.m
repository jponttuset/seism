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

% Set the dependencies path
segbench_path = '/path/to/segbench';

% Install BSDS300 segbench code
if exist(segbench_path,'dir')==0
    disp('!!! Warning !!!')
    disp('BSDS300 segbench path not found: You will not be able to compute the precision-recall for boundaries measure')
else
    addpath(genpath(segbench_path));
    if exist('correspondPixels')~=3 %#ok<EXIST>
        disp('!!! Warning !!!')
        disp('The needed function (correspondPixels) not found in segbench. Have you compiled it properly?')
    end
end

% Check that 'root_dir' has been set
if ~exist(root_dir,'dir')
    error('Error installing the package, try updating the value of root_dir in the file "root_dir.m"')
end

% Check that 'root_dir' has the needed folder
if ~exist(fullfile(root_dir,'lib'),'dir')
    error('Error installing the package, the folder "lib" not found')
end
if ~exist(fullfile(root_dir,'src'),'dir')
    error('Error installing the package, the folder "src" not found')
end

% Install own lib
addpath(root_dir);
addpath(fullfile(root_dir,'lib'));
addpath(fullfile(root_dir,'cvpr2013'));
addpath(genpath(fullfile(root_dir,'src')));

% Check that the needed functions are compiled
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