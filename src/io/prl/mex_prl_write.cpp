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
#define	PART	prhs[0]
#define	FILE    prhs[1]

        
enum OpenMode
{
    NEW, APPEND
};

enum DataType
{
    UINT8,INT8,UINT16,INT16,UINT32,INT32,UINT64,INT64,FLOAT32,FLOAT64,NONETYPE
};

typedef unsigned long long uint64;
typedef unsigned int uint32;
typedef unsigned char uint8;
typedef unsigned short uint16;

//! \brief magick number for mult files
const uint16 MULT_MAGIC_NUMBER = 255;

//! \brief default filetype for mult files
const uint8 MULT_FILETYPE = 1;

class WriteBitStream
{
    public:
        WriteBitStream()
        {
            _space  = 8;
        	_buffer = 0;
        }

        explicit WriteBitStream( const std::string& filename, OpenMode mode = NEW )
        {
            _space  = 8;
        	_buffer = 0;
            open(filename, mode);
        }
    
        ~WriteBitStream()
        {
        }

        void open( const std::string& filename, OpenMode mode = NEW )
        {
            _filename = filename;

            if ( _fp.is_open() )
                mexErrMsgTxt("BitStream already open, close it first");

            _space  = 8;
            _buffer = 0;

            // Open file to write
            if (mode==NEW)
            {
                _fp.open(_filename.c_str(), std::ios::out | std::ios::binary );
            }
            else if  (mode==APPEND)
            {
                _fp.open(_filename.c_str(), std::ios::out | std::ios::binary | std::ios::app);
            }
            else
            {
                mexErrMsgTxt("Unknowm open mode in WriteBitStream");
            }

            if (!_fp.is_open())
            {
                mexErrMsgTxt("File not found");
            }
        }

        void close( )
        {
            force_write();
            _fp.close();
        }

        void write( uint64 to_write, uint8 n_bits_to_write )
        {
            //#ifdef
            if (!_fp.is_open())
            {
                mexErrMsgTxt("Call 'open' before trying to write to file.");
            }
            //#endif

            if(n_bits_to_write > 64)
            {
                n_bits_to_write = 64;
            }

            const uint64 mask = 255;

            if(n_bits_to_write)
            {
                if(n_bits_to_write < _space)
                {
                    _buffer = _buffer | ((uint8)(to_write << (_space-n_bits_to_write) ));
                    _space = _space - n_bits_to_write;
                }
                else if (n_bits_to_write == _space)
                {
                    _buffer = _buffer | ((uint8) to_write);
                    _fp.write((char*)&_buffer, 1);
                    _buffer = 0;
                    _space = 8;
                }
                else
                {
                    uint8 shift = n_bits_to_write-_space;

                    _buffer = _buffer | ((uint8)(to_write >> shift));
                    _fp.write((char*)&_buffer, 1);

                    while(shift>8)
                    {
                        shift = shift-8;
                        _buffer = (uint8)( (to_write & (mask << shift)) >> shift);
                        _fp.write((char*)&_buffer, 1);
                    }

                    if (shift == 8)
                    {
                        _buffer = (uint8)(to_write);
                        _fp.write((char*)&_buffer, 1);
                        _buffer = 0;
                        _space = 8;
                    }
                    else
                    {
                        _buffer = (uint8)(to_write << (8-shift) );
                        _space = 8-shift;
                    }
                }
            }
        }

        void force_write( )
        {
            // Write the remanining bits (padded with 0s)
            if (_space < 8)
            {
                _fp.write((char*)&_buffer, 1);
                _buffer = 0;
                _space = 8;
            }
        }
        
    private:
        std::string _filename;
        std::ofstream _fp;
        uint8 _buffer;
        uint8 _space;
};


void _code_length(const uint8& length, uint64& to_write, uint8& n_bits_to_write)
{
	switch (length)
	{
		case 1:
			to_write = 0; //000
			n_bits_to_write = 3;        					
		break;
		case 2:
			to_write = 1; //001
			n_bits_to_write = 3;
		break;
		case 3:
			to_write = 2; //010
			n_bits_to_write = 3;
		break;
		case 4:
			to_write = 3; //011
			n_bits_to_write = 3;
		break;
		default:  // >4
			to_write = (uint64)256+(uint64)length; //1 + 8 bits length
			n_bits_to_write = 9;
	}
}

