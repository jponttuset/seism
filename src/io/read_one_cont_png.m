function contour = read_one_cont_png(method_dir, parameter, im_id)
    
    res_file = fullfile(method_dir, [im_id '.png']);
    if ~exist(res_file,'file')
        contour = [];
    else
        contour = im2double(imread(res_file))>str2double(parameter);
    end
end