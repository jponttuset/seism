
%% Experiments parameterization
% BSDS500 set: train, test, val, trainval, or all
database = 'BSDS500';
gt_set = 'test';

% Precision-recall measures
measures = {'fb' ,... % Precision-recall for boundaries
            'fop',... % Precision-recall for objects and parts  
            };

% Define all methods to be compared
methods  = [];
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

out_dir = '~';


%% Write evertyhing to file
for kk=1:length(measures)
    
    %% Write methods
    for ii=1:length(methods)
        % Get all parameters for that method from file
        params = get_method_parameters(methods(ii).name);
    
        % Gather pre-computed results
        curr_meas = gather_measure(methods(ii).name,params,measures{kk},database,gt_set);

        
        % Write PR curves
        fid = fopen(fullfile(out_dir, [database '_' gt_set '_' measures{kk} '_' methods(ii).name '.txt']),'w');
        fprintf(fid,'Precision\tRecall\n');
        fclose(fid);
        dlmwrite(fullfile(out_dir, [database '_' gt_set '_' measures{kk} '_' methods(ii).name '.txt']),...
            [curr_meas.mean_prec',curr_meas.mean_rec'],'-append','delimiter','\t','precision',4)
        
        % Write ODS PR
        curr_ods = general_ods(curr_meas);
        fid = fopen(fullfile(out_dir, [database '_' gt_set '_' measures{kk} '_' methods(ii).name '_ods.txt']),'w');
        fprintf(fid,'Precision\tRecall\n');
        fprintf(fid,'%f\t%f\n',curr_ods.mean_prec,curr_ods.mean_rec);
        fclose(fid);
        
        % Write ODS F
        curr_ois = general_ois(curr_meas);
        fid = fopen(fullfile(out_dir, [database '_' gt_set '_' measures{kk} '_' methods(ii).name '_ods_f.txt']),'w');
        fprintf(fid,'%.3f',2*curr_ods.mean_prec*curr_ods.mean_rec/(curr_ods.mean_prec+curr_ods.mean_rec));
        fclose(fid);
    end
end


