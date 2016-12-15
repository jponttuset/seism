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
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <vector>
#include "mex.h"
        
#include <misc/mex_helpers.hpp>        
#include <misc/intersection_matrix.hpp>

typedef unsigned int uint32;

void
mexFunction( int nlhs, mxArray *plhs[],
             int nrhs, const mxArray *prhs[] )
{
    // Check number of inputs
    if (nrhs<2)
        mexErrMsgTxt("At least two arguments needed");

    // Check type of partition
    if (mxGetClassID(prhs[0])!=mxUINT32_CLASS)
        mexErrMsgTxt("The partition should be in uint32\n");
    
    // Partition as Eigen
    auto part = eigen_map<uint32>(prhs[0]);
    mexPrintf("Sizes part: %d, %d\n",part.rows(), part.cols());

    mexPrintf("Part\n");
    for(std::size_t xx=0; xx<part.rows(); ++xx)
    {
        for(std::size_t yy=0; yy<part.cols(); ++yy)
        {
            mexPrintf("%d, ",part(xx,yy));
        }
        mexPrintf("\n");
    }
        
    // Check type of ground truth
    if (mxGetClassID(prhs[1])!=mxCELL_CLASS)
        mexErrMsgTxt("Ground truth should be a cell\n");
    std::size_t n_gts = mxGetNumberOfElements(prhs[1]);

    // Ground truths as Eigen
    std::vector<mex_types<uint32>::eigen_type> gts(n_gts);
    for(std::size_t ii=0; ii<n_gts; ++ii)
    {
        if (mxGetClassID(mxGetCell(prhs[1],ii))!=mxUINT32_CLASS)
            mexErrMsgTxt("The ground truths should be in uint32\n");
        
        gts[ii] = eigen_map<uint32>(mxGetCell(prhs[1],ii));
        mexPrintf("Sizes GT: %d, %d\n",gts[ii].rows(),gts[ii].cols());
    }
    
    // Relabel
    part_type part_relab(part.rows(),part.cols());
    uint32 nregs = relabel(part, part_relab);
    mexPrintf("nregs part: %d\n",nregs);
        
    mexPrintf("Part relab\n");
    for(std::size_t xx=0; xx<part_relab.rows(); ++xx)
    {
        for(std::size_t yy=0; yy<part_relab.cols(); ++yy)
        {
            mexPrintf("%d, ",part_relab(xx,yy));
        }
        mexPrintf("\n");
    }

    // Compute intersection matrices
    std::vector<mex_types<uint64>::eigen_type> int_mats(n_gts);
    for(std::size_t ii=0; ii<n_gts; ++ii)
    {
        int_mats[ii] = intersection_matrix(part, gts[ii]);
        mexPrintf("Sizes int: %d, %d\n",int_mats[ii].cols(), int_mats[ii].rows());
        for(std::size_t xx=0; xx<int_mats[ii].rows(); ++xx)
        {
            for(std::size_t yy=0; yy<int_mats[ii].cols(); ++yy)
            {
                mexPrintf("%d\t",int_mats[ii](xx,yy));
            }
            mexPrintf("\n");
        }
    }
}
