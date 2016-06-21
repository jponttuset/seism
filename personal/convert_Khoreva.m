database = 'SBD';
gt_set = 'val';
out_dir = fullfile(seism_root,'results','pr_curves',database);
categories = importdata('/srv/glusterfs/kmaninis/Databases/Boundary_Detection/PASCALContext/categories.txt');
categories{11} = 'diningtable';


for ii=1:length(categories),
    data = importdata(['/home/kmaninis/scratch/Downloads/evaluation/evaluation_on_SBD/Det._HED_cons.S&G/' categories{ii} '/eval_bdry_thr.txt']);
    curr_meas.mean_rec = data(:,2);
    curr_meas.mean_prec = data(:,3);
    f = 2*curr_meas.mean_rec.*curr_meas.mean_prec./(curr_meas.mean_prec+curr_meas.mean_rec+eps);
    [curr_ods.mean_value,ind] = max(f);
    curr_ods.mean_prec = curr_meas.mean_prec(ind);
    curr_ods.mean_rec = curr_meas.mean_rec(ind);
    curr_ap = general_ap(curr_meas);
    
    % Write PR curves
    fid = fopen(fullfile(out_dir, [database '_' gt_set '_fb_Khoreva_' num2str(ii) '.txt']),'w');
    fprintf(fid,'Precision\tRecall\n');
    fclose(fid);
    dlmwrite(fullfile(out_dir, [database '_' gt_set '_fb_Khoreva_' num2str(ii) '.txt']),...
        [curr_meas.mean_prec,curr_meas.mean_rec],'-append','delimiter','\t','precision',4)
    
    % Write ODS PR
    fid = fopen(fullfile(out_dir, [database '_' gt_set '_fb_Khoreva_' num2str(ii) '_ods.txt']),'w');
    fprintf(fid,'Precision\tRecall\n');
    fprintf(fid,'%f\t%f\n',curr_ods.mean_prec,curr_ods.mean_rec);
    fclose(fid);
    
    % Write ODS F
    fid = fopen(fullfile(out_dir, [database '_' gt_set '_fb_Khoreva_' num2str(ii) '_ods_f.txt']),'w');
    fprintf(fid,'%.3f',2*curr_ods.mean_prec*curr_ods.mean_rec/(curr_ods.mean_prec+curr_ods.mean_rec));
    fclose(fid);
    
    
    % Write AP
    fid = fopen(fullfile(out_dir,[database '_' gt_set '_fb_Khoreva_' num2str(ii) '_ap.txt']),'w');
    fprintf(fid,'%.3f\n',curr_ap);
    fclose(fid);
    
end