function [ods_stats, ods_idx] = general_ods(stats)
% ods_stats = general_ods(stats)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------

[max_value, ods_idx] = max(stats.mean_value);
ods_stats.mean_value = max_value;

if isfield(stats, 'prec')
    ods_stats.mean_prec  = stats.mean_prec(ods_idx);
    ods_stats.mean_rec   = stats.mean_rec(ods_idx);
end



