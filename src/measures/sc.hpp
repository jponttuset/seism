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
#ifndef IMAGEPLUS_SC_HPP
#define IMAGEPLUS_SC_HPP

#include <misc/multiarray.hpp>

/*! It computes the Segmentation Covering of one partition to the ground-truth ands viceversa
 * 
 *  As presented in:
 *  P. Arbelaez, M. Maire, C. C. Fowlkes, and J. Malik.
 *  "Contour detection and hierarchical image segmentation."
 *  IEEE TPAMI, 33(5):898?916, 2011.
 */
float64 segmentation_covering(const MultiArray<uint64,2>& intersect_matrix)
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
            region_areas_1[ii] = region_areas_1[ii] +  intersect_matrix[ii][jj];
            region_areas_2[jj] = region_areas_2[jj] +  intersect_matrix[ii][jj];
        }
    }

    // Matrix containing the Jaccard indices of each pair of regions
    MultiArray<float64,2> jaccard_matrix(intersect_matrix.dims());
    for(std::size_t jj = 0; jj < num_reg_2; jj++)
    {
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            jaccard_matrix[ii][jj] = ((float64)intersect_matrix[ii][jj])/((float64)(region_areas_1[ii]+region_areas_2[jj]-intersect_matrix[ii][jj]));
        }
    }

    float64 curr_max;
    float64 segm_covering = 0.;
    for(uint64 ii=0; ii<num_reg_1; ii++)
    {
        curr_max=0;
        for(uint64 jj=0; jj<num_reg_2; ++jj)
        {
            if(curr_max<jaccard_matrix[ii][jj])
            {
                curr_max = jaccard_matrix[ii][jj];
            }
        }
        segm_covering += curr_max*region_areas_1[ii];
    }

    return segm_covering/(float64)image_area;
}

#endif
