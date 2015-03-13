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
#ifndef IMAGEPLUS_PRI_FR_HPP
#define IMAGEPLUS_PRI_FR_HPP

#include <aux/multiarray.hpp>

/*! Class that handles the measures based on the "pairs-of-pixels" approach
 *  
 * \author Jordi Pont Tuset <jordi.pont@upc.edu>
 */ 
class PairsOfPixels
{
public:
    /*! Default constructor
     */
    PairsOfPixels(): _n11(0), _n00(0), _n01(0), _n10(0) 
    {
    }

    /*! It computes the classification of all pairs of pixels into N11, N01, N10, and N00. 
     * 
     *  \param[in] intersect_matrix : Intersection matrix between the two partitions
     */
    void calculate(const MultiArray<uint64,2>& intersect_matrix)
    {
        uint32 num_reg_1 = intersect_matrix.dims()[0];
        uint32 num_reg_2 = intersect_matrix.dims()[1];
        
        MultiArray<uint64,1> region_areas_1(num_reg_1);
        MultiArray<uint64,1> region_areas_2(num_reg_2);
        region_areas_1 = 0; region_areas_2 = 0;
        uint64 image_area=0;
        
        uint64 sum_inter_squared = 0;
        for(std::size_t jj = 0; jj < num_reg_2; jj++)
        {
            for(std::size_t ii = 0; ii < num_reg_1; ii++)
            {
                image_area += intersect_matrix[ii][jj];
                sum_inter_squared += (intersect_matrix[ii][jj]*intersect_matrix[ii][jj]);
                region_areas_1[ii] = region_areas_1[ii] +  intersect_matrix[ii][jj];
                region_areas_2[jj] = region_areas_2[jj] +  intersect_matrix[ii][jj];
            }
        }
        
        uint64 sum_areas_1_squared = 0;
        for(std::size_t ii = 0; ii < num_reg_1; ii++)
        {
            sum_areas_1_squared += (region_areas_1[ii]*region_areas_1[ii]);
        }
        
        uint64 sum_areas_2_squared = 0;
        for(std::size_t jj = 0; jj < num_reg_2; jj++)
        {
            sum_areas_2_squared += (region_areas_2[jj]*region_areas_2[jj]);
        }
        
        _n11 = (sum_inter_squared-image_area)/2;
        _n00 = (image_area*image_area-sum_areas_1_squared-sum_areas_2_squared+sum_inter_squared)/2;
        _n10 = (sum_areas_1_squared-sum_inter_squared)/2;
        _n01 = (sum_areas_2_squared-sum_inter_squared)/2;
    }


    /*! Rand index. .calculate() should be called before
     * 
     * Rand, W. 
     * "Objective Criteria for the Evaluation of Clustering Methods."
     * Journal of the American Statistical Association, 1971, 66, 846-850
     * 
     *  \return Rand index between partition and ground_truth
     */
    float64 rand_index()
    {
        ASSERT(_n11+_n01!=0, "PairsOfPixels: You should call claculate before computing any quality index");
        return (float64)(_n11+_n00)/(float64)(_n11+_n00+_n01+_n10);
    }

    /*! Precision for regions. calculate() should be called before
     * 
     * (Phdthesis) Martin, D. 
     * "An Empirical Approach to Grouping and Segmentation"
     * EECS Department, University of California, Berkeley, 2003
     * 
     *  \return Precision for regions between partition and ground_truth
     */
    float64 precision()
    {
        ASSERT(_n11+_n01!=0, "PairsOfPixels: You should call claculate before computing any quality index");
        return (float64)(_n11)/(float64)(_n11+_n10);
    }

    /*! Recall for regions. calculate() should be called before
     *
     * (Phdthesis) Martin, D. 
     * "An Empirical Approach to Grouping and Segmentation"
     * EECS Department, University of California, Berkeley, 2003
     * 
     *  \return Recall for regions between partition and ground_truth
     */            
    float64 recall()
    {
        ASSERT(_n11+_n01!=0, "PairsOfPixels: You should call claculate before computing any quality index");
        return (float64)(_n11)/(float64)(_n11+_n01);
    }

private:
    //! Number of pairs in the same regions in both partitions
    uint64 _n11;
    //! Number of pairs in different regions in both partitions
    uint64 _n00;
    //! Number of pairs in the same region in gt but different in partition
    uint64 _n01;
    //! Number of pairs in the same region in partition but different in gt 
    uint64 _n10;
};

#endif
