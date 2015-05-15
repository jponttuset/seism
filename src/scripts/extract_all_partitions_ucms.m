function extract_all_partitions_ucms(method_dir,gt_set)
% extract_all_partitions_ucms(method_dir,gt_set)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------ 
if nargin==1
    gt_set = 'val';
end

% Get thresholds
n_th = 30;
params = cell(n_th,1);
for ii=1:n_th
    params{ii} = num2str(ii/31);
end

% Run for all thresholds
for jj=1:length(params)  
    extract_partitions_ucms(method_dir,gt_set, params{jj})
end