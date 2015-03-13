function exp_par = CVPR2013_exp_params()
% Experiments parameterization

% BSDS500 set: train, test, val, trainval, or all
exp_par.gt_set = 'test';
exp_par.im_ids = load(fullfile(root_dir,'bsds500', ['ids_' exp_par.gt_set '.txt']));

% List of available evaluation measures 
exp_par.measures = {%
            'fb'  ,... % Precision-recall for boundaries
            'fop' ,... % Precision-recall for objects and parts
            'fr'  ,... % Precision-recall for regions
            'nvoi',... % Normalized variation of information
            'pri' ,... % Probabilistic Rand index
            'sc'  ,'ssc' ,... % Segmentation covering (two directions)
            'dhd' ,'sdhd',... % Directional Hamming distance (two directions)
            'bgm' ,... % Bipartite graph matching
            'vd'  ,... % Van Dongen
            'bce' ,... % Bidirectional consistency error
            };

% List of segmentation methods to evaluate
exp_par.methods.ids   = {'UCM','EGB','NCut','MShift','NWMC','IIDKL'};
exp_par.baselines.ids = {'QuadTree'};
exp_par.swapped.ids   = {'UCM_swapped','EGB_swapped','NCut_swapped','MShift_swapped','NWMC_swapped','IIDKL_swapped'};
                
% Get the method parameters from file
for ii=1:length(exp_par.methods.ids)
    fid = fopen(fullfile(root_dir,'datasets',exp_par.methods.ids{ii},'params.txt'));
    params = textscan(fid, '%s');
    exp_par.methods.params{ii} = params{1};
    fclose(fid);
end
for ii=1:length(exp_par.baselines.ids)
    fid = fopen(fullfile(root_dir,'datasets',exp_par.baselines.ids{ii},'params.txt'));
    params = textscan(fid, '%s');
    exp_par.baselines.params{ii} = params{1};
    fclose(fid);
end
for ii=1:length(exp_par.swapped.ids)
    fid = fopen(fullfile(root_dir,'datasets',exp_par.swapped.ids{ii},'params.txt'));
    params = textscan(fid, '%s');
    exp_par.swapped.params{ii} = params{1};
    fclose(fid);
end
