
%% Experiments parameterization
% BSDS500 set: train, test, val, trainval, or all
database = 'BSDS500';
gt_set = 'test';

% Precision-recall measures
measures = {'fb' ,... % Precision-recall for boundaries
            'fop',... % Precision-recall for objects and parts  
            };

% List of segmentation methods to evaluate
methods   = {'LEP'}; 

out_dir = '~';


%% Write evertyhing to file
for kk=1:length(measures)
    
    %% Write methods
    for ii=1:length(methods)
        % Get all parameters for that method from file
        params = get_method_parameters(methods{ii});
    
        % Gather pre-computed results
        curr_meas = gather_measure(methods{ii},params,measures{kk},database,gt_set);
        curr_ods = general_ods(curr_meas);
        curr_ois = general_ois(curr_meas);
        
        % Write PR curves
        fid = fopen(fullfile(out_dir, [measures{kk} '_' methods{ii} '.txt']),'w');
        fprintf(fid,'Precision\tRecall\n');
        fclose(fid);
        dlmwrite(fullfile(out_dir, [measures{kk} '_' methods{ii} '.txt']),...
            [curr_meas.mean_prec',curr_meas.mean_rec'],'-append','delimiter','\t','precision',4)
        
%         % Write ODS PR
%         fid = fopen(fullfile(out_dir, [measures{kk} '_' methods{ii} '_ods.txt']),'w');
%         fprintf(fid,'Precision\tRecall\n');
%         fprintf(fid,'%f\t%f\n',curr_ods.mean_prec,curr_ods.mean_rec);
%         fclose(fid);
%         
%         % Write ODS F
%         fid = fopen(fullfile(out_dir, [measures{kk} '_' methods{ii} '_ods_f.txt']),'w');
%         fprintf(fid,'%.2f',2*curr_ods.mean_prec*curr_ods.mean_rec/(curr_ods.mean_prec+curr_ods.mean_rec));
%         fclose(fid);
    end
end


