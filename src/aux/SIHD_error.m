function [ error1 error2 pdf_same pdf_diff intersection_point, error_curve, bin_centers] =...
                 sdd_error( same, different, num_bins )
if nargin<3
    num_bins = 30;
end
min_value = floor(min(min(same), min(different)));
max_value = ceil(max(max(same), max(different)));
pdf_same = compute_pdf(same, num_bins, min_value, max_value);
[pdf_diff, bin_centers] = compute_pdf(different, num_bins, min_value, max_value);

[error1, error2, intersection_point, error_curve] = pdf_intersection( pdf_same, pdf_diff, bin_centers );
error1 = sum(same<=intersection_point(1))/length(same);
error2 = sum(different>intersection_point(1))/length(different);
if(error1+error2>1)
    error1 = sum(different<=intersection_point(1))/length(different);
    error2 = sum(same>intersection_point(1))/length(same);
end
end
