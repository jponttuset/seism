function partition = read_one_prl(method_dir, parameter, im_id)
    
    res_file = fullfile(method_dir, parameter, [im_id '_' parameter '.prl']);
    if ~exist(res_file,'file')
        partition = [];
    else
        partition = prl_read(res_file);
    end
end