void mexFunction( int nlhs,       mxArray *plhs[], 
		          int nrhs, const mxArray *prhs[] )
{ 
    char* filename;
    uint32* input;

    /* Check for proper number of arguments */    
    if (nrhs < 2) { 
	mexErrMsgTxt("Two input arguments required."); 
    } else if (nlhs > 0) {
	mexErrMsgTxt("Too many output arguments."); 
    } 
  
    /* Check input is uint32 */
    if (!mxIsClass(PART,"uint32"))
        mexErrMsgTxt("Input partition must be UINT32.");
    
    filename = mxArrayToString(FILE);    
  
    // Open file to write
    std::ofstream fp (filename, std::ios::out | std::ios::binary);
    if (!fp.is_open())
    {
        mexErrMsgTxt("File not found.");
    }

    // Write magic number to start of file
    fp.write((char*)&MULT_MAGIC_NUMBER,sizeof(MULT_MAGIC_NUMBER));
    if (!fp.good())
    {
        mexErrMsgTxt("Cannot write magic number into file");
    }

    // Write filetype
    fp.write((char*)&MULT_FILETYPE,sizeof(MULT_FILETYPE));
    if (!fp.good())
    {
        mexErrMsgTxt("Cannot write filetype into file");
    }

    uint8 c = 1; // PARTITION_RUNLENGTH
    fp.write((char*)&c,sizeof(c));
    if (!fp.good())
    {
        mexErrMsgTxt("Cannot write compress type into file");
    }

    input = (uint32*)mxGetPr(PART);    	
    
    // Width of the part
   	uint32 width = mxGetN(PART);
  	uint32 height = mxGetM(PART);
    
    // Write datatype
    c = (uint8)UINT32;
    fp.write((char*)&c,sizeof(c));
    
    // Write number of dimensions
    uint64 d = 2;
    fp.write((char*)&d,sizeof(uint64));

    // Write size of each dimension
    d = width;
    fp.write((char*)&d,sizeof(uint64));
    d = height;
    fp.write((char*)&d,sizeof(uint64));
    
    // Compute the maximum value
    uint32 num_elements = width*height;
    uint32 max_value = 0;
    const uint32 *temp = input;
    for(uint64 ii=0; ii<num_elements; ii++)
    {
        if(*temp>max_value) max_value = *temp;
        temp++;
    }
    
   	// Compute the number of bits needed
   	const uint8 num_bits = (uint8)ceil(log((float)(max_value+1))/log(2.));

    // Write the number of bits used
    fp.write((char*)&num_bits, 1);

    uint32 current_label=*input;
    uint32 max_label = current_label;

    uint8  current_length = 0;
    uint8  n_bits_to_write;
    uint64 to_write;

    fp.close();

    WriteBitStream wbs(filename, APPEND);

    // Write first label
    to_write = (uint64)(((uint64)7)<<num_bits)+(uint64)current_label; // 111 + N bits label
    n_bits_to_write = num_bits+3;
    wbs.write(to_write, n_bits_to_write);  		
 
    for(std::size_t yy=0; yy<height; ++yy)
    {
        for(std::size_t xx=0; xx<width; ++xx)
        {
            std::size_t curr_idx = xx*height + yy; // Matlab scans the other way around
            if(input[curr_idx]==current_label && current_length < 255)
            {
                current_length++;
            }
            else
            {
                // Length casuistry
                _code_length(current_length, to_write, n_bits_to_write);

                // Write length
                wbs.write(to_write, n_bits_to_write);

                // New label
                current_label = input[curr_idx];
                current_length = 1;

                if (yy>0) //We are not in the first row
                {
                    // Label casuistry:
                    // 	"Up" value           -->  0
                    // 	"Up-one-right" value -->  10
                    // 	"Max label" +1       -->  110
                    //  "Label directly"     -->  111 (+ N bits of label)
                    uint32 ref_label1 = input[xx*height + yy - 1];
                    uint8 num_changes = 0;
                    bool found = false;
                    uint32 offset = 0;

                    do
                    {
                        uint32 ref_label2 = ref_label1;
                        ref_label1 = input[(xx+offset)*height + yy - 1];

                        if(ref_label1 != ref_label2)
                            num_changes++;

                        if(ref_label1 == current_label)
                            found = true;

                        offset++;
                    }
                    while(num_changes<1 && ((xx+offset)<width) && !found);

                    if (found)
                    {
                        switch (num_changes)
                        {
                            case 0:
                            {
                                to_write = 0; //0
                                n_bits_to_write = 1;
                            }
                            break;
                            case 1:
                            {
                                to_write = 2; //10
                                n_bits_to_write = 2;
                            }
                            break;
                            default: // We shouldn't get here...
                                mexErrMsgTxt("Looking for current_label in the upper row, but something went wrong");  
                            break;
                        }
                    }
                    else
                    {
                        if ((current_label-max_label)==1)
                        {
                            to_write = 6; //110
                            n_bits_to_write = 3;
                        }
                        else
                        {
                            to_write = (uint64)(((uint64)7)<<num_bits)+(uint64)current_label; // 111 + N bits label
                            n_bits_to_write = num_bits+3;
                        }
                    }
                }
                else // We are in the first row, we have no "up" reference
                {
                    if ((current_label-max_label)==1)
                    {
                        to_write = 6; //110
                        n_bits_to_write = 3;
                    }
                    else
                    {
                        to_write = (uint64)(((uint64)7)<<num_bits)+(uint64)current_label; // 111 + N bits label
                        n_bits_to_write = num_bits+3;
                    }
                }

                // Write label
                wbs.write(to_write, n_bits_to_write);

                // Update max_label
                if(max_label<current_label)
                {
                    max_label = current_label;
                }
            }
        }
    }

    // Write last length
    _code_length(current_length, to_write, n_bits_to_write);

    // Actually write it
    wbs.write(to_write, n_bits_to_write);
    wbs.force_write();

    // Close the bitstream
    wbs.close();
    

    
    return;
}


