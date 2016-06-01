function pr_curves_to_file(measures, database, gt_set, methods, cat_id, out_dir)

if ~exist('measures','var'),
    measures = {'fb' ,... % Precision-recall for boundaries
        'fop',... % Precision-recall for objects and parts
        };
end

if ~exist('database','var')||~exist('gt_set','var')||~exist('methods','var'),
    database = 'BSDS500';
    gt_set = 'test';
    methods  = [];
    methods(end+1).name = 'HED'     ;methods(end).type = 'contour'     ;
    methods(end+1).name = 'LEP'     ;methods(end).type = 'segmentation';
    methods(end+1).name = 'MCG'     ;methods(end).type = 'segmentation';
    methods(end+1).name = 'gPb-UCM' ;methods(end).type = 'segmentation';
    methods(end+1).name = 'ISCRA'   ;methods(end).type = 'segmentation';
    methods(end+1).name = 'NWMC'    ;methods(end).type = 'segmentation';
    methods(end+1).name = 'IIDKL'   ;methods(end).type = 'segmentation';
    methods(end+1).name = 'EGB'     ;methods(end).type = 'segmentation';
    methods(end+1).name = 'MShift'  ;methods(end).type = 'segmentation';
    methods(end+1).name = 'NCut'    ;methods(end).type = 'segmentation';
    methods(end+1).name = 'QuadTree';methods(end).type = 'segmentation';
end

if ~exist('out_dir','var'),
    out_dir = fullfile(seism_root,'results','pr_curves',database);
end
if ~exist(out_dir,'dir'),
    mkdir(out_dir);
end
metafix = '';

%% Write evertyhing to file
for kk=1:length(measures)
    %% Write methods
    for ii=1:length(methods)
        if strcmp(methods(ii).type,'contour')&&~strcmp(measures{kk},'fb'),continue;end
        % Get all parameters for that method from file
        params = get_method_parameters(methods(ii).name);
        
        % Gather pre-computed results
        if strcmp(database, 'SBD'),
            curr_meas = gather_measure(methods(ii).name,params,measures{kk},database,gt_set,num2str(cat_id));
            metafix = ['_' num2str(cat_id)];
        else
            curr_meas = gather_measure(methods(ii).name,params,measures{kk},database,gt_set);
        end
        curr_ods = general_ods(curr_meas);
        curr_ois = general_ois(curr_meas);
        curr_ap = general_ap(curr_meas);
        
        % Write PR curves
        fid = fopen(fullfile(out_dir, [database '_' gt_set '_' measures{kk} '_' methods(ii).name metafix '.txt']),'w');
        fprintf(fid,'Precision\tRecall\n');
        fclose(fid);
        dlmwrite(fullfile(out_dir, [database '_' gt_set '_' measures{kk} '_' methods(ii).name metafix '.txt']),...
            [curr_meas.mean_prec',curr_meas.mean_rec'],'-append','delimiter','\t','precision',4)
        
        % Write ODS PR
        fid = fopen(fullfile(out_dir, [database '_' gt_set '_' measures{kk} '_' methods(ii).name metafix '_ods.txt']),'w');
        fprintf(fid,'Precision\tRecall\n');
        fprintf(fid,'%f\t%f\n',curr_ods.mean_prec,curr_ods.mean_rec);
        fclose(fid);
        
        % Write ODS F
        fid = fopen(fullfile(out_dir, [database '_' gt_set '_' measures{kk} '_' methods(ii).name metafix '_ods_f.txt']),'w');
        fprintf(fid,'%.3f',2*curr_ods.mean_prec*curr_ods.mean_rec/(curr_ods.mean_prec+curr_ods.mean_rec));
        fclose(fid);
        
        % Write OIS F
        fid = fopen(fullfile(out_dir,[database '_' gt_set '_' measures{kk} '_' methods(ii).name metafix '_ois_f.txt']),'w');
        fprintf(fid,'%.3f\n',curr_ois.mean_value);
        fclose(fid);
        
        % Write AP
        fid = fopen(fullfile(out_dir,[database '_' gt_set '_' measures{kk} '_' methods(ii).name metafix '_ap.txt']),'w');
        fprintf(fid,'%.3f\n',curr_ap);
        fclose(fid);
    end
end


