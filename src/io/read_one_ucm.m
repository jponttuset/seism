function partition = read_one_ucm(method_dir, parameter, im_id)
    
    res_file = fullfile(method_dir, [im_id '.mat']);
    if ~exist(res_file,'file')
        partition = [];
    else
        ucm2 = loadvar(res_file, 'ucm2');
        partition = uint32(gridbmap2seg(ucm2>str2double(parameter)));
    end
end