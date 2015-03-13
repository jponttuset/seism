function stats = gather_measure(method, params, measure, gt_set)
% stats = gather_measure(method, params, measure, gt_set)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------ 

% Directory where results are stored
results_dir = fullfile(root_dir, 'results', method);
  
% Set of images considered according to gt_set ('test', 'val', 'train')
image_idxs = load(fullfile(root_dir, 'bsds500', ['ids_' gt_set '.txt']));

% Get dimensions
num_images = length(image_idxs);
num_results = length(params);
   
% Allocate (distinguish precision-recall measures)
if strcmp(measure, 'fb') || strcmp(measure, 'fop') || strcmp(measure, 'fr')
    stats.prec  = zeros(num_images, num_results);
    stats.rec   = zeros(num_images, num_results);    
end
stats.values = zeros(num_images, num_results);

% Scan all parameters
for param_id = 1:num_results
    % Get data
    curr_results = load(fullfile(results_dir, [gt_set '_' measure '_' cell2mat(params(param_id)) '.txt']));
    
    % Gather results
    if strcmp(measure, 'fb') || strcmp(measure, 'fop') || strcmp(measure, 'fr')
        stats.prec  (:,param_id) = curr_results(:,2);
        stats.rec   (:,param_id) = curr_results(:,3);
    end
    stats.values(:,param_id) = curr_results(:,1);
end

% Compute statistics
if strcmp(measure, 'fb') || strcmp(measure, 'fop') || strcmp(measure, 'fr')
    stats.mean_prec  = mean(stats.prec);
    stats.mean_rec   = mean(stats.rec);
    stats.mean_value = 2*(stats.mean_prec.*stats.mean_rec)./(stats.mean_prec+stats.mean_rec);
    
    % Check that there is no Nan in F
    if ~isempty(find(isnan(stats.mean_value), 1))
         error('Not a Number found');
    end
else
    stats.mean_value = mean(stats.values);
end
