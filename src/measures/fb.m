function [precision, recall, matching] = fb(segmentation,ground_truth,contour_grid)
% [precision, recall, matching] = fb(segmentation,ground_truth,contour_grid)
%
% Calculates precision/recall for boundaries between segmentation and
% ground_truth.
% ------------------------------------------------------------------------
% INPUT
%	segmentation      Segmentation.
%	ground_truth      Ground-truth segmentation or multiple in a cell.
%   contour_grid[1]   Work on the pixel grid [0] (as in the original BSDS)
%                     or on the contour grid [1].
%
% OUTPUT
%	precision	Precision for boundaries.
%	recall   	Recall for boundaries.
%	matching   	Struct describing the matched pixels
%
% NOTE 
%   BSDS300 segbench must be compiled and added to the matlab path
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
% Part of this file is extracted from segbench code:
%  David Martin <dmartin@eecs.berkeley.edu>
%  January 2003
% ------------------------------------------------------------------------ 
if nargin<3
    contour_grid = 1;
end

if iscell(ground_truth) % Multiple ground truth
    num_gt = length(ground_truth);
    if contour_grid==0  % Work on the pixel grid
        error('Not implemented');
    else
        if nargout>3
            error('Too many output arguments')
        end
        if nargout==1 || nargout==2
            seg = seg2gridbmap(segmentation);
            sumR = 0; cntR = 0; sumP = 0; cntP = 0;

            % accumulate machine matches, since the machine pixels are
            % allowed to match with any segmentation
            accP = zeros(size(seg));
            % compare to each seg in turn
            for ii = 1:num_gt,
                curr_gt = seg2gridbmap(ground_truth{ii});
                
                % compute the correspondence
                [match1,match2] = correspondPixels(seg,curr_gt);
                
                % accumulate machine matches
                accP = accP | match1;
                
                % compute recall
                sumR = sumR + sum(curr_gt(:));
                cntR = cntR + sum(match2(:)>0);
            end
            % compute precision
            sumP = sumP + sum(seg(:));
            cntP = cntP + sum(accP(:));
            
            if sumR==0
                if cntP~=0
                    error('Something wrong with this result')
                else
                    recall = 1;
                    precision = 0;
                end
            elseif sumP==0
                if cntR~=0
                    error('Something wrong with this result')
                else
                    recall = 0;
                    precision = 1;
                end
            else
                recall = cntR/sumR;
                precision = cntP/sumP;
            end
        end
        if nargout==3
            error('Not implemented');
        end
    end
else % Single ground truth
    if contour_grid==0  % Work on the pixel grid
        if nargout>2
            error('Too many output arguments')
        end

        seg_bmap = seg2bmap(segmentation);
        gt_bmap = seg2bmap(ground_truth);

        seg_thin = double(bwmorph(seg_bmap,'thin',inf));
        gt_thin  = double(bwmorph(gt_bmap ,'thin',inf));
        [match1,match2] = correspondPixels(seg_thin, gt_thin);

        recall = sum(match1(:)>0)/sum(gt_bmap(:)>0);
        precision = sum(match2(:)>0)/sum(seg_bmap(:)>0);
    else
        if nargout>3
            error('Too many output arguments')
        end
        if nargout==1 || nargout==2
            % Segmentation to boundray map
            seg = seg2gridbmap(segmentation);
             gt = seg2gridbmap(ground_truth);

            % Match boundary
            [match1,match2] = correspondPixels(double(seg), double(gt));

            recall = sum(match1(:)>0)/sum(gt(:)>0);
            precision = sum(match2(:)>0)/sum(seg(:)>0);
        end

        if nargout==3
            % Segmentation to boundray map
            [seg, seg_neighs] = seg2gridbmap(segmentation);
            [ gt,  gt_neighs] = seg2gridbmap(ground_truth);

            % Match boundary
            [match1,match2] = correspondPixels(double(seg), double(gt));

            recall = sum(match1(:)>0)/sum(gt(:)>0);
            precision = sum(match2(:)>0)/sum(seg(:)>0);    

            % Create a single index from a pair of indices
            n_reg_max  = max(max( max(seg_neighs.matrix_max), max(gt_neighs.matrix_max)))+1;
            seg_neighs = seg_neighs.matrix_max + seg_neighs.matrix_min*n_reg_max;
            gt_neighs  = gt_neighs.matrix_max + gt_neighs.matrix_min*n_reg_max;

            % Unique without 0
            pairs_seg = unique(seg_neighs);
            pairs_seg = pairs_seg(2:end);
            pairs_gt  = unique(gt_neighs);
            pairs_gt  = pairs_gt(2:end);

            % Count tp_seg and fp
            matched   = (match1 >0).*seg_neighs;
            unmatched = (match1==0).*seg_neighs;
            tp_seg = zeros(size(pairs_seg));
            fp = zeros(size(pairs_seg));
            for ii = 1:length(pairs_seg)
                tp_seg(ii) = sum(sum(matched==pairs_seg(ii)));
                fp(ii) = sum(sum(unmatched==pairs_seg(ii)));
            end

            % Count tp_gt and fn
            matched   = (match2 >0).*gt_neighs;
            unmatched = (match2==0).*gt_neighs;
            tp_gt = zeros(size(pairs_gt));
            fn = zeros(size(pairs_gt));
            for ii = 1:length(pairs_gt)
                tp_gt(ii) = sum(sum(matched==pairs_gt(ii)));
                fn(ii) = sum(sum(unmatched==pairs_gt(ii)));
            end

            % Store results
            matching.seg.pairs_idx2   = mod(pairs_seg, n_reg_max);
            matching.seg.pairs_idx1   = (pairs_seg-matching.seg.pairs_idx2)/n_reg_max;
            matching.seg.pairs_idx    = pairs_seg;
            matching.seg.pairs_matrix = seg_neighs;
            matching.seg.match = match1;

            matching.gt.pairs_idx2    = mod(pairs_gt, n_reg_max);
            matching.gt.pairs_idx1    = (pairs_gt-matching.gt.pairs_idx2)/n_reg_max;
            matching.gt.pairs_idx     = pairs_gt;
            matching.gt.pairs_matrix  = gt_neighs;
            matching.gt.match = match2;

            matching.tp_gt  = tp_gt;
            matching.tp_seg = tp_seg;
            matching.fp     = fp;
            matching.fn     = fn;
        end
    end
end
end