% function measure = eval_cont( partition, ground_truth )
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
function measure = eval_cont( contours, ground_truth )

% If a single ground_truth, convert it to cell
if ~iscell(ground_truth)
    ground_truth = {ground_truth};
end

% Call Piotr's edges code
[~,cntR,sumR,cntP,sumP] = edgesEvalImg(contours,ground_truth);

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
measure = [fmeas, prec, rec];

end

