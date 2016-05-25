function det_bmap=kill_internal_bdries(det_bmap, gt_bdry, mask, maxDist)
%%Function to kill internal contours
% det_bmap: detected boundary map
% gt_brdy: the ground truth boundary map
% mask: the mask of the instance (ground truth)
% maxDist: 0.0075 for BSDS, 0.02 for SBD, 0.01 for PASCAL SegVOC12

imsize=size(det_bmap);
diag=sqrt(imsize(1)^2+imsize(2)^2);
buffer=(maxDist*diag);
distmap = bwdist(gt_bdry);

%kill all contours that are outside the buffer region, and are internal to the object.
killmask = (distmap>buffer) & mask;
det_bmap=det_bmap.*(~killmask);