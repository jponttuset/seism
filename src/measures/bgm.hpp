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
#ifndef IMAGEPLUS_BGM_HPP
#define IMAGEPLUS_BGM_HPP

#include <misc/multiarray.hpp>
#include <misc/hungarian.hpp>


//! It computes the Bipartite Graph Matching between two image partitions.
//! It corresponds to the minimum number of pixels that have to be ignored from both partitions for
//! the remaining partitions to be the same (up to relabeling).
//!
//! Presented in:
//! - X. Jiang, C. Marti, C. Irniger, and H. Bunke. "Distance measures for image segmentation evaluation,"
//!   EURASIP J. Appl. Signal Process., 2006.
//! - J.S. Cardoso, L. Corte-Real, "Toward a generic evaluation of image segmentation,"
//!   IEEE Transactions on Image Processing 14 (2005) 1773-1782.
//!
//! \author Jordi Pont Tuset <jordi.pont@upc.edu>
uint64 bipartite_graph_matching(const MultiArray<uint32,2>& partition1, const MultiArray<uint32,2>& partition2)
{
    uint64 s_x = partition1.dims()[0];
    uint64 s_y = partition1.dims()[1];

    mxAssert(s_x==partition2.dims()[0], "intersection_matrix: The X size must be the same for both partitions");
    mxAssert(s_y==partition2.dims()[1], "intersection_matrix: The Y size must be the same for both partitions");

    MultiArray<uint32,2> partition1_relab(boost::extents[s_x][s_y]);
    MultiArray<uint32,2> partition2_relab(boost::extents[s_x][s_y]);

    uint32 num_reg_1   = relabel(partition1, partition1_relab);
    uint32 num_reg_2   = relabel(partition2, partition2_relab);
    uint32 num_reg_max = std::max(num_reg_1, num_reg_2);

    // "cost[ii][jj]" is a matrix that stores the (negative of the) number of intersecting pixels between region "i"
    // from partition1 and region "j" from partition2
    MultiArray<float32,2> cost(num_reg_max,num_reg_max);
    cost = 0;
    for(uint64 jj = 0; jj < s_y; ++jj)
    {
        for(uint64 ii = 0; ii < s_x; ++ii)
        {
            cost[partition1_relab[ii][jj]][partition2_relab[ii][jj]] -= 1;
        }
    }
    return (uint64)((int64)s_x*s_y + (int64)hungarian(cost));
}

#endif
