function percentile_index = compute_percentile_index(pdf, percentile)
    if nargin < 2
        percentile = 0.5;
    end

    th = sum(pdf)*percentile;
    ii=1;
    accum = pdf;
    while accum(ii) < th
        accum(ii+1) = accum(ii+1) + accum(ii);
        ii = ii + 1;
    end
    if ii == 1
        percentile_index = 1;
    else
        percentile_index = ii-(accum(ii)-th)/(accum(ii)-accum(ii-1));
    end
end