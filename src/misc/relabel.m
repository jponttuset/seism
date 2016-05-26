function relabeled = relabel(partition)
% relabeled = relabel(partition)
%
% Relabels connected regions in the partition, sweeping from left to right
% and from up to down. See tests for examples.
% ------------------------------------------------------------------------
% INPUTS
%       partition        Partition to relabel
%
% OUTPUTS
%   relabeled    Relabeled partition
% ------------------------------------------------------------------------
%  Copyright (C)
%  Universitat Politecnica de Catalunya (UPC) - Barcelona - Spain
%
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  June 2011
% ------------------------------------------------------------------------

    seg = seg2gridbmap(partition);
    seg(1:2:end,1:2:end)=1;
    filled_contours = bwlabel(1-seg',4);
    relabeled = filled_contours(2:2:end,2:2:end)';
end
