exp_par = CVPR2013_exp_params();
disc_types = {'same','diff'};

%% Get the full list of measures-disc combinations
nn=1;
for ii=1:length(disc_types)
    for jj=1:length(exp_par.measures)
        experiments(nn).measure   = exp_par.measures{jj}; %#ok<SAGROW>
        experiments(nn).disc_type = disc_types{ii};  %#ok<SAGROW>
        nn=nn+1;
    end
end
disp(['Total number of experiments: ' num2str(nn-1)])

%% Run using the parallel computing toolbox
num_jobs = 11;
matlabpool('open',num_jobs)
parfor nn=1:length(experiments)
    disc_type   = experiments(nn).disc_type;
    measure     = experiments(nn).measure;
    disp(['Starting: ' disc_type ' for measure ' measure ' on ' exp_par.gt_set]) %#ok<PFBNS>
    eval_human_disc(disc_type, measure, exp_par.gt_set, 'one_to_all');
    eval_human_perf(disc_type, measure, exp_par.gt_set, 'one_to_all');
    disp(['Done: ' disc_type ' for measure ' measure ' on ' exp_par.gt_set])
end
matlabpool('close')

%% Run all experiments sequentially
% for nn=1:length(experiments)
%     eval_human_disc(experiments(nn).disc_type,...
%                     experiments(nn).measure,...
%                     exp_par.gt_set, 'one_to_all');
%     eval_human_perf(experiments(nn).disc_type,...
%                     experiments(nn).measure,...
%                     exp_par.gt_set, 'one_to_all');
% end
