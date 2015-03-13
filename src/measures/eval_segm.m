% function measure = eval_segm( partition, ground_truth, measure )
%
% Compares partition and ground_truth according to the measure selected
% ------------------------------------------------------------------------
% INPUT
%	partition         Segmentation.
%	ground_truth      Ground-truth segmentation or multiple in a cell.
%   measure           String describing the measure. It can be:
%                     - 'fb'  : Precision-recall for boundaries
%                     - 'fop' : Precision-recall for objects and parts
%                     - 'fr'  : Precision-recall for regions
%                     - 'nvoi': % Normalized variation of information
%                     - 'voi' : % Variation of information
%                     - 'pri' : Probabilistic Rand index
%                     - 'sc','ssc'  : Segmentation covering (two directions, it is asymmetric)
%                     - 'dhd','sdhd': Directional Hamming distance (two directions, it is asymmetric)
%                     - 'bgm' : Bipartite graph matching distance
%                     - 'vd'  : Van Dongen distance
%                     - 'bce' : Bidirectional consistency error
%                     - 'lce' : Local consistency error
%                     - 'gce' : Global consistency error
%
% OUTPUT
%	measure:   Value of the measure. In the case of precision-recall 
%	           measures, it is a vector with [f-measure, precision, recall]
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
function measure = eval_segm( partition, ground_truth, measure )
if nargin<3
    measure = 'fb';
end

% If a single ground_truth, convert it to cell
if ~iscell(ground_truth)
    ground_truth = {ground_truth};
end

% Convert to uint32 and check no loss
if ~isa(partition,'uint32')
    new_partition = uint32(partition);
    if ~isequal(double(new_partition), double(partition))
        error('Partition contains some non-integer values');
    end
    partition = new_partition;
end
for ii=1:length(ground_truth)
    if ~isa(ground_truth{ii},'uint32')
        new_gt = uint32(ground_truth{ii});
        if ~isequal(double(new_gt), double(ground_truth{ii}))
            error('Partition contains some non-integer values');
        end
        ground_truth{ii} = new_gt;
    end
end

if strcmp(measure,'fb')
    % Compute  fb
    [prec, rec] = fb(partition,ground_truth); 

    if (prec+rec)==0
        fmeas = 0;
    else
        fmeas = 2*prec*rec/(prec+rec);
    end
    measure = [fmeas, prec, rec];
elseif strcmp(measure,'vd')
    dhd  = mex_eval_segm(partition, ground_truth, 'dhd');
    sdhd = mex_eval_segm(partition, ground_truth, 'sdhd');
    measure = 0.5*(dhd+sdhd);
else
    % Call C++ implementation
    measure = mex_eval_segm(partition, ground_truth, measure);
end

end

