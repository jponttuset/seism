function eval_human_disc(pairs_type, measure, gt_set, generalization)
% eval_human_disc(pairs_type, measure, gt_set, generalization)
%  pairs_type     = 'same' or 'diff';
%  measure        = 'fb','fop', etc.;
%  gt_set         = 'test','train', etc.;
%  generalization = 'one_to_all';

pairs        = load(fullfile(root_dir, 'bsds500', [generalization '_' gt_set '_' pairs_type '_image_pairs.txt']));
gtdir        = fullfile(root_dir, 'bsds500','ground_truth');
results_dir  = fullfile(root_dir, 'results', 'human');
results_file = fullfile(results_dir, [generalization '_' gt_set '_' pairs_type '_' measure '.txt']);

% Create results dir
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

% Open results file
fid_results = fopen(results_file, 'w');
if(fid_results==-1)
    error(['Error bench_PR: results file not writable: ' results_file])
end

for ii=1:size(pairs, 1)   
    num_parts = sum(pairs(ii,:)~=0)-3;
    
    % Load all GTs for the two images (gt_seg)
    gt1 = load(fullfile(gtdir, [num2str(pairs(ii, 1)) '.mat']));
    gt2 = load(fullfile(gtdir, [num2str(pairs(ii, 3)) '.mat']));
    partition1 = gt1.gt_seg{pairs(ii, 2)};
    
    if strcmp(generalization, 'one_to_all')
        % Accumulate selected GT parts in a cell and rotate them if
        % necessary (in case of 'diff')
        curr_gt_seg = cell(1,num_parts);   
        for idx_part = 4:4+num_parts-1
            partition2 = gt2.gt_seg{pairs(ii, idx_part)};
            if ~isequal(size(partition1), size(partition2))
                partition2 = imrotate(partition2,90);
            end
            curr_gt_seg{idx_part-3} = partition2;
        end
    elseif strcmp(generalization, 'one_to_one')
        % Check there is only one partition
        if num_parts>1
            error('one_to_one generalization accepts only one partition as GT')
        end
        partition2 = gt2.gt_seg{pairs(ii, 4)};
        if ~isequal(size(partition1), size(partition2))
            partition2 = imrotate(partition2,90);
        end
        curr_gt_seg = partition2;
    else
        error('Type of generalization unknown')
    end

    % Compute measure
    value = eval_segm(partition1,curr_gt_seg,measure);
    
    % Write to file
    for kk=1:length(value)-1
        fprintf(fid_results, '%f\t', value(kk));
    end
    fprintf(fid_results, '%f\n', value(end));
end

fclose(fid_results);



