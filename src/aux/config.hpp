// ------------------------------------------------------------------------ 
//  Copyright (C)
//  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
//
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

//!
//! \defgroup DebugMacros Debug Macros 
//!
//!
//!  Macro definitions
//!
//!  - IMAGEPLUS_INLINE: Usefull when debuging inline procedures and functions. 
//!                      Use IMAGEPLUS_INLINE instead of inline.
//!
//!  - TRACE: Usefull for the debug traces. 
//!           Use TRACE(message) instead of cout or cerr.
//!
//!  - ASSERT: Useful for checking basic conditions in debug mode.
//!            It checks the condition and send an exception with the message.
//!
#ifndef IMAGEPLUS_CONFIG_HPP
#define IMAGEPLUS_CONFIG_HPP

#ifdef DOXYGEN_DOC

//!
//! Usefull when debuging inline procedures and functions. 
//! Use IMAGEPLUS_INLINE instead of inline.
//! \ingroup DebugMacros
//!
#define IMAGEPLUS_INLINE

//! Macro to print out debug traces. 
//! It only prints the trace in debug mode and with the _TRACE flag defined.
//! See the user.build file to learn how to add or remove the traces of your modules.
//! \ingroup DebugMacros
#define TRACE(message)


//! \def ASSERT(condition, message)
//! Macro to check basic conditions.
//! This macro should be used to check basic conditions that always should be true.
//! The condition is only checked in debug mode, an a exception with the message is throw if false.
//! In release mode ASSERT does nothing for performance reasons.
//! \ingroup DebugMacros
#define ASSERT(condition, message)


#else


// Definition of the TRACE macro
#ifndef NDEBUG
    #ifdef _TRACE
        #include <ostream>
        #define TRACE(message) { std::cerr << __FILE__ << ":" << __LINE__ << " " << message << std::endl; }
    #endif
#endif
#ifndef TRACE
    #define TRACE(message)
#endif




#ifdef NDEBUG /* Release Mode */

	#ifndef IMAGEPLUS_INLINE
		#define IMAGEPLUS_INLINE inline
	#endif

	#ifndef ASSERT
		#define ASSERT(condition, message) //Look the MSVC variadic macro definition to avoid problems with ASSERT(f)
	#endif
	
#else /* Debug Mode */
	
	#ifndef IMAGEPLUS_INLINE
		#define IMAGEPLUS_INLINE
	#endif

	#ifndef ASSERT
		#include <sstream>
		#define ASSERT(condition, message) 									  \
				{ 						               						  \
					if(!(condition))    									  \
					{ 														  \
						std::stringstream ss; 								  \
						ss << __FILE__ << ":" << __LINE__ << " " << message;  \
						throw imageplus::ImagePlusInternalError(ss.str());    \
					}                                                         \
				}
	#endif
#endif

#endif //DOXYGEN_DOC
#endif
