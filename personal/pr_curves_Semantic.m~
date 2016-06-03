%% Experiments parameters
%clear all;close all;clc;


%database = 'BSDS500';
%database = 'PASCALContext';
%database = 'Pascal';
database = 'SBD';

writePR = 0; % Write results in format to use latex code?
USEprecomputed = 1; % Use precomputed results or evaluate on your computer?

% Precision-recall measures
measures = {'fb'};

% Define all methods to be compared
methods  = [];
switch database,
    case 'SBD',
        gt_set   = 'val';
        cat_id = 1:20;
        classes = importdata(fullfile(seism_root,'src','gt_wrappers','misc','SBD_classes.txt'));
        
        methods(end+1).name = 'ResNet50-mod-pc_50000';             methods(end).io_func = @read_one_cont_png;  methods(end).legend = methods(end).name;  methods(end).type = 'contour';
        methods(end+1).name = 'Bharath';             methods(end).io_func = @read_one_cont_png;  methods(end).legend = methods(end).name;  methods(end).type = 'contour';
        %methods(end+1).name = 'COB';             methods(end).io_func = @read_one_ucm;       methods(end).legend = 'COB';              methods(end).type = 'segmentation';
    otherwise,
        error('Unknown name of the database');
end

% Colors to display
colors = {'b','g','r','k','m','c','y','b','g','r','k','m','c','y','k','g','b','g','r'};

%% Evaluate your method (just once for all parameters)

% % Evaluate using the correct reading function
if ~USEprecomputed,
    for ii=1:length(measures)
        for jj=1:length(methods)
            % Contours only in 'fb'
            is_cont = strcmp(methods(ii).type,'contour');
            if strcmp(measures{ii},'fb') || ~is_cont
                if exist('cat_id','var'),
                    eval_method_all_params(methods(jj).name, measures{ii}, methods(jj).io_func, database, gt_set, is_cont,cat_id);
                else
                    eval_method_all_params(methods(jj).name, measures{ii}, methods(jj).io_func, database, gt_set, is_cont);
                end
            end
        end
    end
end

% % Helper to check existence of files
% test_io(methods, database, gt_set);

%% Plot PR curves
addpath(genpath('src'));
figure('units','normalized','outerposition',[0 0 1 1])
for ll=1:20,
    subplottight(4,5,ll), hold on;for F = 0.1:0.1:0.9,iso_f_plot(F);end;axis square;
    % iso_f_axis([measures{kk} '_' num2str(ll)])
    fig_handlers = [];
    legends = {};
    % Plot methods
    for ii=1:length(methods)
        try
            display(['Evaluating method: ' methods(ii).name ' for class ' classes{ll} '...']);
            % Plot the contours only in 'fb'
            if strcmp(methods(ii).type,'contour'),style='-';else style='-';end
            % Get all parameters for that method from file
            params = get_method_parameters(methods(ii).name);
            % Gather pre-computed results
            curr_meas = gather_measure(methods(ii).name,params,'fb',database,gt_set,ll);
            curr_ods  = general_ods(curr_meas);
            curr_ap   = general_ap(curr_meas);
            % Plot method
            display(['ODS: ' num2str(curr_ods.mean_value) ' AP: ' num2str(curr_ap) ])
            fig_handlers(end+1) = plot(curr_meas.mean_rec,curr_meas.mean_prec,[colors{ii} style],'LineWidth',2); %#ok<SAGROW>
            plot(curr_ods.mean_rec,curr_ods.mean_prec,[colors{ii} '*'],'LineWidth',2)
            legends{end+1} = ['[F:' sprintf('%.0f',curr_ods.mean_value*100) ', AP:' sprintf('%.0f',curr_ap*100) '] ' methods(ii).legend ]; %#ok<SAGROW>
        end
    end
    
    if strfind(gt_set,'_'), set_title = strrep(gt_set,'_','\_');else set_title=gt_set;end
    title(classes{ll});
    legend(fig_handlers,legends);%, 'Location','NorthEastOutside')
    hold off;
end
%Write the results for latex processing
if writePR,
    if strcmp(database,'SBD'),
        pr_curves_to_file(measures, database, gt_set, methods, cat_id);
    else
        pr_curves_to_file(measures, database, gt_set, methods);
    end
end

