function params = get_method_parameters(method)
    % Get all parameters
    file_name = fullfile(seism_root,'parameters',[method,'.txt']);
    if ~exist(file_name,'file')
        error(['' file_name ''' not found'])
    end
    fid = fopen(file_name);
    params = textscan(fid, '%s');
    params = params{1};
    fclose(fid);
end