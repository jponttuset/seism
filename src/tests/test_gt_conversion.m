gt_orig  = loadvar('~/Workspace/gt_dbs/BSDS500/groundTruth.original/100007.mat', 'groundTruth');
gt_seism = loadvar('~/Workspace/gt_dbs/BSDS500/groundTruth/100007.mat', 'groundTruth');

%% Same partitions
for ii=1:length(gt_orig)
   assert(isequal(uint32(gt_orig{ii}.Segmentation),gt_seism{ii}))
end

%% Same contours
for ii=1:length(gt_orig)
   tmp = bwmorph(seg2bmap(gt_seism{ii}),'thin','Inf');
   assert(isequal(gt_orig{ii}.Boundaries,tmp))
end


