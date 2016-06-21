% function measure = eval_cont( contours, ground_truth )
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
function measure = eval_cont( contours, ground_truth, maxDist, kill_internal,lkup )

if nargin<3,
    maxDist = 0.0075;
end
if nargin<4,
    kill_internal = 0;
end
if nargin<5,
    lkup = [];
end

% If a single ground_truth, convert it to cell
if ~iscell(ground_truth)
    ground_truth = {ground_truth};
end

% Check same sizes
if ~isequal(size(contours),size(ground_truth{1}))
    error('''contours'' and ''ground_truth'' must have the same size')
end

if kill_internal,
    if isempty(lkup),
        error('Look Up table for classes/instances not provided');
    else
        for ii=1 : length(unique(ground_truth{1})),
            if lkup(ii,2)>0,
                mask = (ground_truth{1}==ii);
                gt_bdry = seg2bmap(mask);
                contours = kill_internal_bdries(contours, gt_bdry, mask, maxDist);
            end
        end
    end
end

% Call Piotr's edges code
params.maxDist = maxDist;
[~,cntR,sumR,cntP,sumP] = edgesEvalImg(contours,ground_truth,params);

% Compute precision-recall
if sumR==0
    if cntP~=0
        error('Something wrong with this result')
    else
        rec = 1;
        prec = 0;
    end
elseif sumP==0
    if cntR~=0
        error('Something wrong with this result')
    else
        rec = 0;
        prec = 1;
    end
else
    rec = cntR/sumR;
    prec = cntP/sumP;
end

% Compute fb
if (prec+rec)==0
    fmeas = 0;
else
    fmeas = 2*prec*rec/(prec+rec);
end
measure = [fmeas, prec, rec, cntR, sumR, cntP, sumP];

end

