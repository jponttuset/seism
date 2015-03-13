% function eval_method(method, parameter, measure, gt_set)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  June 2013
% ------------------------------------------------------------------------ 
%  File part of the code 'segmentation_evaluation', from the paper:
%
%  Jordi Pont-Tuset, Ferran Marques,
%  "Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
%  Computer Vision and Pattern Recognition (CVPR), 2013.
% ------------------------------------------------------------------------
function eval_method(method, parameter, measure, gt_set)

% Load BSDS500 indices
im_ids = load(fullfile(root_dir,'bsds500', ['ids_' gt_set '.txt']));

% I/O folders
method_dir = fullfile(root_dir,'datasets',method, parameter);
gtdir      = fullfile(root_dir,'bsds500','ground_truth');
res_dir    = fullfile(root_dir,'results', method);
if ~exist(res_dir,'dir')
    mkdir(res_dir)
end
results_file = fullfile(res_dir, [gt_set '_' measure '_' parameter '.txt']);

% Leave as is if already computed
if exist(results_file,'file')
    disp(['Already computed: ' results_file])
    return;
end

% Open results file
fid_results = fopen(results_file, 'w');
if(fid_results==-1)
    error(['Error: results file not writable: ' results_file])
else
    disp(['Computing: ' results_file])
end

% Run on all images
for ii=1:numel(im_ids)
    % Display evolution      
    % disp([num2str(ii) ' out of ' num2str(numel(im_ids))])
    curr_id = im_ids(ii);

    % Read ground truth (gt_seg)
    load(fullfile(gtdir, [num2str(curr_id) '.mat']));
    
    % Read the partition
    if exist(fullfile(method_dir, [num2str(curr_id) '_' parameter '.prl']), 'file')
        partition = prl_read(fullfile(method_dir, [num2str(curr_id) '_' parameter '.prl']));
        
        % Rotate if necessary (different image)
        if ~isequal(size(gt_seg{1}), size(partition)) %#ok<USENS>
            partition = imrotate(partition,90);
        end
    else
        error(['Missing result ' num2str(curr_id) '_' parameter])
    end
    
    % Compute measure
    value = eval_segm(partition,gt_seg,measure);
    
    % Write to file
    for jj=1:length(value)-1
        fprintf(fid_results, '%f\t', value(jj));
    end
    fprintf(fid_results, '%f\n', value(end));
end

fclose(fid_results);

