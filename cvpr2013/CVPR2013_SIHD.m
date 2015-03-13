%% Experiments parameters
exp_par = CVPR2013_exp_params;

%% Gather all measures
n_measures = length(exp_par.measures);
all_SIHD_errors = zeros(3,n_measures);
for ii=1:n_measures
    same = gather_human(exp_par.measures{ii}, 'same', exp_par.gt_set, 'one_to_all');
    diff = gather_human(exp_par.measures{ii}, 'diff', exp_par.gt_set, 'one_to_all');

    [ all_SIHD_errors(1,ii), all_SIHD_errors(2,ii) ] = SIHD_error( same.values , diff.values, 50 );
end
sum_SIHD_errors =  sum(all_SIHD_errors(1:2,:));
[sorted_SIHD, idx] = sort(sum_SIHD_errors);
ranking = zeros(1,length(exp_par.measures));
for ii=1:length(exp_par.measures)
    ranking(idx(ii)) = ii;
end
norm_SIHD = 1-sum_SIHD_errors;

%% Show SIHD table
disp('==================================')
disp(' Measure    SIHD   NormSIHD  Rank')
disp('----------------------------------')
col_height = 9;
for ii=1:length(exp_par.measures)
    to_show = [exp_par.measures{ii} repmat(' ',1,col_height-length(exp_par.measures{ii}))];
    to_show = [' ' to_show ' ' sprintf('%1.4f', sum_SIHD_errors(ii)) '   ' sprintf('%1.4f', norm_SIHD(ii)) repmat(' ',1,6-length(num2str(ranking(ii)))) num2str(ranking(ii))]; %#ok<AGROW>
    disp(to_show)
end
disp('==================================')