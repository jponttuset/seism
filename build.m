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
%
% This function builds all the MEX files needed.
% Dependencies: Boost libraries
%
% Not checked for windows, you (at least) will need to change the boost
% libraries location.
%
% ------------------------------------------------------------------------
function build()

%% Include paths and files to compile
include{1} = fullfile(root_dir, 'src');  % Own files
include{2} = '/opt/local/include';  % Boost libraries (change it if necessary)

build_file{1} = fullfile(root_dir, 'src', 'io', 'mex_prl_read.cpp');
build_file{2} = fullfile(root_dir, 'src', 'io', 'mex_prl_write.cpp');
build_file{3} = fullfile(root_dir, 'src', 'measures', 'mex_eval_segm.cpp');


%% %% Build everything
if ~exist(fullfile(root_dir, 'lib'),'dir')
    mkdir(fullfile(root_dir, 'lib'))
end

include_str = '';
for ii=1:length(include)
    include_str = [include_str ' -I' include{ii}]; %#ok<AGROW>
end
            
for ii=1:length(build_file)
    eval(['mex ' build_file{ii} ' -outdir ' fullfile(root_dir, 'lib') include_str])
end
