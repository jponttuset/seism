function partition = read_one_lep(method_dir, parameter, im_id)
    
    res_file = fullfile(method_dir, [im_id '.mat']);
    if ~exist(res_file,'file')
        partition = [];
    else
        segs = loadvar(res_file,'segs');
        partition = uint32(relabel(segs{str2double(parameter)}));
    end
end