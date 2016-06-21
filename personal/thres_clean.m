clear all;close all;clc;

categories = 1:20;
database = 'SBD';
gt_set = 'val';

files = db_ids(database, gt_set);

res_path = '/home/kmaninis/scratch/BoundaryDetectionResults/SBD/ResNet50-mod-pc_40000';
save_path = '/home/kmaninis/scratch/BoundaryDetectionResults/SBD/ResNet50-mod-pc_40000_clean';
load('thres.mat');

for ii=2:20,
    categories(ii)=ii;
    if ~exist(fullfile(save_path,num2str(categories(ii))),'dir'),
        mkdir(fullfile(save_path,num2str(categories(ii))));
    end
    for i=1:length(files),
        if mod(i,500)==1,
            display(['Processing image ' num2str(i) ' of ' num2str(length(files))]);
        end
        prob = im2double(imread(fullfile(res_path, num2str(categories(ii)), [files{i} '.png'])));
        summ = sum(prob(:)>0.3);
        if summ>GoldenThres(categories(ii)),
            imwrite(prob,fullfile(save_path,num2str(categories(ii)),[files{i} '.png']));
        else
            imwrite(zeros(size(prob)),fullfile(save_path,num2str(categories(ii)),[files{i} '.png']));
        end
    end
end