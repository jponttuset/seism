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
#include <string.h>
#include <fstream>
#include <iostream>
#include <typeinfo>
#include <math.h>
#include "mex.h"

/* Input Arguments */
#define	FILE	prhs[0]

/* Output Arguments */
#define	PART    plhs[0]

typedef unsigned long long uint64;
typedef unsigned int uint32;
typedef unsigned char uint8;

class ReadBitStream
{
    public:
        ReadBitStream()
        {
        	_bits_left  = 0;
            _buffer = 0;
        }
        explicit ReadBitStream( const std::string& filename )
        {
            _bits_left  = 0;
            _buffer = 0;
            open(filename);
        }
        void open( const std::string& filename )
        {
            _filename = filename;

            // Open file to read
            _fp.open(_filename.c_str(), std::ios::in | std::ios::binary);
            if (!_fp.is_open())
            {
                mexErrMsgTxt("File not found.");
            }
        }

        void close( )
        {
            _fp.close( );
        }

        void seekg( uint64 position )
        {
            uint8  offset_bits  = (uint8)(position % 8);
            uint64 offset_bytes = position >> 3;

            if (!_fp.is_open())
            {
                mexErrMsgTxt("Call 'open' before trying to move the pointer from a file.");
            }

            _fp.seekg((std::streamoff)offset_bytes);
            _bits_left  = 0;
            _buffer = 0;

            if (offset_bits)
            {
                read(offset_bits);
            }
        }


        uint64 tellg( )
        {
            if (!_fp.is_open())
            {
                mexErrMsgTxt("Call 'open' before trying to get the position of the pointer in a file.");
            }

            return (uint64)(_fp.tellg()*8 - _bits_left);
        }


        uint64 read( uint8 n_bits_to_read )
        {
            if (!_fp.is_open())
            {
                mexErrMsgTxt("Call 'open' before trying to read from a file.");
            }
            
            if(n_bits_to_read > 64)
            {
                n_bits_to_read = 64;
            }

            uint64 to_return = 0;

            if (n_bits_to_read)
            {
                const uint8 mask = 255;

                uint8 still_to_read = n_bits_to_read;

                while(still_to_read>_bits_left)
                {
                    to_return = to_return + ((uint64)_buffer<<(still_to_read-_bits_left));
                    _fp.read((char*)&_buffer, 1);
                    still_to_read = still_to_read - _bits_left;
                    _bits_left = 8;
                }

                _bits_left = _bits_left-still_to_read;
                to_return = to_return + ((uint64)_buffer>>_bits_left);
                _buffer = _buffer&(mask>>(8-_bits_left));
            }
            else
            {
                to_return=0;
            }

            return to_return;
        }

    private:
        std::string _filename;
        std::ifstream _fp;
        uint8 _buffer;
        uint8 _bits_left;
};





void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
{ 
    char* filename;
    unsigned int* part;

    /* Check for proper number of arguments */    
    if (nrhs == 0) { 
	mexErrMsgTxt("One input arguments required."); 
    } else if (nlhs > 1) {
	mexErrMsgTxt("Too many output arguments."); 
    } 
    
    filename = mxArrayToString(FILE);
    
    std::ifstream in_file;
    in_file.open(filename, std::ios::in | std::ios::binary);
    if (!in_file.is_open())
    {
        mexErrMsgTxt("File not found.");
    }
    
    short unsigned int mn;
    in_file.read((char*)&mn, sizeof(mn));
    // std::cout << mn << std::endl;
    
    char ft;
    in_file.read(&ft, sizeof(ft));
    // std::cout << (int)ft << std::endl;

    char ct;
    in_file.read(&ct, sizeof(ct));
    // std::cout << (int)ct << std::endl;
    
    char dt;
    in_file.read(&dt, sizeof(dt));
    // std::cout << (int)dt << std::endl;    

    unsigned long long nd;
    in_file.read((char*)&nd,sizeof(nd));
    // std::cout << nd << std::endl;
    
    unsigned long long sd1;
    in_file.read((char*)&sd1,sizeof(sd1));
    // std::cout << sd1 << std::endl;

    unsigned long long sd2;
    in_file.read((char*)&sd2,sizeof(sd2));
    // std::cout << sd2 << std::endl;
    
    char nb;
    in_file.read(&nb, sizeof(nb));
    // std::cout << (int)nb << std::endl;
    
    /* Create a matrix for the return argument */ 
    PART = mxCreateNumericMatrix((mwSize)sd1, (mwSize)sd2, mxUINT32_CLASS, mxREAL); 
    
    /* Assign pointers to the various parameters */ 
    part = (unsigned int*)mxGetData(PART);
    
    ReadBitStream rbs(filename);

    // Skip the header
    rbs.seekg(112+64*nd);         

    std::size_t total_elem = sd1*sd2;
    std::size_t num_read_elem = 0;
    uint64 read_bits = 0;
    uint32 max_label = 0;
    uint32 current_label;
    uint8 current_length;
    std::size_t  width = sd1;

    while(num_read_elem < total_elem)
    {            
        // Label casuistics
        read_bits = rbs.read(1);
        if(read_bits == 0) // "Up" value
        {
            current_label = *(part - width); 
        }
        else
        {
            read_bits = rbs.read(1);

            if(read_bits == 0) // "Up-one-right" value
            {
                const uint32 *up_value = (part - width);
                uint32 *up_right_value = (part - width + 1);
                while(*up_value == *up_right_value)
                {
                    up_right_value++;
                }
                current_label = *up_right_value; 
            }
            else
            {
                read_bits = rbs.read(1);

                if(read_bits == 0) // "Max+1" value
                {
                    max_label = max_label + 1;
                    current_label = max_label;
                }
                else
                {
                    read_bits = rbs.read(nb);
                    current_label = (uint32)read_bits;
                    if(current_label>max_label)
                    {
                        max_label = current_label;
                    }
                }
            }
        }

        //Length casuistics
        read_bits = rbs.read(1);

        if(read_bits == 1) // 8 bits length
        {
            read_bits = rbs.read(8);
            current_length = (uint8)read_bits; 
        }
        else
        {
            read_bits = rbs.read(2);
            current_length = (uint8)read_bits + 1;
        }

        for(uint8 ii=0; ii<current_length; ii++)
        {
            *part++ = current_label;
        }

        num_read_elem += current_length;
    }
    
    
    // Transpose it (our scanning order is not the same than Matlab)
    mxArray *x = PART;
    mexCallMATLAB(1,&PART,1, &x, "transpose");
    
    in_file.close();
    
    return;
}


