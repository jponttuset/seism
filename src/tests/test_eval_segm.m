measures = {%
            'fb'  ,... % Precision-recall for boundaries
            'fop' ,... % Precision-recall for objects and parts
            'fr'  ,... % Precision-recall for regions
            'voi' ,... % Variation of information
            'nvoi',... % Normalized variation of information
            'pri' ,... % Probabilistic Rand index
            'sc'  ,'ssc' ,... % Segmentation covering (two directions)
            'dhd' ,'sdhd',... % Directional Hamming distance (two directions)
            'bgm' ,... % Bipartite graph matching
            'vd'  ,... % Van Dongen
            'bce' ,... % Bidirectional consistency error
            'gce' ,... % Global consistency error
            'lce' ,... % Local consistency error
            };
        
% Check perfect is 1
for ii=1:length(measures)
    res = eval_segm([1 1; 1 1], [1 1; 1 1],measures{ii});
    disp([measures{ii} ': ' num2str(res)])
end

% Real examples
% load(fullfile(root_dir, 'bsds500','ground_truth','120003.mat'))
% 
% eval_segm(gt_seg{1},gt_seg(2:end));

