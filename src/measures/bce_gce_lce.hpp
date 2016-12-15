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
#ifndef IMAGEPLUS_BCE_GCE_LCE_HPP
#define IMAGEPLUS_BCE_GCE_LCE_HPP

#include <misc/mex_helpers.hpp>
#include <misc/intersection_matrix.hpp>

//! It computes the Bidirectional Consistency Error (BCE) between two image partitions. 
//!
//! Defined in: D. Martin, C. Fowlkes, D. Tal, and J. Malik. "A database of human segmented natural images
//!    and its application to evaluating segmentation algorithms and measuring ecological statistics."
//!    Intl. Conf. Computer Vision, II:416-423, July 2001.
//!
//! \author Jordi Pont Tuset <jordi.pont@upc.edu>
double bidirectional_consistency_error(const inters_type& intersect_matrix)
{
    uint32 num_reg_1 = intersect_matrix.cols();
    uint32 num_reg_2 = intersect_matrix.rows();

    std::vector<uint64> sum_row(num_reg_1,0);
    std::vector<uint64> sum_col(num_reg_2,0);
    uint64 image_area = 0;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            image_area += intersect_matrix(ii,jj);
            sum_row[ii] = sum_row[ii] +  intersect_matrix(ii,jj);
            sum_col[jj] = sum_col[jj] +  intersect_matrix(ii,jj);
        }
    }

    double bce = 0.0;

    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            uint64 edge = intersect_matrix(ii,jj);
            if(!edge)
                continue;

            bce += std::max((double)(sum_row[ii] - edge)/(double)sum_row[ii],
                            (double)(sum_col[jj] - edge)/(double)sum_col[jj])*edge;
        }
    }

    return bce / (double)image_area;
}


//! It computes the Global Consistency Error (GCE) between two image partitions. 
//!
//! Defined in: D. Martin, C. Fowlkes, D. Tal, and J. Malik. "A database of human segmented natural images
//!    and its application to evaluating segmentation algorithms and measuring ecological statistics."
//!    Intl. Conf. Computer Vision, II:416-423, July 2001.
//!
//! \author Jordi Pont Tuset <jordi.pont@upc.edu>
double global_consistency_error(const inters_type& intersect_matrix)
{
    uint32 num_reg_1 = intersect_matrix.cols();
    uint32 num_reg_2 = intersect_matrix.rows();

    std::vector<uint64> sum_row(num_reg_2,0);
    std::vector<uint64> sum_col(num_reg_1,0);
   
    uint64 image_area = 0;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            image_area += intersect_matrix(ii,jj);
            sum_row[jj] = sum_row[jj] +  intersect_matrix(ii,jj);
            sum_col[ii] = sum_col[ii] +  intersect_matrix(ii,jj);
        }
    }

    double gce1 = 0.0;
    double gce2 = 0.0;

    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            uint64 edge = intersect_matrix(ii,jj);
            if(!edge)
                continue;

            gce1 += (double)(sum_row[jj] - edge)*edge/(double)sum_row[jj];
            gce2 += (double)(sum_col[ii] - edge)*edge/(double)sum_col[ii];
        }
    }

    return std::min(gce1, gce2) / (double)(image_area);
}


//! It computes the Local Consistency Error (LCE) between two image partitions. 
//!
//! Defined in: D. Martin, C. Fowlkes, D. Tal, and J. Malik. "A database of human segmented natural images
//!    and its application to evaluating segmentation algorithms and measuring ecological statistics."
//!    Intl. Conf. Computer Vision, II:416-423, July 2001.
//!
//! \author Jordi Pont Tuset <jordi.pont@upc.edu>
double local_consistency_error(const inters_type& intersect_matrix)
{
    uint32 num_reg_1 = intersect_matrix.cols();
    uint32 num_reg_2 = intersect_matrix.rows();

    std::vector<uint64> sum_row(num_reg_2,0);
    std::vector<uint64> sum_col(num_reg_1,0);   
    uint64 image_area=0;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            image_area += intersect_matrix(ii,jj);
            sum_row[jj] = sum_row[jj] +  intersect_matrix(ii,jj);
            sum_col[ii] = sum_col[ii] +  intersect_matrix(ii,jj);
        }
    }

    double lce = 0.0;

    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            uint64 edge = intersect_matrix(ii,jj);
            if(!edge)
                continue;

            lce += std::min((double)(sum_row[jj] - edge)*edge/(double)sum_row[jj],
                            (double)(sum_col[ii] - edge)*edge/(double)sum_col[ii]);
        }
    }

    return lce / (double)image_area;
}



#endif
