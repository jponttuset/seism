function write_curves(root_dir,measure, method,curr_meas, curr_ods, curr_ois, curr_AP, database, gt_set)
% Generate files to be used by Jordi's latex code
% savedir: directory to save results
% measure: eg. 'fb', 'fop', ...
% method: the name of the method, eg: 'MCG'
% curr_meas, curr_ods, curr_ois: keep the format of pr_curves.m

save_dir = fullfile(root_dir,database);
if ~exist(save_dir,'dir'),
        mkdir(save_dir);
end
    
fid = fopen(fullfile(save_dir,[database '_' gt_set '_' measure '_' method '.txt']),'w');
fprintf(fid,'Precision\tRecall\n');
for i=1:length(curr_meas.mean_rec),
    fprintf(fid,'%f\t%f\n',curr_meas.mean_prec(i),curr_meas.mean_rec(i));
end
fclose(fid);

fid = fopen(fullfile(save_dir,[database '_' gt_set '_' measure '_' method '_ods_f.txt']),'w');
fprintf(fid,'%.3f\n',curr_ods.mean_value);
fclose(fid);

fid = fopen(fullfile(save_dir,[database '_' gt_set '_' measure '_' method '_ois_f.txt']),'w');
fprintf(fid,'%.3f\n',curr_ois.mean_value);
fclose(fid);

fid = fopen(fullfile(save_dir,[database '_' gt_set '_' measure '_' method '_ap.txt']),'w');
fprintf(fid,'%.3f\n',curr_AP);
fclose(fid);

fid = fopen(fullfile(save_dir,[database '_' gt_set '_' measure '_' method '_ods.txt']),'w');
fprintf(fid,'Precision\tRecall\n');
fprintf(fid,'%f\t%f\n', curr_ods.mean_prec, curr_ods.mean_rec);
fclose(fid);

end