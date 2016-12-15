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
#ifndef IMAGEPLUS_VOI_HPP
#define IMAGEPLUS_VOI_HPP

#include <misc/mex_helpers.hpp>
#include <misc/intersection_matrix.hpp>

/*! It computes the Variation of Information measure
 * 
 *  As presented in:
 *   M. Meila.
 *   "Comparing clusterings: an axiomatic view."
 *   ICML, pages 577 ? 584, 2005.
 */
double variation_of_information(const inters_type& intersect_matrix)
{
    uint32 num_reg_1 = intersect_matrix.cols();
    uint32 num_reg_2 = intersect_matrix.rows();
    
    std::vector<uint64> region_areas_1(num_reg_1,0);
    std::vector<uint64> region_areas_2(num_reg_2,0);
    uint64 image_area=0;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            image_area += intersect_matrix(ii,jj);
            region_areas_1[ii] = region_areas_1[ii] + intersect_matrix(ii,jj);
            region_areas_2[jj] = region_areas_2[jj] + intersect_matrix(ii,jj);
        }
    }
    
    // Compute H(S)
    double entropy_1 = 0.;
    for(std::size_t ii = 0; ii < num_reg_1; ii++)
    {
        entropy_1 += region_areas_1[ii]*log((double)region_areas_1[ii]/(double)image_area);
    }
    entropy_1 = (-1.)*entropy_1/log(2.)/image_area;

    // Compute H(S')
    double entropy_2 = 0.;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        entropy_2 += region_areas_2[jj]*log((double)region_areas_2[jj]/(double)image_area);
    }
    entropy_2 = (-1.)*entropy_2/log(2.)/image_area;
    
    // Compute mutual info
    double mutual_info = 0.;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            if(intersect_matrix(ii,jj)!=0)
            {
                mutual_info += (double)intersect_matrix(ii,jj)*log((double)image_area*(double)intersect_matrix(ii,jj)/region_areas_1[ii]/region_areas_2[jj]);
            }
        }
    }
    
    mutual_info = mutual_info/log(2.)/image_area;

    return entropy_1 + entropy_2 - 2.*mutual_info;
}

#endif