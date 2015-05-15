function eval_method_all_params(method, measure, gt_set)


%% Get all folders
all_folders = dir(fullfile(root_dir,'datasets',method));

nn=0;
for ii=1:length(all_folders)
    if all_folders(ii).isdir && ~strcmp(all_folders(ii).name(1),'.')
        nn = nn+1;
        experiments(nn).method = method; %#ok<AGROW>
        experiments(nn).parameter = all_folders(ii).name; %#ok<AGROW>
        experiments(nn).measure = measure; %#ok<AGROW>
    end
end
disp(['Total number of parameterizations: ' num2str(nn)])

%% Run using the parallel computing toolbox
parpool
parfor nn=1:length(experiments)
    method_name = experiments(nn).method;
    parameter   = experiments(nn).parameter;
    measure     = experiments(nn).measure;
    disp(['Starting: ' method_name ' (' parameter ') for measure ' measure ' on ' gt_set])
    eval_method(method_name, parameter, measure, gt_set);
    disp(['Done:     ' method_name ' (' parameter ') for measure ' measure ' on ' gt_set])
end

%% Run all experiments sequentially
% for nn=1:length(experiments)
%     eval_method(experiments(nn).method,...
%                 experiments(nn).parameter,...
%                 experiments(nn).measure, gt_set);
% end


