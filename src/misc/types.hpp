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
#ifndef IMAGEPLUS_TYPES_HPP
#define IMAGEPLUS_TYPES_HPP

#include <boost/bimap.hpp>
#include <boost/bimap/multiset_of.hpp>
#include <boost/bimap/list_of.hpp>

//! Unsigned 8 bits integer
typedef unsigned char         uint8;

//! Signed 8 bits integer  
typedef char                  int8;

//! Unsigned 16 bits integer
typedef unsigned short        uint16;

//! Signed 16 bits integer  
typedef short int             int16;

//! Unsigned 32 bits integer 
typedef unsigned int          uint32;

//! Signed 32 bits integer   
typedef int                   int32;

//! Unsigned 64 bits integer 
typedef unsigned long long    uint64;

//! Signed 64 bits integer   
typedef long long             int64;

//! Signed 32 bits float     
typedef float                 float32;

//! Signed 64 bits float     
typedef double                float64;

//! Type for size and dims variables \ingroup ImagePlusTypes
typedef uint64                size_type;

//! Boost bidirectional map to create a LUT
//! See http://www.boost.org/doc/libs/1_35_0/libs/bimap/doc/html/boost_bimap/one_minute_tutorial.html
typedef boost::bimaps::bimap<
        boost::bimaps::multiset_of< uint32, std::less<uint32> >,
        boost::bimaps::multiset_of< uint32, std::less<uint32> >
    > part_bimap;

//! Alias for the largest floating point type in current architecture. Use only to safely contain data before type conversions in some templated functions.
//! Do not use this type if not absolutely necessary. 
//! \ingroup ImagePlusTypes
typedef long double                largest_float;

//! Alias for the largest integer type in current architecture. Use only to safely contain data before type conversions in some templated functions. 
//! In the following example, a function to round to nearest integer uses largest_integer before converting to return type
//!
//! \code
//! template<typename T1, typename T2>
//! IMAGEPLUS_INLINE
//! T1 mnint (T2 inval)
//! {
//!     largest_integer outval = (inval < 0) ? static_cast<largest_integer>(inval-0.5) : static_cast<largest_integer>(inval+0.5);
//!    
//!     ASSERT (outval <= std::numeric_limits<T1>::max(), "Conversion causes data loss");
//!     ASSERT (outval >= std::numeric_limits<T1>::min(), "Conversion causes data loss");
//!
//!     return (static_cast<T1>(outval));
//! }
//! \endcode
//! Do not use this type if not absolutely necessary
//! \ingroup ImagePlusTypes
typedef long long int              largest_integer;

#endif