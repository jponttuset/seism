function test_io(methods, database, gt_set)
    for ii=1:length(methods)
        check_one_io(methods(ii).name, methods(ii).io_func, database, gt_set);
    end
end


function check_one_io(method, read_func, database, gt_set)
    % Get parameters for that method
    params = get_method_parameters(method);
    
    % Get image ids
    im_ids = load(fullfile(root_dir,database,['ids_' gt_set '.txt']));

    % We test for the all parameters and first image
    for ii=1:length(params)
        tmp = read_func(fullfile(root_dir,'datasets',method), params{ii}, im_ids{1});
        if isempty(tmp)
            disp(['ERROR: ''' fullfile(root_dir,'datasets',method) ''' for parameter ''' params{ii} ''' not found on ''' gt_set ''])
        end
    end
end
