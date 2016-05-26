function contour = read_one_cont_png(method_dir, parameter, im_id)
    
    res_file = fullfile(method_dir, [im_id '.png']);
    if ~exist(res_file,'file')
        contour = [];
    else
        contour = im2single(imread(res_file));
        [Ox,Oy] = gradient2(convTri(contour,4));
        [Oxx,~] = gradient2(Ox); [Oxy,Oyy]=gradient2(Oy);
        O       = mod(atan(Oyy.*sign(-Oxy)./(Oxx+1e-5)),pi);
        contour = edgesNmsMex(contour,O,1,5,1.01,1);
        %contour = contour>str2double(parameter);
        contour = double(contour>=max(eps,str2double(parameter)));
    end
end