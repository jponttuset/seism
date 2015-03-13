function [ois_stats, ois_idx] = general_ois(stats)
% ods_stats = general_ods(stats)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------

[max_value, ois_idx] = max(stats.values,[],2);

if ~isfield(stats, 'prec')
    ois_stats.mean_value = mean(max_value);
else
    idx1 = 1:size(stats.values, 1);
    idx = sub2ind(size(stats.values), idx1', ois_idx);

    ois_stats.mean_prec   = mean(stats.prec(idx));
    ois_stats.mean_rec    = mean(stats.rec(idx));    
    ois_stats.mean_value  = 2*(ois_stats.mean_prec*ois_stats.mean_rec)/(ois_stats.mean_prec+ois_stats.mean_rec);
end

