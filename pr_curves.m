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
%  1) Create a folder inside "datasets" with a descriptive name e.g. "mymethod".
%  2) Create as many subfloders as working points you method has (e.g.
%     thresholds in UCM).
%  3) Create a file named "params.txt" with all the parameters sorted as wished.
%  4) Write your partitions in PRL format (prl_write provided) in the
%     corresponding parameter subfolder. The name must be $id_$param.txt,
%     where $id refers to the BSDS500 image id and $param is the value of the
%     parameter (name of the subfolder). See the available folders as
%     examples.
%  5) Evaluate your method with the piece of code below (just once, comment it when done)
%  6) Add your method to the list of methods to display.
%  7) Run the rest of the code and enjoy your PR curves!
% ------------------------------------------------------------------------ 

%% Experiments parameters
% BSDS500 set: train, test, val, trainval, or all
gt_set = 'test';

% Precision-recall measures
measures = {'fb' ,... % Precision-recall for boundaries
            'fop'};
        
%% Evaluate your method (just once for all parameters)

% Evaluate using the correct reading function
for ii=1:length(measures)
%     eval_method_all_params('MCG-HED', measures{ii}, @read_one_ucm, gt_set)
%     eval_method_all_params('EGB'    , measures{ii}, @read_one_prl, gt_set)
%     eval_method_all_params('LEP'    , measures{ii}, @read_one_lep, gt_set)
end

% Evaluate contours using the correct reading function
% eval_method_all_params('HED', 'fb', @read_one_cont_png, gt_set, 1)


%% PR curves methods to show
% List of segmentation methods to show (add your methods)
methods   = {'MCG-HED','HED','LEP','MCG','gPb-UCM','EGB','NCut','MShift'};
which_contours = {'HED'};
colors = {'k','g','b','r','m','c','y','r','k'};

%% Plot PR curves
for kk=1:length(measures)
    iso_f_axis(measures{kk})
    fig_handlers = [];
    legends = {};
    
    % Plot human
    human_same = gather_human(measures{kk}, 'same', gt_set, 'human_perf');
    human_diff = gather_human(measures{kk}, 'diff', gt_set, 'human_perf');
    fig_handlers(end+1) = plot(human_same.mean_rec,human_same.mean_prec, 'rd'); %#ok<SAGROW>
    plot(human_diff.mean_rec,human_diff.mean_prec, 'rd');
    legends{end+1} = 'Human'; %#ok<SAGROW>
    
    % Plot methods
    for ii=1:length(methods)
        
        % Plot the contours only in 'fb'
        if strcmp(measures{kk},'fb') || all(~ismember(which_contours,methods{ii}))
            % Get all parameters for that method from file
            fid = fopen(fullfile(root_dir,'datasets',methods{ii},'params.txt'));
            if fid<0
                error([fullfile(root_dir,'datasets',methods{ii},'params.txt') ' not found! Have you downloaded the datasets? Have you followed the structure described in the header of pr_curves to add your new technique?'])
            end
            params = textscan(fid, '%s');
            params = params{1};
            fclose(fid);

            % Gather pre-computed results
            curr_meas = gather_measure(methods{ii},params,measures{kk},gt_set);
            curr_ods = general_ods(curr_meas);
            curr_ois = general_ois(curr_meas);

            % Plot method
            fig_handlers(end+1) = plot(curr_meas.mean_rec,curr_meas.mean_prec,[colors{ii} '-']); %#ok<SAGROW>
            plot(curr_ods.mean_rec,curr_ods.mean_prec,[colors{ii} '*'])
            legends{end+1} = [methods{ii} ' [' sprintf('%0.3f',curr_ods.mean_value) ']']; %#ok<SAGROW>
        end
    end
    
    legend(fig_handlers,legends, 'Location','NorthEastOutside')
end


