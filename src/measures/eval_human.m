function [mean_meas, all_res] = eval_human(measure,database, gt_set)

im_ids = db_ids(database, gt_set);
all_res = [];
for ii=1:length(im_ids)
    disp(['Evaluating human performance on image: ' num2str(ii) '/' num2str(length(im_ids))]);
    % Read GT
    gt = db_gt(database,im_ids{ii});
    
    % Leave one out
    for jj=1:length(gt)
        % Out one, in the rest
        out_id = jj;
        in_ids = setdiff(1:length(gt),out_id);
        
        % Partition 'out', rest of GT 'in'
        part = gt{out_id};
        gt_in = gt(in_ids);
        
        % Eval
        all_res = [all_res; eval_segm(part,gt_in,measure)]; %#ok<AGROW>
    end
end


% Get the 'per-image' indices
idx = [];
for ii=1:length(im_ids)
    
    % Read GT
    gt = db_gt(database,im_ids{ii});
    
    idx = [idx; ii*ones(length(gt),1)]; %#ok<AGROW>
end
assert(length(idx)==size(all_res,1))



if strcmp(measure, 'fb')
    % Get the 'per-image' results
    im_rec  = zeros(length(im_ids),size(all_res,2));
    im_prec = zeros(length(im_ids),size(all_res,2));
    for ii=1:length(im_ids)
        cntR = sum(all_res(idx==ii,4));
        sumR = sum(all_res(idx==ii,5));
        cntP = sum(all_res(idx==ii,6));
        sumP = sum(all_res(idx==ii,7));

        im_rec(ii)  = cntR/sumR;
        im_prec(ii) = cntP/sumP;
    end 

    % Get the 'global' results
    cntR = sum(all_res(:,4));
    sumR = sum(all_res(:,5));
    cntP = sum(all_res(:,6));
    sumP = sum(all_res(:,7));

    rec  = cntR/sumR;
    prec = cntP/sumP;
    mean_meas = [rec prec];

    % Display
    plot(im_rec,im_prec,'r+')
    hold on
    plot(rec,prec,'bo')
    axis([0 1 0 1])
else
    % Mean
    im_res = zeros(length(im_ids),size(all_res,2));
    for ii=1:length(im_ids)
        im_res(ii,:) = mean(all_res(idx==ii,:));
    end 
    mean_meas = mean(im_res(:,[3,2]));
end

