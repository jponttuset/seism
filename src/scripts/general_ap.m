function AP = general_ap(stats)

AP=0;
if isfield(stats, 'mean_prec')
    [~,k] = unique(stats.mean_rec);
    k=k(end:-1:1);
    stats.mean_rec = stats.mean_rec(k);
    stats.mean_prec = stats.mean_prec(k);
    if(numel(stats.mean_rec)>1),
        AP = interp1(stats.mean_rec,stats.mean_prec,0:.01:1);
        AP = sum(AP(~isnan(AP)))/100;
    end
    
end
