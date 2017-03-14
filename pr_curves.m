% ------------------------------------------------------------------------
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
%
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  June 2013
% ------------------------------------------------------------------------
%  Code obtained from:
%  https://imatge.upc.edu/web/resources/supervised-evaluation-image-segmentation
% ------------------------------------------------------------------------
% This file is part of the SEISM package presented in:
%    Jordi Pont-Tuset, Ferran Marques,
%    "Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
%    Computer Vision and Pattern Recognition (CVPR), 2013.
% If you use this code, please consider citing the paper.
% ------------------------------------------------------------------------
%
% To evaluate your method in the precision-recall enviroments you have to
% follow the following steps:
%
%  1) Create a file in the folder "parameters" with name "mymethod.txt"
%     with all the different value of a parameter indexing different working
%     points of your method, sorted as wished. (e.g. UCM thresholds)
%  2) Create a folder inside "datasets" with a descriptive name e.g. "mymethod".
%     Store a file for each image inside the folder, from which a partition
%     or contour can be extracted given a value of "parameters".
%     (e.g. a file with a variable 'ucm2')
%  3) Create or choose an I/O function that returns a partition or a
%     contour given a result file and a parameter. See 'read_one_cont_png',
%     'read_one_ucm' in 'src/io' for examples.
%  4) The output of your I/O function can be:
%      - A partition (closed contours): Must be a unit32 matrix of labels 1,...,N
%      - A contour detection: Must be a binary image with contour pixels marked
%  5) Evaluate your method with the piece of code below with the function
%     'eval_method_all_params' (just once, comment it when done)
%     If the results are contours, remember to add your method to
%     the list 'which_contours'.
%  6) Add your method to the list of methods to display, run the rest of
%     the code and enjoy your PR curves!
% ------------------------------------------------------------------------

%% Experiments parameters
%clear all;close all;clc;

% Select the database to work on
database = 'BSDS500';
% database = 'PASCALContext';
% database = 'Pascal';
% database = 'SBD';

% Write results in format to use latex code?
writePR = 1; 

% Use precomputed results or evaluate on your computer?
USEprecomputed = 1; 

% Precision-recall measures
measures = {'fb',...  % Precision-recall for boundaries
            'fop'};   % Precision-recall for Object Proposals

% Define all methods to be compared
methods  = [];
switch database
    case 'BSDS500'
        gt_set   = 'test';
        methods(end+1).name = 'HED';             methods(end).io_func = @read_one_cont_png; methods(end).legend = methods(end).name;  methods(end).type = 'contour';
        methods(end+1).name = 'COB';             methods(end).io_func = @read_one_ucm;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';        
        methods(end+1).name = 'LEP';             methods(end).io_func = @read_one_lep;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'MCG';             methods(end).io_func = @read_one_ucm;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'SE';              methods(end).io_func = @read_one_cont_png; methods(end).legend = methods(end).name;  methods(end).type = 'contour';
        methods(end+1).name = 'MShift';          methods(end).io_func = @read_one_prl;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'gPb-UCM';         methods(end).io_func = @read_one_ucm;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'ISCRA';           methods(end).io_func = @read_one_ucm;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'NCut';            methods(end).io_func = @read_one_prl;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'EGB';             methods(end).io_func = @read_one_prl;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        
        
    case 'PASCALContext'
        gt_set   = 'test_new';
        
        methods(end+1).name = 'COB';             methods(end).io_func = @read_one_ucm;      methods(end).legend = 'COB train';        methods(end).type = 'segmentation';
        methods(end+1).name = 'COB_trainval';    methods(end).io_func = @read_one_ucm;      methods(end).legend = 'COB trainval';     methods(end).type = 'segmentation'; 
        methods(end+1).name = 'HED';             methods(end).io_func = @read_one_cont_png; methods(end).legend = methods(end).name;  methods(end).type = 'contour';
        methods(end+1).name = 'HED_trainval';    methods(end).io_func = @read_one_cont_png; methods(end).legend = 'HED trainval';     methods(end).type = 'contour';
        methods(end+1).name = 'HED-BSDS500';     methods(end).io_func = @read_one_cont_png; methods(end).legend = methods(end).name;  methods(end).type = 'contour';
        methods(end+1).name = 'LEP-BSDS500';     methods(end).io_func = @read_one_lep;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'MCG-BSDS500';     methods(end).io_func = @read_one_ucm;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'SE-BSDS500';      methods(end).io_func = @read_one_cont_png; methods(end).legend = methods(end).name; methods(end).type = 'contour';
        
    case 'Pascal'
        gt_set   = 'Segmentation_val_2012';
        
        methods(end+1).name = 'COB';             methods(end).io_func = @read_one_ucm;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        methods(end+1).name = 'HED';             methods(end).io_func = @read_one_cont_png; methods(end).legend = methods(end).name;  methods(end).type = 'contour'; %From Khoreva et al.
        methods(end+1).name = 'HED-BSDS500';     methods(end).io_func = @read_one_cont_png; methods(end).legend = methods(end).name;  methods(end).type = 'contour';
        methods(end+1).name = 'MCG-BSDS500';     methods(end).io_func = @read_one_ucm;      methods(end).legend = methods(end).name;  methods(end).type = 'segmentation';
        
    case 'SBD'
        gt_set   = 'val';
        cat_id = 15;
        methods(end+1).name = 'HED';             methods(end).io_func = @read_one_cont_png; methods(end).legend = methods(end).name; methods(end).type = 'contour';
        methods(end+1).name = 'COB';             methods(end).io_func = @read_one_ucm;      methods(end).legend = methods(end).name; methods(end).type = 'segmentation';
    otherwise
        error('Unknown name of the database');
