// ------------------------------------------------------------------------ 
//  Copyright (C)
//  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
// 
//  Jordi Pont-Tuset <jordi.pont@upc.edu>
//  June 2013
// ------------------------------------------------------------------------ 
//  Code available at:
//  https://imatge.upc.edu/web/resources/supervised-evaluation-image-segmentation
// ------------------------------------------------------------------------
//  This file is part of the SEISM package presented in:
//    Jordi Pont-Tuset, Ferran Marques,
//    "Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
//    Computer Vision and Pattern Recognition (CVPR), 2013.
//  If you use this code, please consider citing the paper.
// ------------------------------------------------------------------------
#ifndef IMAGEPLUS_DHD_HPP
#define IMAGEPLUS_DHD_HPP

#include <misc/mex_helpers.hpp>
#include <misc/intersection_matrix.hpp>

//! It computes the Directional Hamming Distance (DHD) between two image partitions.
//! It corresponds to the minimum number of pixels that have to be ignored from both partitions for
//! one partition to be an oversegmentation of the other.
//!
//! Presented in:
//! - Q. Huang and B. Dom., "Quantitative methods of evaluating image segmentation," ICIP, 1995.
//! - J.S. Cardoso, L. Corte-Real, "Toward a generic evaluation of image segmentation,"
//!   IEEE Transactions on Image Processing 14 (2005) 1773-1782.
//!
//! \author Jordi Pont Tuset <jordi.pont@upc.edu>
uint64 directional_hamming_distance(const inters_type& intersect_matrix)
{
    std::size_t num_reg_1 = intersect_matrix.cols();
    std::size_t num_reg_2 = intersect_matrix.rows();

    // The pixels that remain are those with maximum intersection with the reference partition
    uint64 curr_max, sum_max=0, image_area=0;
    for(uint64 jj=0; jj<num_reg_2; ++jj)
    {
        curr_max=0;
        //uint64 ii_max=0; // AGIL: ii_max was set but not used, so it has been removed to avoid warnings in GCC-4.6
        for(uint64 ii=0; ii<num_reg_1; ii++)
        {
            image_area += intersect_matrix(ii,jj);
            if(curr_max<intersect_matrix(ii,jj))
            {
                curr_max = intersect_matrix(ii,jj);
                //ii_max   = ii; // AGIL: ii_max was set but not used, so it has been removed to avoid warnings in GCC-4.6
            }
        }
        sum_max += curr_max;
    }

    // The pixels that must be deleted are the total minus the sum of maximum intersections
    return image_area - sum_max;
}

#endif
