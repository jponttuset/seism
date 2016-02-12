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
% Simple demo of how to use the package.
% For a realistic use, see "pr_curves.m".
%
% ------------------------------------------------------------------------ 

% List of measures to compute
measures = {%
            'fb'  ,... % Precision-recall for boundaries
            'fop' ,... % Precision-recall for objects and parts
            'fr'  ,... % Precision-recall for regions
            'voi' ,... % Variation of information
            'nvoi',... % Normalized variation of information
            'pri' ,... % Probabilistic Rand index
            'sc'  ,'ssc' ,... % Segmentation covering (two directions)
            'dhd' ,'sdhd',... % Directional Hamming distance (two directions)
            'bgm' ,... % Bipartite graph matching
            'vd'  ,... % Van Dongen
            'bce' ,... % Bidirectional consistency error
            'gce' ,... % Global consistency error
            'lce' ,... % Local consistency error
            };
        
% Compare a ground truth partition against the others
gt_seg = db_gt('BSDS500','120003');
partition = gt_seg{1};
gt        = gt_seg(2:3);

% Compute all available measures
home
disp('Computing measures...')
for ii=1:length(measures)
    tic
    result = eval_segm(partition, gt, measures{ii});
    disp([measures{ii} repmat(' ',1,6-length(measures{ii})) ': ' num2str(result) '   (' sprintf('%.3f',toc) 's.)'])
end
disp('Done!')
