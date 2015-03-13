function stats = gather_measure_and_stats(method, params, measure, gt_set)
% stats = gather_measure_and_stats(method, params, measure, gt_set)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------ 
stats.id     = measure;
stats.all    = gather_measure(method, params, measure, gt_set);
stats.n_regs = gather_measure(method, params, 'n_regs', gt_set);

% Compute ODS
[stats.ods, ods_id] = general_ods(stats.all);
stats.ods_id = ods_id;
stats.ods_param = params{ods_id};

% Compute OIS
[stats.ois, ois_ids] = general_ois(stats.all);
stats.ois_ids = ois_ids;


