function [pdf, bin_centers, bin_left_limits] = compute_pdf(samples, num_bins, min_value, max_value)
    if nargin<3
        min_value = 0;    
    end
    if nargin<4
        max_value = 1;
    end
    tmp = linspace(min_value,max_value,num_bins);
    bin_left_limits = tmp(1:end-1);
    bin_centers = bin_left_limits + (min_value+max_value)/num_bins/2;
    n_1 = histc(samples,bin_left_limits);
    pdf = n_1/trapz(bin_centers, n_1);
    