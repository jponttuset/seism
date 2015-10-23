function seg = griducm2seg(grid_ucm, num_regs)
% function seg = griducm2seg(grid_ucm, num_regs)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
%  University of California Berkeley (UCB) - USA
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  Pablo Arbelaez <arbelaez@berkeley.edu>
%  June 2014
% ------------------------------------------------------------------------ 
% This file is part of the MCG package presented in:
%    Arbelaez P, Pont-Tuset J, Barron J, Marques F, Malik J,
%    "Multiscale Combinatorial Grouping,"
%    Computer Vision and Pattern Recognition (CVPR) 2014.
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------
% seg = gridbmap2seg(gridbmap)
%
% From a binary boundary map in the countour grid (as ucm2), get
% the represented partition as matrix of labels in the image plane
%
% INPUT
%	- grid_ucm : UCM on contour grid.
%	- num_regs : Number of regions wanted.
%
% OUTPUT
%	- seg      : Segments labeled from 1..k.
ths = unique(grid_ucm);
if num_regs>length(ths)
    sel_th = 0;
else
    sel_th = ths(end-num_regs+1);
end

tmp = grid_ucm>sel_th;
tmp(1:2:end,1:2:end)=1;
filled_contours = bwlabel(1-tmp',4);
seg = filled_contours(2:2:end,2:2:end)';
