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
#ifndef IMAGEPLUS_INTERSECTION_MATRIX_HPP
#define IMAGEPLUS_INTERSECTION_MATRIX_HPP

#include <set>
#include <map>
#include <list>
#include <misc/mex_helpers.hpp>

typedef unsigned int uint32;
typedef unsigned long long uint64;

typedef mex_types<uint32>::eigen_type part_type;
typedef mex_types<uint64>::eigen_type inters_type;

typedef std::map<uint32,uint32> part_bimap;


/*! It relabels a partition in scanning order. Bimaps are the look up tables of the relabeling.
 * 
 * \author Jordi Pont Tuset <jordi.pont@upc.edu>
 */
uint32 relabel(const part_type& partition_in, part_type& partition_out, part_bimap& bimap)
{
    mxAssert(partition_out.cols()==partition_in.cols(), "relabel: The x sizes of the partitions are not equal");
    mxAssert(partition_out.rows()==partition_in.rows(), "relabel: The y sizes of the partitions are not equal");
     
    std::size_t size_x = partition_in.rows();
    std::size_t size_y = partition_in.cols();
    
    uint32 max_region = 0;
    
    for(std::size_t ii=0; ii<size_x; ii++)
    {
        for(std::size_t jj=0; jj<size_y; jj++)
        {
            auto it = bimap.find(partition_in(ii,jj));
            
            if(it == bimap.end())
            {
                bimap[partition_in(ii,jj)] = max_region;
                partition_out(ii,jj) = max_region;
                max_region++;
            }
            else
            {
                partition_out(ii,jj) = it->second;
            }
        }
    }
    
    return max_region;
}


uint32 relabel(const part_type& partition_in, part_type& partition_out)
{
    part_bimap bimap;
    return relabel(partition_in, partition_out, bimap);
}

/*! It computes the intersection matrix between two partitions, i.e., an integer matrix where "M_ij" is
 *  the number of pixels in the intersection between i-th region in scanning order of partition 1 
 *  and j-th region of partition 2 in scanning order.
 * 
 *  This matrix is used by the majority of the distances between partition and its reusal can save computational time
 * if many distances have to be computed.
 * 
 * \author Jordi Pont Tuset <jordi.pont@upc.edu>
 * 
 * \param[in]   partition1  : First partition
 * \param[in]   partition2  : Second partition
 * \param[out]  bimap1      : Bimap (look up table) between the matrix coordinates and the original regions of partition1
 * \param[out]  bimap2      : Bimap (look up table) between the matrix coordinates and the original regions of partition2
 * \return Intersection matrix             
 */
inters_type intersection_matrix(const part_type& partition1, const part_type& partition2, part_bimap& bimap1, part_bimap& bimap2)
{
    uint64 s_x = partition1.rows();
    uint64 s_y = partition1.cols();

    mxAssert(s_x==partition2.rows(), "intersection_matrix: The X size must be the same for both partitions");
    mxAssert(s_y==partition2.cols(), "intersection_matrix: The Y size must be the same for both partitions");

    part_type partition1_relab(s_x,s_y);
    part_type partition2_relab(s_x,s_y);

    uint32 num_reg_1 = relabel(partition1, partition1_relab, bimap1);
    uint32 num_reg_2 = relabel(partition2, partition2_relab, bimap2);

    // "coincidence[i][j]" is a matrix that stores the number of intersecting pixels between region "i"
    // from the reference partition and region "j" from the fine partition
    inters_type inter_matrix = inters_type::Zero(num_reg_1,num_reg_2);
    for(uint64 jj = 0; jj < s_y; ++jj)
    {
        for(uint64 ii = 0; ii < s_x; ++ii)
        {
            inter_matrix(partition1_relab(ii,jj),partition2_relab(ii,jj)) += 1;
        }
    }

    return inter_matrix;
}

        
/*! It computes the intersection matrix between two partitions, i.e., an integer matrix where "M_ij" is
 *  the number of pixels in the intersection between i-th region in scanning order of partition 1 
 * and j-th region of partition 2 in scanning order.
 * It is useful, therefore, to compare the regions relabeled.
 * 
 *  This matrix is used by the majority of the distances between partition and its reusal can save computational time
 * if many distances have to be computed.
 * 
 * \author Jordi Pont Tuset <jordi.pont@upc.edu>
 * 
 * \param[in]  partition1  : First partition
 * \param[in]  partition2  : Second partition
 * \return Intersection matrix             
 */ 
inters_type intersection_matrix(const part_type& partition1, const part_type& partition2)
{
    part_bimap bimap1;
    part_bimap bimap2;

    return intersection_matrix(partition1, partition2, bimap1, bimap2);
}

#endif