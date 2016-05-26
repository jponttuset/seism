function [ error1, error2, intersection_point, error_curve ] = pdf_intersection( pdf1, pdf2, bin_centers )
    median_index_1 = compute_percentile_index(pdf1, 0.5);
    median_index_2 = compute_percentile_index(pdf2, 0.5);

    if(median_index_1<median_index_2)
        [ error1, error2, intersection_point, error_curve ] = intersection(pdf1, median_index_1, pdf2, median_index_2, bin_centers);
    elseif(median_index_1>median_index_2)
        [ error2, error1, intersection_point, error_curve ] = intersection(pdf2, median_index_2, pdf1, median_index_1, bin_centers);
    elseif(pdf1(round(median_index_1))>pdf2(round(median_index_2)) && median_index_1==1)
        [ error1, error2, intersection_point, error_curve ] = intersection(pdf1, median_index_1, pdf2, median_index_2, bin_centers);
    else
        error('Case not thought')
    end


function [ error_left, error_right, intersection_point, error_curve] = intersection( pdf_left, median_index_left, pdf_right, median_index_right, bin_centers )
    index = floor(median_index_left);
    while(pdf_left(index)>pdf_right(index))
        index = index + 1;
    end
    x1=pdf_right(index-1);
    x2=pdf_right(index);
    y1=pdf_left(index-1);
    y2=pdf_left(index);
    intersection_point(1) = bin_centers(index-1) + (y1-x1)/(x2-x1-y2+y1)*(bin_centers(index)-bin_centers(index-1));
    intersection_point(2) = y1 + (y1-x1)/(x2-x1-y2+y1)*(y2-y1);

    error_curve.left_curve_x = [bin_centers(1:index-1) intersection_point(1)];
    error_curve.left_curve_y = [pdf_right(1:index-1)' intersection_point(2)];
    
    error_curve.right_curve_x = [intersection_point(1) bin_centers(index:end)];
    error_curve.right_curve_y = [intersection_point(2) pdf_left(index:end)'];

    error_left = trapz(error_curve.left_curve_x, error_curve.left_curve_y);
    error_right = trapz(error_curve.right_curve_x, error_curve.right_curve_y);
