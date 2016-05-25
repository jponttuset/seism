% function eval_method_all_params(method, measure, gt_set, segm_or_contour)
% ------------------------------------------------------------------------ 
%  Run the evaluation on all parameters of a certain method
% ------------------------------------------------------------------------ 
%  File part of the code 'segmentation_evaluation', from the paper:
%
%  Jordi Pont-Tuset, Ferran Marques,
%  "Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
%  Computer Vision and Pattern Recognition (CVPR), 2013.
% ------------------------------------------------------------------------
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------ 
function eval_method_all_params(method, measure, read_part_fun, database, gt_set, segm_or_contour)

% Is it a partition or a contour detection?
if ~exist('segm_or_contour','var')
    segm_or_contour = 0;
end

%% Get all parameters for that method from file
params = get_method_parameters(method);

for ii=1:length(params)
    experiments(ii).method    = method;     %#ok<AGROW>
    experiments(ii).parameter = params{ii}; %#ok<AGROW>
    experiments(ii).measure   = measure;    %#ok<AGROW>
end
disp(['Total number of parameterizations: ' num2str(ii)])

%% Run using the parallel computing toolbox
% p = parpool;
% matlabpool open;
% parfor nn=1:length(experiments)
%     method_name = experiments(nn).method;
%     parameter   = experiments(nn).parameter;
%     measure     = experiments(nn).measure;
%     disp(['Starting: ' method_name ' (' parameter ') for measure ' measure ' on ' gt_set])
%     eval_method(method_name, parameter, measure, read_part_fun, database,  gt_set, length(params), segm_or_contour)
%     disp(['Done:     ' method_name ' (' parameter ') for measure ' measure ' on ' gt_set])
% end
% matlabpool close;
% delete(p);

%% Run all experiments sequentially
for nn=1:length(experiments)
    eval_method(experiments(nn).method,...
                experiments(nn).parameter,...
                experiments(nn).measure,...
                read_part_fun, database, gt_set, length(params), segm_or_contour);
end


