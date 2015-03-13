%% Experiments parameters
exp_par = CVPR2013_exp_params;

n_measures = length(exp_par.measures);
n_images = length(exp_par.im_ids);
n_methods = length(exp_par.methods.ids);

%% Gather all measures - Each ODS (Optimal Dataset Scale)
% Segmentation methods
all_meas = cell(length(exp_par.methods.ids),length(exp_par.measures));
for ii=1:length(exp_par.methods.ids)    
    for jj=1:length(exp_par.measures)
        all_meas{ii,jj} = gather_measure_and_stats(exp_par.methods.ids{ii}, exp_par.methods.params{ii}, exp_par.measures{jj}, exp_par.gt_set);
    end
end

% Baseline methods
basel_meas = cell(length(exp_par.baselines.ids),length(exp_par.measures));
for ii=1:length(exp_par.baselines.ids)    
    for jj=1:length(exp_par.measures)
        basel_meas{ii,jj} = gather_measure_and_stats(exp_par.baselines.ids{ii}, exp_par.baselines.params{ii}, exp_par.measures{jj}, exp_par.gt_set);
    end
end

% Swapped methods
swapped_meas = cell(length(exp_par.swapped.ids),length(exp_par.measures));
for ii=1:length(exp_par.swapped.ids)    
    for jj=1:length(exp_par.measures)
        swapped_meas{ii,jj} = gather_measure_and_stats(exp_par.swapped.ids{ii}, exp_par.swapped.params{ii}, exp_par.measures{jj}, exp_par.gt_set);
    end
end

%% Compute worst-case baseline (best measure)
best_basel_meas = zeros(n_images,n_measures);
for ii=1:length(exp_par.baselines.ids)
    for jj=1:n_measures
        best_basel_meas(:,jj) = max(best_basel_meas(:,jj), basel_meas{ii,jj}.all.values(:,basel_meas{ii,jj}.ods_id));
    end
end

%% Compute discrimination w.r.t. baseline (SABD)
incoherences_SABD = zeros(n_methods,n_measures);
for ii=1:n_methods    
    for jj=1:n_measures
        bad_values  = best_basel_meas(:,jj);
        good_values = all_meas{ii,jj}.all.values(:,all_meas{ii,jj}.ods_id); 
        incoherences_SABD(ii,jj) = sum(good_values<bad_values);
    end
end
total_compar = n_methods*n_images;
num_inc_SABD = sum(incoherences_SABD);
norm_SABD = (total_compar-num_inc_SABD)/total_compar;

[sorted_disc, idx] = sort(norm_SABD, 'descend');
ranking = zeros(1,length(exp_par.measures)+1);
for ii=1:n_measures
    ranking(idx(ii)) = ii;
end

%% Compute discrimination w.r.t. swapped at the same scale (SISD)
incoherences_SISD = zeros(n_methods,n_measures);
for ii=1:n_methods
    for jj=1:n_measures
        bad_values  = swapped_meas{ii,jj}.all.values(:,all_meas{ii,jj}.ods_id); % Note ODS 
        good_values =     all_meas{ii,jj}.all.values(:,all_meas{ii,jj}.ods_id); % Note ODS 
        incoherences_SISD(ii,jj) = sum(good_values<bad_values);
    end
end
total_compar = n_methods*n_images;
num_inc_SISD = sum(incoherences_SISD);
norm_SISD = (total_compar-num_inc_SISD)/total_compar;

[sorted_disc_SISD, idx] = sort(norm_SISD, 'descend');
ranking_SISD = zeros(1,length(exp_par.measures));
for ii=1:n_measures
    ranking_SISD(idx(ii)) = ii;
end

%% Show SABD table
disp(' Baseline discrimination (SABD)')
disp('=====================================')
disp(' Measure  N.Incoh   NormSABD    Rank')
disp('-------------------------------------')
col_height = 13;
for ii=1:length(exp_par.measures)
    to_show = [exp_par.measures{ii} repmat(' ',1,col_height-length(exp_par.measures{ii})-length(num2str(num_inc_SABD(ii))))];
    to_show = [' ' to_show ' ' num2str(num_inc_SABD(ii)) sprintf('      %1.4f', norm_SABD(ii)) repmat(' ',1,8-length(num2str(ranking(ii)))) num2str(ranking(ii))]; %#ok<AGROW>
    disp(to_show)
end
disp('=====================================')


%% Show exp_par.measures table
disp(' Swapped discrimination (SISD)')
disp('=====================================')
disp(' Measure  N.Incoh   NormSISD    Rank')
disp('-------------------------------------')
col_height = 13;
for ii=1:length(exp_par.measures)
    to_show = [exp_par.measures{ii} repmat(' ',1,col_height-length(exp_par.measures{ii})-length(num2str(num_inc_SISD(ii))))];
    to_show = [' ' to_show ' ' num2str(num_inc_SISD(ii)) sprintf('      %1.4f', norm_SISD(ii)) repmat(' ',1,8-length(num2str(ranking_SISD(ii)))) num2str(ranking_SISD(ii))]; %#ok<AGROW>    
    disp(to_show)
end
disp('=====================================')















