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
% BSDS500 set: train, test, val, trainval, or all
database = 'BSDS500';
gt_set   = 'test';

% Precision-recall measures
measures = {'fb' ,... % Precision-recall for boundaries
            'fop'};
 
% Define all methods to be compared
methods  = [];
methods(end+1).name = 'HED'     ; methods(end).io_func = @read_one_cont_png;
methods(end+1).name = 'LEP'     ; methods(end).io_func = @read_one_lep;
methods(end+1).name = 'MCG'     ; methods(end).io_func = @read_one_ucm;
methods(end+1).name = 'gPb-UCM' ; methods(end).io_func = @read_one_ucm;
methods(end+1).name = 'ISCRA'   ; methods(end).io_func = @read_one_ucm;
methods(end+1).name = 'NWMC'    ; methods(end).io_func = @read_one_ucm;
methods(end+1).name = 'IIDKL'   ; methods(end).io_func = @read_one_ucm;
methods(end+1).name = 'EGB'     ; methods(end).io_func = @read_one_prl;
methods(end+1).name = 'MShift'  ; methods(end).io_func = @read_one_prl;
methods(end+1).name = 'NCut'    ; methods(end).io_func = @read_one_prl;
methods(end+1).name = 'QuadTree'; methods(end).io_func = @read_one_prl;

% Which of these are only contours?
which_contours = {'HED'};

% Colors to display    
colors = {'k','g','b','r','m','c','y','r','k','g','b'};

%% Evaluate your method (just once for all parameters)

% Evaluate using the correct reading function
% for ii=1:length(measures)
%     for jj=1:length(methods)
%         % Contours only in 'fb'
%         is_cont = any(ismember(which_contours,methods(ii).name));
%         if strcmp(measures{ii},'fb') || ~is_cont
%             eval_method_all_params(methods(jj).name, measures{ii}, methods(jj).io_func, database, gt_set, is_cont)
%         end
%     end
% end

% % Helper to check existence of files
% test_io(methods, database, gt_set);

%% Plot PR curves
for kk=1:length(measures)
    iso_f_axis(measures{kk})
    fig_handlers = [];
    legends = {};
    
%     % Plot human
%     human_same = gather_human(measures{kk}, 'same', database, gt_set, 'human_perf');
%     human_diff = gather_human(measures{kk}, 'diff', database, gt_set, 'human_perf');
%     fig_handlers(end+1) = plot(human_same.mean_rec,human_same.mean_prec, 'rd'); %#ok<SAGROW>
%     plot(human_diff.mean_rec,human_diff.mean_prec, 'rd');
%     legends{end+1} = 'Human'; %#ok<SAGROW>
    
    % Plot methods
    for ii=1:length(methods)
        
        % Plot the contours only in 'fb'
        if strcmp(measures{kk},'fb') || all(~ismember(which_contours,methods(ii).name))
            % Get all parameters for that method from file
            params = get_method_parameters(methods(ii).name);

            % Gather pre-computed results
            curr_meas = gather_measure(methods(ii).name,params,measures{kk},database,gt_set);
            curr_ods = general_ods(curr_meas);
            curr_ois = general_ois(curr_meas);

            % Plot method
            fig_handlers(end+1) = plot(curr_meas.mean_rec,curr_meas.mean_prec,[colors{ii} '-']); %#ok<SAGROW>
            plot(curr_ods.mean_rec,curr_ods.mean_prec,[colors{ii} '*'])
            legends{end+1} = [methods(ii).name ' [' sprintf('%0.3f',curr_ods.mean_value) '-' sprintf('%0.3f',curr_ois.mean_value) ']']; %#ok<SAGROW>
        end
    end
    
    legend(fig_handlers,legends, 'Location','NorthEastOutside')
end