end

% Colors to display
colors = {'b','g','r','k','m','c','y','b','g','r','k','m','c','y','k','g','b','g','r'};

%% Evaluate your method (just once for all parameters)

% % Evaluate using the correct reading function
if ~USEprecomputed
    for ii=1:length(measures)
        for jj=1:length(methods)
            % Contours only in 'fb'
            is_cont = strcmp(methods(jj).type,'contour');
            if strcmp(measures{ii},'fb') || ~is_cont
                if exist('cat_id','var')
                    eval_method_all_params(methods(jj).name, measures{ii}, methods(jj).io_func, database, gt_set, is_cont, cat_id);
                else
                    eval_method_all_params(methods(jj).name, measures{ii}, methods(jj).io_func, database, gt_set, is_cont);
                end
            end
        end
    end
end

% Helper to check existence of files
% test_io(methods, database, gt_set);

%% Plot PR curves
addpath(genpath('src'));

for kk=1:length(measures)
    iso_f_axis(measures{kk})
    fig_handlers = [];
    legends = {};
    
    % Plot human (uncomment to recompute)
    if strcmp(database,'BSDS500')
        % mean_meas = eval_human(measures{kk},database, gt_set);
        if strcmp(measures{kk},'fb')
            mean_meas = [0.7235 0.9014];
        else
            mean_meas = [0.4739 0.6724];
        end
        fig_handlers(end+1) = plot(mean_meas(1),mean_meas(2), 'rd'); %#ok<SAGROW>
        legends{end+1} = 'Human'; %#ok<SAGROW>
    end
    
    % Plot methods
    for ii=1:length(methods)
        % Plot the contours only in 'fb'
        if strcmp(measures{kk},'fb') || strcmp(methods(ii).type,'segmentation')
            fprintf([methods(ii).name ': ' repmat(' ',[1,15-length(methods(ii).name)])]);

            if strcmp(methods(ii).type,'contour'),style='--';else, style='-';end
            
            % Get all parameters for that method from file
            params = get_method_parameters(methods(ii).name);
            
            % Gather pre-computed results
            if strcmp(database,'SBD')
                curr_meas = gather_measure(methods(ii).name,params,measures{kk},database,gt_set,cat_id);
            else
                curr_meas = gather_measure(methods(ii).name,params,measures{kk},database,gt_set);
            end
            curr_ods  = general_ods(curr_meas);
            curr_ois  = general_ois(curr_meas);
            curr_ap   = general_ap(curr_meas);
            % Plot method
            fprintf(['[odsF:' sprintf('%0.3f',curr_ods.mean_value) ' oisF:' sprintf('%0.3f',curr_ois.mean_value) ' AP:' sprintf('%0.3f',curr_ap) ']\n'])
            fig_handlers(end+1) = plot(curr_meas.mean_rec,curr_meas.mean_prec,[colors{ii} style]); %#ok<SAGROW>
            plot(curr_ods.mean_rec,curr_ods.mean_prec,[colors{ii} '*'])
            legends{end+1} = ['[odsF:' sprintf('%0.3f',curr_ods.mean_value) ' oisF:' sprintf('%0.3f',curr_ois.mean_value) ' AP:' sprintf('%0.3f',curr_ap) '] ' methods(ii).legend ]; %#ok<SAGROW>
        end
    end
    
    if strfind(gt_set,'_'), set_title = strrep(gt_set,'_','\_');else, set_title=gt_set;end
    
    title([measures{kk} ' ' database ' ' set_title]);
    legend(fig_handlers,legends, 'Location','NorthEastOutside')
end

%Write the results for LaTeX processing
if writePR
    if strcmp(database,'SBD')
        pr_curves_to_file(measures, database, gt_set, methods, cat_id);
    else
        pr_curves_to_file(measures, database, gt_set, methods);
    end
end

