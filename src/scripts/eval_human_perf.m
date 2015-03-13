function eval_human_perf( pairs_type, measure, gt_set, generalization )
% eval_human_perf( pairs_type, measure, gt_set, generalization )
%  pairs_type     = 'same' or 'diff';
%  measure        = 'fb','fop', etc.;
%  gt_set         = 'test','train', etc.;
%  generalization = 'one_to_all';

pairs   = load(fullfile(root_dir, 'bsds500', [generalization '_' gt_set '_' pairs_type '_image_pairs.txt']));
in_file = fullfile(root_dir, 'results', 'human', [generalization '_' gt_set '_' pairs_type '_' measure '.txt']);
if strcmp(generalization, 'one_to_all_full')
    out_file= fullfile(root_dir, 'results', 'human', ['human_perf_full_' gt_set '_' pairs_type '_' measure '.txt']);
else
    out_file= fullfile(root_dir, 'results', 'human', ['human_perf_' gt_set '_' pairs_type '_' measure '.txt']);
end

% Load in results
in_res = load(in_file);
if(size(in_res,1)~=size(pairs,1))
    error('Not coherent results')
end

% Get partition ids
part_ids = load(fullfile(root_dir,'bsds500',['ids_' gt_set '.txt']));
if(sort(part_ids)~=unique(pairs(:,1)))
    error('Not coherent results')
end

out_res = zeros(length(part_ids),size(in_res,2));
for ii=1:length(part_ids)
    res_curr_part = logical(pairs(:,1)==part_ids(ii));
    
    out_res(ii,:) = mean(in_res(res_curr_part,:));
end

% Write to file
dlmwrite(out_file,out_res,'delimiter','\t');
