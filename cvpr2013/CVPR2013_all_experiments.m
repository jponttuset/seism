%% Measures
exp_par = CVPR2013_exp_params();
CVPR2013_SIHD
CVPR2013_SABD_SISD

%% Get results in workspace
norm_all = norm_SIHD + norm_SABD + norm_SISD;

[a,idx] = sort(norm_all, 'descend');


%% Show table
disp('=============================================')
disp(' Measure    Global   |   SIHD   SABD   SISD')
disp('---------------------------------------------')
col_height = 8;
for ii=1:length(exp_par.measures)
    to_show = exp_par.measures{idx(ii)};
    for jj=length(exp_par.measures{idx(ii)}):col_height
        to_show = [to_show ' ']; %#ok<AGROW>
    end
    to_show = [' ' to_show '   ' sprintf('%.1f', 100*norm_all(idx(ii))/3) '    |   '  sprintf('%.1f', 100*norm_SIHD(idx(ii))) '   ' sprintf('%.1f', 100*norm_SABD(idx(ii))) '   '  sprintf('%.1f', 100*norm_SISD(idx(ii)))]; %#ok<AGROW>
    disp(to_show)
end
disp('=============================================')






%% Measures
% exp_par = experiments_parameters();
% show_pzdb_results
% show_rand_discr_results
% show_sdd_results
% 
% %% Get results in workspace
% norm_all = norm_consist + norm_discr + norm_sdd;
% [a,idx] = sort(norm_all, 'descend');
% 
% 
% 
% %% Show table
% disp('===============================================================================')
% disp(' Measure                                Global    |  HumanCoh RandDisc   SDD')
% disp('-------------------------------------------------------------------------------')
% col_height = 35;
% for ii=1:length(exp_par.meas_ids)
%     to_show = exp_par.meas_ids{idx(ii)};
%     for jj=length(exp_par.meas_ids{idx(ii)}):col_height
%         to_show = [to_show ' ']; %#ok<AGROW>
%     end
%     to_show = [' ' to_show '   ' sprintf('%1.4f', norm_all(idx(ii))) '    |   ' sprintf('%1.4f', norm_consist(idx(ii))) '   ' sprintf('%1.4f', norm_discr(idx(ii))) '   ' sprintf('%1.4f', norm_sdd(idx(ii)))]; %#ok<AGROW>
%     disp(to_show)
% end
% disp('===============================================================================')