clear all;close all;clc;

categories = 1:20;
database = 'SBD';
gt_set = 'val';

files = db_ids(database, gt_set);

res_path = '/home/kmaninis/scratch/BoundaryDetectionResults/SBD/ResNet50-mod-pc_40000';

for ii=1:length(categories),
    summ = zeros(length(files),1);
    tag = zeros(length(files),1);
    
    for i=1:length(files),
        if mod(i,500)==1,
            display(['Processing image ' num2str(i) ' of ' num2str(length(files))]);
        end
        prob = im2double(imread(fullfile(res_path, num2str(categories(ii)), [files{i} '.png'])));
        gt_cls = loadvar(fullfile(db_root_dir(database), 'cls', [files{i} '.mat']),'GTcls');
        if ismember(gt_cls.CategoriesPresent,categories(ii)),
            tag(i)=1;
        end
        
        summ(i) = sum(prob(:)>0.3);
    end
    
    % MdlLinear = fitcdiscr(summ,tag);
    % K = MdlLinear.Coeffs(1,2).Const;
    %
    % tag_test = zeros(length(files),1);
    % tag_test(summ>K+500)=1;
    
    p=zeros(length(files),1);r=p;f=p;
    for j=1:max(summ(:)),
        tag_test = zeros(length(files),1);
        tag_test(summ>=j)=1;
        %acc(j) = sum(tag_test==tag)/numel(tag_test);
        p(j) = sum(tag_test&tag)/sum(tag_test==1);
        r(j) = sum(tag_test&tag)/sum(tag==1);
        f(j) = 2.*p(j).*r(j)./max(p(j)+r(j),eps);
    end
    [~,ind] = max(f);
    Fscores(ii) = f(ind)
    GoldenThres(ii) = summ(ind)
end

save('thres.mat','Fscores','GoldenThres');
