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
    
    if isfield(stats, 'sumP')  % fb
        cntR = sum(stats.cntR(idx));
        sumR = sum(stats.sumR(idx));
        cntP = sum(stats.cntP(idx));
        sumP = sum(stats.sumP(idx));
        
        if sumR==0
            if cntP~=0
                error('Something wrong with this result')
            else
                rec = 1;
                prec = 0;
            end
        elseif sumP==0
            if cntR~=0
                error('Something wrong with this result')
            else
                rec = 0;
                prec = 1;
            end
        else
            rec = cntR/sumR;
            prec = cntP/sumP;
        end
        
        
        if (prec+rec)==0
            fmeas = 0;
        else
            fmeas = 2*prec*rec/(prec+rec);
        end
        
        ois_stats.mean_prec   = prec;
        ois_stats.mean_rec    = rec;
        ois_stats.mean_value  = fmeas;
        
        
    else % fop
        ois_stats.mean_prec   = mean(stats.prec(idx));
        ois_stats.mean_rec    = mean(stats.rec(idx));
        ois_stats.mean_value  = 2*(ois_stats.mean_prec*ois_stats.mean_rec)/(ois_stats.mean_prec+ois_stats.mean_rec);
    end
end

