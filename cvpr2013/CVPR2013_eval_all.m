exp_par = CVPR2013_exp_params();

%% Get the full list of methods-parameters combinations
nn=1;
for ii=1:length(exp_par.methods.ids)
    for jj=1:length(exp_par.methods.params{ii})
        for kk=1:length(exp_par.measures)
            experiments(nn).method    = exp_par.methods.ids{ii}; %#ok<SAGROW>
            experiments(nn).parameter = exp_par.methods.params{ii}{jj};  %#ok<SAGROW>
            experiments(nn).measure   = exp_par.measures{kk};%#ok<SAGROW>
            nn=nn+1;
        end
    end
end
for ii=1:length(exp_par.baselines.ids)
    for jj=1:length(exp_par.baselines.params{ii})
        for kk=1:length(exp_par.measures)
            experiments(nn).method    = exp_par.baselines.ids{ii}; %#ok<SAGROW>
            experiments(nn).parameter = exp_par.baselines.params{ii}{jj};  %#ok<SAGROW>
            experiments(nn).measure   = exp_par.measures{kk};%#ok<SAGROW>
            nn=nn+1;
        end
    end
end
for ii=1:length(exp_par.swapped.ids)
    for jj=1:length(exp_par.swapped.params{ii})
        for kk=1:length(exp_par.measures)
            experiments(nn).method    = exp_par.swapped.ids{ii}; %#ok<SAGROW>
            experiments(nn).parameter = exp_par.swapped.params{ii}{jj};  %#ok<SAGROW>
            experiments(nn).measure   = exp_par.measures{kk};%#ok<SAGROW>
            nn=nn+1;
        end
    end
end
disp(['Total number of parameterizations: ' num2str(nn-1)])

%% Run using the parallel computing toolbox
num_jobs = 9;
matlabpool('open',num_jobs)
parfor nn=1:length(experiments)
    method_name = experiments(nn).method;
    parameter   = experiments(nn).parameter;
    measure     = experiments(nn).measure;
    disp(['Starting: ' method_name ' (' parameter ') for measure ' measure ' on ' exp_par.gt_set]) %#ok<PFBNS>
    eval_method(method_name, parameter, measure, exp_par.gt_set);
    disp(['Done:     ' method_name ' (' parameter ') for measure ' measure ' on ' exp_par.gt_set])
end
matlabpool('close')

%% Run all experiments sequentially
% for nn=1:length(experiments)
%     eval_method(experiments(nn).method,...
%                 experiments(nn).parameter,...
%                 experiments(nn).measure, gt_set);
% end
