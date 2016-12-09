#include "mex.h"
#include "misc/matlab_multiarray.hpp"
#include <iostream>


void mexFunction( int nlhs, mxArray *plhs[], 
        		  int nrhs, const mxArray*prhs[] )
{      
    /* Input parameters of any type*/
    ConstMatlabMultiArray<double            > param_in_1(prhs[0]);
    ConstMatlabMultiArray<bool              > param_in_2(prhs[1]);
    ConstMatlabMultiArray<float             > param_in_3(prhs[2]);
    ConstMatlabMultiArray<char              > param_in_4(prhs[3]);
    ConstMatlabMultiArray<unsigned char     > param_in_5(prhs[4]);
    ConstMatlabMultiArray<short int         > param_in_6(prhs[5]);
    ConstMatlabMultiArray<unsigned short int> param_in_7(prhs[6]);
    ConstMatlabMultiArray<int               > param_in_8(prhs[7]);
    ConstMatlabMultiArray<unsigned int      > param_in_9(prhs[8]);
    ConstMatlabMultiArray<long long         > param_in_10(prhs[9]);    
    ConstMatlabMultiArray<unsigned long long> param_in_11(prhs[10]);

    /* Create output parameters */
    plhs[0]  =  mxCreateDoubleMatrix(param_in_1.shape()[0], param_in_1.shape()[1], mxREAL);
    plhs[1]  =  mxCreateLogicalMatrix(param_in_2.shape()[0], param_in_2.shape()[1]);
    plhs[2]  =  mxCreateNumericMatrix(param_in_3.shape()[0], param_in_3.shape()[1], mxSINGLE_CLASS, mxREAL);
    plhs[3]  =  mxCreateNumericMatrix(param_in_4.shape()[0], param_in_4.shape()[1], mxINT8_CLASS, mxREAL);
    plhs[4]  =  mxCreateNumericMatrix(param_in_5.shape()[0], param_in_5.shape()[1], mxUINT8_CLASS, mxREAL);
    plhs[5]  =  mxCreateNumericMatrix(param_in_6.shape()[0], param_in_6.shape()[1], mxINT16_CLASS, mxREAL);
    plhs[6]  =  mxCreateNumericMatrix(param_in_7.shape()[0], param_in_7.shape()[1], mxUINT16_CLASS, mxREAL);
    plhs[7]  =  mxCreateNumericMatrix(param_in_8.shape()[0], param_in_8.shape()[1], mxINT32_CLASS, mxREAL);
    plhs[8]  =  mxCreateNumericMatrix(param_in_9.shape()[0], param_in_9.shape()[1], mxUINT32_CLASS, mxREAL);
    plhs[9]  =  mxCreateNumericMatrix(param_in_10.shape()[0], param_in_10.shape()[1], mxINT64_CLASS, mxREAL);
    plhs[10] =  mxCreateNumericMatrix(param_in_11.shape()[0], param_in_11.shape()[1], mxUINT64_CLASS, mxREAL);
    
    /* Assign output parameters */
    MatlabMultiArray<double            > param_out_1(plhs[0]);
    MatlabMultiArray<bool              > param_out_2(plhs[1]);
    MatlabMultiArray<float             > param_out_3(plhs[2]);
    MatlabMultiArray<char              > param_out_4(plhs[3]);
    MatlabMultiArray<unsigned char     > param_out_5(plhs[4]);
    MatlabMultiArray<short int         > param_out_6(plhs[5]);
    MatlabMultiArray<unsigned short int> param_out_7(plhs[6]);
    MatlabMultiArray<int               > param_out_8(plhs[7]);
    MatlabMultiArray<unsigned int      > param_out_9(plhs[8]);
    MatlabMultiArray<long long         > param_out_10(plhs[9]);    
    MatlabMultiArray<unsigned long long> param_out_11(plhs[10]);    
}
