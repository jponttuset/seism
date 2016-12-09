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

#include <misc/multiarray.hpp>

/*! It computes the Variation of Information measure
 * 
 *  As presented in:
 *   M. Meila.
 *   "Comparing clusterings: an axiomatic view."
 *   ICML, pages 577 ? 584, 2005.
 */
float64 variation_of_information(const MultiArray<uint64,2>& intersect_matrix)
{
    uint32 num_reg_1 = intersect_matrix.dims()[0];
    uint32 num_reg_2 = intersect_matrix.dims()[1];
    
    MultiArray<uint64,1> region_areas_1(num_reg_1);
    MultiArray<uint64,1> region_areas_2(num_reg_2);
    region_areas_1 = 0; region_areas_2 = 0;
    uint64 image_area=0;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            image_area += intersect_matrix[ii][jj];
            region_areas_1[ii] = region_areas_1[ii] + intersect_matrix[ii][jj];
            region_areas_2[jj] = region_areas_2[jj] + intersect_matrix[ii][jj];
        }
    }
    
    // Compute H(S)
    float64 entropy_1 = 0.;
    for(std::size_t ii = 0; ii < num_reg_1; ii++)
    {
        entropy_1 += region_areas_1[ii]*log((float64)region_areas_1[ii]/(float64)image_area);
    }
    entropy_1 = (-1.)*entropy_1/log(2.)/image_area;

    // Compute H(S')
    float64 entropy_2 = 0.;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        entropy_2 += region_areas_2[jj]*log((float64)region_areas_2[jj]/(float64)image_area);
    }
    entropy_2 = (-1.)*entropy_2/log(2.)/image_area;
    
    // Compute mutual info
    float64 mutual_info = 0.;
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            if(intersect_matrix[ii][jj]!=0)
            {
                mutual_info += (float64)intersect_matrix[ii][jj]*log((float64)image_area*(float64)intersect_matrix[ii][jj]/region_areas_1[ii]/region_areas_2[jj]);
            }
        }
    }
    
    mutual_info = mutual_info/log(2.)/image_area;

    return entropy_1 + entropy_2 - 2.*mutual_info;
}

#endif