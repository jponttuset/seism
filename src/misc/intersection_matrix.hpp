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

#include <aux/types.hpp>
#include <aux/matlab_multiarray.hpp>
#include <aux/multiarray.hpp>

#include <set>
#include <list>

/*! It relabels a partition in scanning order. Bimaps are the look up tables of the relabeling.
 * 
 * \author Jordi Pont Tuset <jordi.pont@upc.edu>
 */
uint32 relabel(const MultiArray<uint32,2>& partition_in, MultiArray<uint32,2>& partition_out, part_bimap& bimap)
{
    mxAssert(partition_out.dims()[0]==partition_in.dims()[0], "relabel: The x sizes of the partitions are not equal");
    mxAssert(partition_out.dims()[1]==partition_in.dims()[1], "relabel: The y sizes of the partitions are not equal");
     
    std::size_t size_x = partition_in.dims()[0];
    std::size_t size_y = partition_in.dims()[1];
    
    part_bimap::left_const_iterator it;
    part_bimap::left_const_iterator it_end = bimap.left.end();
    
    uint32 max_region = 0;
    
    for(std::size_t ii=0; ii<size_x; ii++)
    {
        for(std::size_t jj=0; jj<size_y; jj++)
        {
            it = bimap.left.find(partition_in[ii][jj]);
            
            if(it == it_end)
            {
                bimap.insert(part_bimap::value_type(partition_in[ii][jj], max_region) );
                partition_out[ii][jj] = max_region;
                max_region++;
            }
            else
            {
                partition_out[ii][jj] = it->second;
            }
        }
    }
    
    return max_region;
}


uint32 relabel(const MultiArray<uint32,2>& partition_in, MultiArray<uint32,2>& partition_out)
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
MultiArray<uint64,2> intersection_matrix(const MultiArray<uint32,2>& partition1, const MultiArray<uint32,2>& partition2, part_bimap& bimap1, part_bimap& bimap2)
{
    uint64 s_x = partition1.dims()[0];
    uint64 s_y = partition1.dims()[1];

    mxAssert(s_x==partition2.dims()[0], "intersection_matrix: The X size must be the same for both partitions");
    mxAssert(s_y==partition2.dims()[1], "intersection_matrix: The Y size must be the same for both partitions");

    MultiArray<uint32,2> partition1_relab(boost::extents[s_x][s_y]);
    MultiArray<uint32,2> partition2_relab(boost::extents[s_x][s_y]);

    uint32 num_reg_1 = relabel(partition1, partition1_relab, bimap1);
    uint32 num_reg_2 = relabel(partition2, partition2_relab, bimap2);

    // "coincidence[i][j]" is a matrix that stores the number of intersecting pixels between region "i"
    // from the reference partition and region "j" from the fine partition
    MultiArray<uint64,2> inter_matrix(boost::extents[num_reg_1][num_reg_2]);
    for(uint64 jj = 0; jj < s_y; ++jj)
    {
        for(uint64 ii = 0; ii < s_x; ++ii)
        {
            inter_matrix[partition1_relab[ii][jj]][partition2_relab[ii][jj]] += 1;
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
MultiArray<uint64,2> intersection_matrix(MultiArray<uint32,2>& partition1, MultiArray<uint32,2>& partition2)
{
    part_bimap bimap1;
    part_bimap bimap2;

    return intersection_matrix(partition1, partition2, bimap1, bimap2);
}

#endif