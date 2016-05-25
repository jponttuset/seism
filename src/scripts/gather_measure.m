function stats = gather_measure(method, params, measure, database, gt_set)
% stats = gather_measure(method, params, measure, gt_set)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------ 

% Directory where results are stored
results_dir = fullfile(seism_root, 'results', database, method);
  
% Set of images considered according to gt_set ('test', 'val', 'train')
image_idxs = db_ids(database,gt_set);

% Get dimensions
num_images = length(image_idxs);
num_results = length(params);
   
% Allocate (distinguish precision-recall measures)
if strcmp(measure, 'fb') || strcmp(measure, 'fop') || strcmp(measure, 'fr')
    stats.prec  = zeros(num_images, num_results);
    stats.rec   = zeros(num_images, num_results);    
end
stats.values = zeros(num_images, num_results);

% Fb needs counts also
if strcmp(measure, 'fb')
    stats.cntR  = zeros(num_images, num_results);
    stats.sumR  = zeros(num_images, num_results);
    stats.cntP  = zeros(num_images, num_results);
    stats.sumP  = zeros(num_images, num_results);
end 

% Scan all parameters
for param_id = 1:num_results
    % Get data
    curr_results = load(fullfile(results_dir, [gt_set '_' measure '_' cell2mat(params(param_id)) '.txt']));
    
    % Gather results
    if strcmp(measure, 'fb') || strcmp(measure, 'fop') || strcmp(measure, 'fr')
        stats.prec(:,param_id) = curr_results(:,2);
        stats.rec (:,param_id) = curr_results(:,3);
    end
    if strcmp(measure, 'fb')
        stats.cntR(:,param_id) = curr_results(:,4);
        stats.sumR(:,param_id) = curr_results(:,5);
        stats.cntP(:,param_id) = curr_results(:,6);
        stats.sumP(:,param_id) = curr_results(:,7);
    end
    stats.values(:,param_id) = curr_results(:,1);
end

% Compute statistics
if strcmp(measure, 'fb') || strcmp(measure, 'fop') || strcmp(measure, 'fr')
    if strcmp(measure, 'fb')
        cntR = sum(stats.cntR);
        sumR = sum(stats.sumR);
        cntP = sum(stats.cntP);
        sumP = sum(stats.sumP);
        
        stats.mean_rec  = cntR./(sumR+eps);
        stats.mean_prec = cntP./(sumP+eps);
    else
        stats.mean_prec  = mean(stats.prec);
        stats.mean_rec   = mean(stats.rec);
    end
    stats.mean_value = 2*(stats.mean_prec.*stats.mean_rec)./(stats.mean_prec+stats.mean_rec+eps);
    
    % Check that there is no Nan in F
    if ~isempty(find(isnan(stats.mean_value), 1))
         error('Not a Number found');
    end
else
    stats.mean_value = mean(stats.values);
end
