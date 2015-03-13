
%% Experiments parameterization
% BSDS500 set: train, test, val, trainval, or all
gt_set = 'test';

% Precision-recall measures
measures = {'fb' ,... % Precision-recall for boundaries
            'fop',... % Precision-recall for objects and parts  
            };

% List of segmentation methods to evaluate
methods   = {'UCM','EGB','NCut','MShift','NWMC','IIDKL'};
s_methods = {'UCM_swapped','EGB_swapped','NCut_swapped','MShift_swapped','NWMC_swapped','IIDKL_swapped'};
baseline  = {'QuadTree'};
        
colors = {'k','g','b','r','m','c'};

%% Plot evertyhing
for kk=1:length(measures)
    iso_f_axis(measures{kk})
    fig_handlers = zeros(1,length(methods)+length(baseline)+1);
    
    %% Plot human
    human_same = gather_human(measures{kk}, 'same', gt_set, 'human_perf');
    human_diff = gather_human(measures{kk}, 'diff', gt_set, 'human_perf');
    fig_handlers(1) = plot(human_same.mean_rec,human_same.mean_prec, 'rd');
    plot(human_diff.mean_rec,human_diff.mean_prec, 'rd');
    
    %% Plot methods
    for ii=1:length(methods)
        % Get all parameters for that method from file
        fid = fopen(fullfile(root_dir,'datasets',methods{ii},'params.txt'));
        params = textscan(fid, '%s');
        params = params{1};
        fclose(fid);
    
        % Gather pre-computed results
        curr_meas = gather_measure(methods{ii},params,measures{kk},gt_set);
        curr_ods = general_ods(curr_meas);
        curr_ois = general_ois(curr_meas);
        
        % Plot method
        fig_handlers(ii+1) = plot(curr_meas.mean_rec,curr_meas.mean_prec,[colors{ii} '-']);
        plot(curr_ods.mean_rec,curr_ods.mean_prec,[colors{ii} '*'])
    end
    
    %% Plot baselines
    for ii=1:length(baseline)
        % Get all parameters for that method from file
        fid = fopen(fullfile(root_dir,'datasets',baseline{ii},'params.txt'));
        params = textscan(fid, '%s');
        params = params{1};
        fclose(fid);
    
        % Gather pre-computed results
        curr_meas = gather_measure(baseline{ii},params,measures{kk},gt_set);
        curr_ods = general_ods(curr_meas);
        curr_ois = general_ois(curr_meas);
        
        % Plot method
        fig_handlers(ii+length(methods)+1) = plot(curr_meas.mean_rec,curr_meas.mean_prec, [colors{ii} '-.']);
        plot(curr_ods.mean_rec,curr_ods.mean_prec,[colors{ii} '*'])
    end
    
    %% Plot swapped
    for ii=1:length(s_methods)
        % Get all parameters for that method from file
        fid = fopen(fullfile(root_dir,'datasets',s_methods{ii},'params.txt'));
        params = textscan(fid, '%s');
        params = params{1};
        fclose(fid);
    
        % Gather pre-computed results
        curr_meas = gather_measure(s_methods{ii},params,measures{kk},gt_set);
        curr_ods = general_ods(curr_meas);
        curr_ois = general_ois(curr_meas);
        
        % Plot method
        plot(curr_meas.mean_rec,curr_meas.mean_prec,[colors{ii} '--']);
        plot(curr_ods.mean_rec,curr_ods.mean_prec,[colors{ii} '*'])
    end
    
    
    legend(fig_handlers,{'Human', methods{1:end}, baseline{1:end}}, 'Location','NorthEastOutside')
end


