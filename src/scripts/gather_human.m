function stats = gather_human(measure, type, gt_set, generalization_type)
% stats = gather_human(measure, type, gt_set)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------ 

% Get data
results_dir = fullfile(seism_root, 'results', 'human');
curr_results = load(fullfile(results_dir, [generalization_type '_' gt_set '_' type '_' measure '.txt']));

% Gather results
if strcmp(measure, 'fb') || strcmp(measure, 'fop') || strcmp(measure, 'fr')
    stats.prec  = curr_results(:,2);
    stats.rec   = curr_results(:,3);    
end
stats.values = curr_results(:,1);

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
