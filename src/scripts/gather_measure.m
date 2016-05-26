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
      
        % Allocate
        stats.mean_rec  = zeros(size(sumP));
        stats.mean_prec = zeros(size(sumP));
        
        % Compute precision-recall
        assert(sum((sumR==0).*(cntP~=0))==0)
        stats.mean_rec(logical((sumR==0).*(cntP==0))) = 1;
        stats.mean_prec(logical((sumR==0).*(cntP==0))) = 0;
        
        assert(sum((sumP==0).*(cntR~=0))==0)
        stats.mean_rec(logical((sumP==0).*(cntR==0))) = 0;
        stats.mean_prec(logical((sumP==0).*(cntR==0))) = 1;
        
        stats.mean_rec(logical((sumP~=0).*(cntR~=0)))  = cntR(logical((sumP~=0).*(cntR~=0)))./sumR(logical((sumP~=0).*(cntR~=0)));
        stats.mean_prec(logical((sumP~=0).*(cntR~=0))) = cntP(logical((sumP~=0).*(cntR~=0)))./sumP(logical((sumP~=0).*(cntR~=0)));
    else
        stats.mean_prec  = mean(stats.prec);
        stats.mean_rec   = mean(stats.rec);
    end
    
    if strcmp(measure, 'fb')
        % Compute fb
        stats.mean_value = zeros(size(sumP));
        stats.mean_value((stats.mean_rec+stats.mean_prec)==0) = 0;
        stats.mean_value((stats.mean_rec+stats.mean_prec)~=0) = ...
            2*stats.mean_prec((stats.mean_rec+stats.mean_prec)~=0).*stats.mean_rec((stats.mean_rec+stats.mean_prec)~=0)...
             ./(stats.mean_prec((stats.mean_rec+stats.mean_prec)~=0)+stats.mean_rec((stats.mean_rec+stats.mean_prec)~=0));
    else
        stats.mean_value = 2*(stats.mean_prec.*stats.mean_rec)./(stats.mean_prec+stats.mean_rec);
    end
    % Check that there is no Nan in F
    if ~isempty(find(isnan(stats.mean_value), 1))
         error('Not a Number found');
    end
else
    stats.mean_value = mean(stats.values);
end
