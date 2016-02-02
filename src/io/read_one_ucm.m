function partition = read_one_ucm(method_dir, parameter, im_id)
    
    res_file = fullfile(method_dir, [im_id '.mat']);
    if ~exist(res_file,'file')
        partition = [];
    else
        ucm2 = loadvar(res_file, 'ucm2');
        param = str2double(parameter);

        % If param>1 they are asking for a number of regions
        % Otherwise it;s the threshold directly
        if param>1
            all_th = unique(ucm2);
            all_th(all_th==0) = [];
            if param>length(all_th)
                param = 0;
            else
                param = all_th(end-param+1);
            end
        end
       
        % Binarize and transform to partition
        partition = uint32(gridbmap2seg(ucm2>param));
    end
end