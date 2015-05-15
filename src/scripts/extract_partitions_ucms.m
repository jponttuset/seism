function extract_partitions_ucms(method, gt_set, parameter)
% extract_partitions_ucms(method, gt_set, parameter)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------ 
im_ids = load(fullfile(root_dir,'bsds500', ['ids_' gt_set '.txt']));

method_dir = fullfile(datasets_root_dir, 'BSDS500', method);
parts_dir = fullfile(root_dir,'datasets',method, parameter);
if ~exist(parts_dir,'dir')
    mkdir(parts_dir)
end

for ii=1:numel(im_ids)
    % Display evolution      
    disp([num2str(ii) ' out of ' num2str(numel(im_ids))])
        
    % Get the partition to assess
    load(fullfile(method_dir, [im_ids{ii} '.mat']));
    tmp = (bwlabel(ucm2'<=parameter,4))';
    partition = uint32(tmp(2:2:end,2:2:end));
   
    % Write to file
    part_file = fullfile(parts_dir, [im_ids{ii} '_' parameter '.prl']);
    prl_write(partition, part_file);
end

