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
//!  \file multiarray.hpp
//!
//!  Interface for the MultiArray class, base class for all 1D, 2D, 3D and ND arrays in ImagePlus
//!

#ifndef IMAGEPLUS_MULTIARRAY_HPP
#define IMAGEPLUS_MULTIARRAY_HPP

#include <iostream>
#include <vector>

#include <boost/multi_array.hpp>
#include <boost/numeric/ublas/vector.hpp>
#include <boost/numeric/ublas/matrix.hpp>
#include <boost/array.hpp>

#include <aux/config.hpp>
#include <aux/types.hpp>



/*!
 * 
 * \cond SKIP_DOC
 * 
 * AGIL: This class is still under construction
 * 
 */
class DataIndex
{
    typedef std::size_t index_type;

    index_type _index;
public:
    DataIndex()
        : _index(0)
    {   
    }

    DataIndex(index_type init)
        : _index(init)
    {   
    }

    index_type& operator()()
    {
        return _index;
    }

    const index_type& operator()() const
    {
        return _index;
    }


    friend
    bool operator==(DataIndex idx1, DataIndex idx2)
    {
        return idx1() == idx2();
    }

    friend
    std::ostream& operator<<(std::ostream& os, const DataIndex& m)
    {
        os << m();
        return os;
    }

};
/*!
 * \endcond
 */

    
//!
//! \brief base class to all multi-dimensional arrays
//!
//! This class is based on the <A HREF="http://www.boost.org/libs/multi_array/doc/index.html">boost:multi_array</A> class.
//! It is used to store data as a vector, matrix, volume, etc. The generic classes ImaVol,Image,Volume, etc. use internally
//! this class to store its pixels/voxels
//!
//! Template T is the type of the data \n
//! Template D is the number of dimensions (1 for vectors, 2 for images, 3 for volumes, etc.)
//!
//! A declaration should look like this:
//! \code
//!   MultiArray<float64,2> a(3,3);
//! \endcode
//!
//! This creates a 2D array of float64 values with size 3x3.
//! Note that you can only use the 2 argument constructor with
//! a MultiArray of 2 dimensions, for 3 dimensions use the 3 argument constructor, etc.
//!
//! The access of data can be done in two different ways, using the [] operator:
//! \code
//!    a[1][0] = 0.0; // Access to data (x=1,y=0)
//! \endcode
//!
//! or using pointers:
//! \code
//!    a.data()[3] = 0.0;
//! \endcode
//!
//! This last function data() is inherited from boost:multi_array and returns a pointer to
//! the start of the data. The data in a MultiArray is always contiguous and is stored
//! in Fortran order (column-major order). This means that first dimensions are stored first in the storage array.
//! So, for instance, a 2D MultiArray has values stored by rows
//! starting in the top-left side and finishing in the bottom-right (with the origins on the top-left of the matrix).
//! For 3D MultiArrays data is stored  first by rows, columns and then depth (so first you have all data with z=0 then z=1, etc.).
//! The following code visits a MultiArray a of 3 dimensions in the same order:
//!
//! \code
//!       MultiArray<float64,3> a(2,4,5);
//!       for (uint64 z = 0; z < a.dims(2); z++)
//!           for (uint64 y = 0; y < a.dims(1); y++)
//!               for (uint64 x = 0; x < a.dims(0); x++)
//!                   a[x][y][z] = 0.0;
//!
//!       for (uint64 p = 0; p < a.num_elements(); p++) {
//!           a.data()[p] = 0.0;
//! \endcode
//!
//! You can initialize an entire MultiArray like this:
//! \code
//! a = 0;
//! \endcode
//!
//! For speed considerations.
//! Do not use the function num_elements() inside
//! the "for loop" to set the final loop value, it is faster to copy it to a variable an use that instead.
//! When accessing the MultiArray with the [] operator remember to *always* do the loops starting from the
//! last dimension and moving to the first dimension (such as the example above), otherwise your loop will be slower.
//!
//! \todo agil: this class needs a complete review
//!
//! \author Javier Ruiz Hidalgo <j.ruiz@upc.edu>
//! \date 10-1-2008
//!
template<typename T, std::size_t D>
class MultiArray : public boost::multi_array<T,D>
{
    public:

        //! typedef for base class
        typedef boost::multi_array<T,D> multi_array_base;

        //! typedef for MultiArray view
        typedef boost::detail::multi_array::multi_array_view<T,D> view;

        //! typedef for MultiArray const view
        typedef boost::detail::multi_array::const_multi_array_view<T,D> const_view;

        typedef T data_type;                     //!< The data type of the MultiArray.
        static const std::size_t channels  =  1; //!< Used in Histogram classes. A MultiArray can be interpreted as an ImaVol of 1 channel
        static const std::size_t dimensions = D; //!< The dimensions of the MultiArray.


        //!
        //! \brief Default constructor, creates an empty MultiArray
        //!
        MultiArray();

        //!
        //! \brief Extents constructor, creates a multiarray with dimensions specified
        //!
        //! \param[in] sizes : A vector or array (template) with D values, each values specifies the size of the dimensions
        //!                    so if sizes = {1,2,3}; then it creates a 3D MultiArray with size 1x2x3
        //!
        template <typename ExtentList>
        IMAGEPLUS_INLINE 
        explicit 
        MultiArray(const ExtentList& sizes) : multi_array_base(sizes,boost::fortran_storage_order())
        {
        }

        //!
        //! \brief Constructor for boost::multi_array
        //!
        //! \param[in] ma : boost::multi_array to use as reference, size and data will be copied
        //!
        explicit 
        MultiArray(const multi_array_base& ma);

#ifdef MSVC
        //!
        //! \brief Copy constructor
        //!
        //! \param[in] ma : boost::multi_array to use as reference, size and data will be copied
        //!
        MultiArray(const MultiArray & ma)
            : multi_array_base((const multi_array_base&) ma)
        {
        }
//            //!
//            //! \brief Extents constructor
//            //!
//            template <typename ExtentList>
//            IMAGEPLUS_INLINE 
//            explicit 
//            MultiArray(const ExtentList& sizes) : multi_array_base(sizes, boost::fortran_storage_order())
//            {
//            	
//            }
#endif

        //!
        //! \brief Constructor for n dimensions using a uint64[n] array
        //!
        //! \param[in] sizes : A vector or array (template) with D values, each values specifies the size of the dimensions.
        //!                    this way you can initialize a MultiArray having {10,...,10} as argument
        //!
        MultiArray( uint64 sizes[D] );

        //!
        //! \brief Constructor for 2 dimensions
        //!
        //! \param[in] width  : X size of the MultiArray
        //! \param[in] height : Y size of the MultiArray
        //!
        MultiArray( uint64 width, uint64 height );

        //!
        //! \brief Constructor for 3 dimensions
        //!
        //! \param[in] width  : X size of the MultiArray
        //! \param[in] height : Y size of the MultiArray
        //! \param[in] depth  : Z size of the MultiArray
        //!
        MultiArray( uint64 width, uint64 height, uint64 depth );

        //!
        //! \brief Constructor for 1 dimension
        //!
        //! This needs to have all types otherwise the default constructor is not specialized
        //! The reason for this mess is than the extents constructs uses a template therefore
        //! constructors with one parameter are called through it.
        //! Now you also need to call various types just in case the normal ImagePlus user
        //! decides to use a variable for the constructor
        //!
        //! \param[in] length: length of the 1 dimensional array
        //!
        explicit MultiArray( int16 length );

        //!
        //! \brief Constructor for 1 dimension
        //!
        //! \param[in] length: length of the 1 dimensional array
        //!
        explicit MultiArray( uint16 length );

        //!
        //! \brief Constructor for 1 dimension
        //!
        //! \param[in] length: length of the 1 dimensional array
        //!
        explicit MultiArray( int32 length );

        //!
        //! \brief Constructor for 1 dimension
        //!
        //! \param[in] length: length of the 1 dimensional array
        //!
        explicit MultiArray( uint32 length );

        //!
        //! \brief Constructor for 1 dimension
        //!
        //! \param[in] length: length of the 1 dimensional array
        //!
        explicit MultiArray( int64 length );

        //!
        //! \brief Constructor for 1 dimension
        //!
        //! \param[in] length: length of the 1 dimensional array
        //!
        explicit MultiArray( uint64 length );

        //!
        //! \brief Constructor for ublas matrices
        //!
        //! \param[in] u: ublas matrix (size and data will be copied)
        //!
        //! This constructor is created to easy the adaptor with ublas matrices
        //! so you can directly return ublas matrices in functions. This constructor
        //! should only be used in the numeric module.
        //!
        MultiArray(const boost::numeric::ublas::matrix<T>& u);

        //!
        //! \brief Constructor for ublas vectors
        //!
        //! \param[in] u: ublas vector (size and data will be copied)
        //!
        //! This constructor is created to easy the adaptor with ublas vectors
        //! so you can directly return ublas vectors in functions. This constructor
        //! should only be used in the numeric module.
        //!
        MultiArray(const boost::numeric::ublas::vector<T>& u);

        //!
        //! \brief Constructor for boost:multi_array views
        //!
        //! \param[in] v: boost::multi_array view (size and data will be copied)
        //!
        //! This constructor is created to easy the use of boost::multi_array views
        //! so you can directly return views in functions.
        //!
        MultiArray(view& v);

        //!
        //! \brief Constructor for boost:multi_array views
        //!
        //! \param[in] v: boost::multi_array view (size and data will be copied)
        //!
        //! This constructor is created to easy the use of boost::multi_array views
        //! so you can directly return views in functions.
        //!
        MultiArray(const view& v);

        //!
        //! \brief Constructor for boost:multi_array const views
        //!
        //! \param[in] v: boost::multi_array view (size and data will be copied)
        //!
        //! This constructor is created to easy the use of boost::multi_array views
        //! so you can directly return views in functions.
        //!
        MultiArray(const const_view& v);

        // we do not need to call the destructor as we do not allocate anything
        //~MultiArray() : boost::~multi_array<T,D>() {};

        //!
        //! \brief Assignment operator for MultiArray
        //!
        //! \param[in] copy : Creates a copy (size and data)
        //!
        //! \return Reference to (this) so a = b = c; works.
        //!
        const MultiArray& operator=( const MultiArray& copy );

        //!
        //! \brief Assignment operator for boost:multi_array
        //!
        //! \param[in] copy : Creates a copy (size and data)
        //!
        //! \return Reference to (this) so a = b = c; works.
        //!
        const MultiArray& operator=( const multi_array_base& copy );

        //!
        //! \brief Assignment operator for boost:multi_array views
        //!
        //! \param[in] copy : Creates a copy (size and data)
        //!
        //! \return Reference to (this) so a = b = c; works.
        //!
        const MultiArray& operator=( const view& copy );

        //!
        //! \brief Assignment operator for boost:multi_array const views
        //!
        //! \param[in] copy : Creates a copy (size and data)
        //!
        //! \return Reference to (this) so a = b = c; works.
        //!
        const MultiArray& operator=( const const_view& copy );

        //!
        //! \brief Assigment operator for values (fills the entire MultiArray)
        //!
        //! \param[in] val : Value to fill all data
        //!
        //! \return Reference to value to a = b = 1; works
        //!
        const T& operator=( const T& val );

        //!
        //! \brief Performs comparisons between all the MultiArray data and a single value
        //!        of the same type. If a single MultiArray data differs from the value the
        //!        result is false
        //!
        //! \param[in]  d : Value to compare to
        //!
        //! \return false if a single MultiArray data differs from the value
        //!
        //! \author Javier Ruiz Hidalgo <j.ruiz@upc.edu>
        //! \date   10-1-2008
        //!
        bool operator==(T d) const;

        /*!
         * Equal comparator
         * 
         * \param[in] ma : the MultiArray to compare with
         * 
         * \return true if the MultiArray shape and elements are equals
         */
        bool operator==(const MultiArray& ma) const;

        //!
        //! \brief Performs comparisons between all the MultiArray data and a single value
        //!        of the same type. If a single MultiArray data differs from the value the
        //!        result is false
        //!
        //! \param[in]  d : Value to compare to
        //!
        //! \return true if any element of the MultiArray is different of d
        //!
        //! \author Javier Ruiz Hidalgo <j.ruiz@upc.edu>
        //! \date 10-1-2008
        //!
        bool operator!=(T d) const;

        /*!
         * Not equal comparator
         * 
         * \param[in] ma : the MultiArray to compare with
         * 
         * \return false if the MultiArray shape and elements are equals
         */
        bool operator!=(const MultiArray& ma) const;

        /*!
         * 
         * \cond SKIP_DOC
         * 
         * AGIL: New access methods to be used with iterators
         *       Still under construction. 
         * 
         */
        T& operator()(DataIndex data_index)
        {
            return this->data()[data_index()];
        }

        template< typename CoordType > 
        T& operator()(CoordType coord)
        {
            return multi_array_base::operator()(coord);
        }

        const T& operator()(DataIndex data_index) const
        {
            return this->data()[data_index()];
        }


        template< typename CoordType > 
        const T& operator()(CoordType coord) const
        {
            return multi_array_base::operator()(coord);
        }


        /*!
         * 
         * \endcond
         * 
         */

        //!
        //! \brief Assigment operator for boost::array
        //!
        //! \param[in] array : Creates a copy (size and data)
        //!
        //! \return Reference to (this) so a = b = 1; works
        //!
        //!
        template<std::size_t S>
        const MultiArray& operator=( const boost::array<T,S> & array )
        {
            std::size_t nelem = this->num_elements();

            // resize to array size if needed
            if(nelem != S)
            {
                boost::array<std::size_t, 1> shape;
                shape[0] = S;
                this->resize(shape);
            }
            //copy values
            T* d = this->data();
            for (std::size_t p = 0; p < S; p++)
            {
                *d++ = array[p];
            }

            return *this;
        }




        //!
        //! \brief Access size of dimensions of MultiArray
        //!
        //! \return Vector with D values, each value is the size of that dimension
        //!
        std::vector<size_type> dims() const;

        //!
        //! \brief Access size of specific dimension
        //!
        //! \param[in] d : dimension to get size
        //!
        //! \return The size of the dimension specified
        //!
        size_type dims(size_type d) const;

        /*!
         * \returns the size of a specific dimension
         *
         * \param[in] dim : the dimension to get its size (from 0 to D)
         *
         * \note Same as dims(size_type), added for convenience
         *
         * \author 2011-07 - Albert Gil Moreno - Added for convenience while developing Interpolator.
         *                                       To use a MultiArray as a SignalModel
         */
        size_type size(size_type dim) const
        {
            return dims(dim);
        }

        /*!
         * \returns the size of the MultiArray
         *
         * See <a href="http://www.boost.org/libs/multi_array/doc/reference.html#MultiArray">
         * the Boost.MultiArray concept </a> for further details.
         *
         * \returns boost::multi_array::size()
         *          ("a.size(): This returns the number of values contained in a. It is equivalent to a.shape()[0];")
         *
         * \author 2011-07 - Albert Gil Moreno - Added to avoid overloagind-shadow
         */
        size_type size() const
        {
            return multi_array_base::size();
        }


        //!
        //! \brief Access base of dimensions of MultiArray
        //!
        //! \return Vector with D values, each value is the base of that dimension
        //!
        boost::array<int64, D> bases() const;


    private:

        //!
        //! \brief Creates an empty vector of D values (useful for constructors of MultiArray)
        //!
        //! \return An empty vector of size D (template value of MultiArray)
        //!
        std::vector<uint64> empty_extents() const;

#if 0
        /*
        //!
        //! \brief Constructs a MultiaArray of 1 dimension and size length
        //!
        //! \param[in] length : Size of the multi_array of 1 dimension
        //!
        void constructor_for_1d( uint64 length );
        */
#endif

};

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray()
        : multi_array_base(empty_extents(),boost::fortran_storage_order())
{
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray(const multi_array_base& ma)
        : multi_array_base(ma) 
{
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( uint64 width, uint64 height )
        : multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    std::vector<uint64> shape(2);
    shape[0] = width; shape[1] = height;
    this->resize(shape);
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( uint64 sizes[D] ) 
        : multi_array_base(std::vector<uint64>(sizes, sizes+D),boost::fortran_storage_order())
{
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( uint64 width, uint64 height, uint64 depth )
        : multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    std::vector<uint64> shape(3);
    shape[0] = width; shape[1] = height; shape[2] = depth;
    this->resize(shape);
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( int16 length )
        : multi_array_base(boost::extents[length],boost::fortran_storage_order())
        //: multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    //constructor_for_1d (static_cast<uint64>(length));
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( uint16 length )
        : multi_array_base(boost::extents[length],boost::fortran_storage_order())
        //: multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    //constructor_for_1d (static_cast<uint64>(length));
}

template<typename T, std::size_t D> 
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( int32 length )
        : multi_array_base(boost::extents[length],boost::fortran_storage_order())
        //: multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    //constructor_for_1d (static_cast<uint64>(length));
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( uint32 length )
        : multi_array_base(boost::extents[length],boost::fortran_storage_order())
        //: multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    //constructor_for_1d (static_cast<uint64>(length));
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( int64 length )
        : multi_array_base(boost::extents[length],boost::fortran_storage_order())
        //: multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    //constructor_for_1d (static_cast<uint64>(length));
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
MultiArray<T,D>::MultiArray( uint64 length )
        : multi_array_base(boost::extents[length],boost::fortran_storage_order())
        //: multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    //constructor_for_1d (static_cast<uint64>(length));
}


template<typename T, std::size_t D>
MultiArray<T,D>::MultiArray(const boost::numeric::ublas::matrix<T>& u)
        : multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    // Create MultiArray of same size
    std::vector<uint64> shape(2);
    shape[0] = u.size2(); shape[1]=u.size1();
    this->resize(shape);

    // Copy data from ublas matrix
    for (uint64 y = 0; y < shape[1]; y++)
    {
        for (uint64 x = 0; x < shape[0]; x++)
        {
            (*this)[x][y] = u(y,x);
        }
    }

}

template<typename T, std::size_t D>
MultiArray<T,D>::MultiArray(const boost::numeric::ublas::vector<T>& u)
        : multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    // Create MultiArray of same size
    std::vector<uint64> shape(1);
    shape[0] = u.size();
    this->resize(shape);

    // Copy data from ublas matrix
    for (uint64 x = 0; x < shape[0]; x++)
    {
        (*this)[x] = u(x);
    }

}

template<typename T, std::size_t D>
MultiArray<T,D>::MultiArray( view& v )
        : multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    // Resize the multiarray to store all values
    std::vector<uint64> d(D);
    for (uint64 i=0;i<D;i++)
    {
        d[i] = static_cast<uint64>(v.shape()[i]);
    }
    this->resize(d);

    // Now call the copy operator of the base class (with the same dimensions) and storage order ok
    multi_array_base::operator=(v);
}

template<typename T, std::size_t D>
MultiArray<T,D>::MultiArray(const view& v)
        : multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    // Resize the multiarray to store all values
    std::vector<uint64> d(D);
    for (uint64 i=0;i<D;i++)
    {
        d[i] = static_cast<uint64>(v.shape()[i]);
    }
    this->resize(d);

    // Now call the copy operator of the base class (with the same dimensions) and storage order ok
    multi_array_base::operator=(v);
}

template<typename T, std::size_t D>
MultiArray<T,D>::MultiArray(const const_view& v)
        : multi_array_base(empty_extents(),boost::fortran_storage_order())
{
    // Resize the multiarray to store all values
    std::vector<uint64> d(D);
    for (uint64 i=0;i<D;i++)
    {
        d[i] = static_cast<uint64>(v.shape()[i]);
    }
    this->resize(d);

    // Now call the copy operator of the base class (with the same dimensions) and storage order ok
    multi_array_base::operator=(v);
}

template<typename T, std::size_t D>
IMAGEPLUS_INLINE
const MultiArray<T,D>& MultiArray<T,D>::operator=( const MultiArray<T,D>& copy )
{
    if (&copy != this)
    {
        // Check if dimensions are the same and change the current one
        for (uint32 i = 0; i < D; i++)
        {
            if ( copy.dims(i) != this->dims(i) )
            {
                this->resize(copy.dims());
                i = D;
            }
        }

        // Copy the coordinate of the first element (not necessarily (0,0))
        this->reindex(copy.bases());

        // Now call the copy operator of the base class (with the same dimensions)
        multi_array_base::operator=(copy);
    }
    return *this;
}

template<typename T, std::size_t D>
const MultiArray<T,D>& MultiArray<T,D>::operator=( const multi_array_base& copy )
{
    if (&copy != this)
    {
        // Check if dimensions are the same and change the current one
        std::vector<uint64> d(D);
        for (uint64 i=0;i<D;i++)
        {
            d[i] = static_cast<uint64>(copy.shape()[i]);
        }

        if ( d != this->dims() )
        {
            this->resize(d);
        }

        // Copy the coordinate of the first element (not necessarily (0,0))
        //this->reindex(copy.bases());

        // Now call the copy operator of the base class (with the same dimensions)
        multi_array_base::operator=(copy);
    }

    return *this;
}

template<typename T, std::size_t D>
const MultiArray<T,D>& MultiArray<T,D>::operator=( const view& copy )
{
    // Check if dimensions are the same and change the current one
    std::vector<uint64> d(D);
    for (uint64 i=0;i<D;i++)
    {
        d[i] = static_cast<uint64>(copy.shape()[i]);
    }

    if ( d != this->dims() )
    {
        this->resize(d);
    }

    // Copy the coordinate of the first element (not necessarily (0,0))
    // AGIL: "view has no member named 'bases'
    //this->reindex(copy.bases());

    // Now call the copy operator of the base class (with the same dimensions)
    multi_array_base::operator=(copy);

    return *this;
}

template<typename T, std::size_t D>
const MultiArray<T,D>& MultiArray<T,D>::operator=( const const_view& copy )
{
    // Check if dimensions are the same and change the current one
    std::vector<uint64> d(D);
    for (uint64 i=0;i<D;i++)
    {
        d[i] = static_cast<uint64>(copy.shape()[i]);
    }

    if ( d != this->dims() )
    {
        this->resize(d);
    }

    // Copy the coordinate of the first element (not necessarily (0,0))
    // AGIL: "view has no member named 'bases'
    //this->reindex(copy.bases());

    // Now call the copy operator of the base class (with the same dimensions)
    multi_array_base::operator=(copy);

    return *this;
}

template<typename T, std::size_t D>
const T& MultiArray<T,D>::operator=( const T& val )
{
    T* d = this->data();

    uint64 nelem = this->num_elements();
    for (uint64 p = 0; p < nelem; p++)
    {
        *d++ = val;
    }

    return val;
}

//    template<typename T, std::size_t D, std::size_t S>
//    const MultiArray<T,D>& MultiArray<T,D>::operator=( const boost::array<T,S> array )
//    {
//        ASSERT(D==1, "operator=(const boost::array<T,S> array) only works with  1 dimension." )
//        T* d = this->data();
//        
//        uint64 nelem = this->num_elements();
//   
//        // resize to array size if needed
//        if(nelem != S)
//        {
//            std::vector<uint64> shape(D);
//            shape[0] = S;
//            this->resize(shape);
//        }
//        //copy values
//        for (uint64 p = 0; p < S; p++)
//        {
//            *d++ = array[p];
//        }
//        
//        return *this;
//    }
//
template<typename T, std::size_t D>
bool MultiArray<T,D>::operator==(T d) const
{
    const T* d1 = this->data();
    std::size_t nelem = this->num_elements();

    for (std::size_t i = 0; i < nelem; ++i)
    {
        if (d1[i] != d) return false;
    }
    return true;
}

template<typename T, std::size_t D>
bool MultiArray<T,D>::operator==(const MultiArray& ma) const
{
    return multi_array_base::operator==(ma);
}


template<typename T, std::size_t D>
bool MultiArray<T,D>::operator!=(T d) const
{
    return ! ( (*this)==d );
}

template<typename T, std::size_t D>
bool MultiArray<T,D>::operator!=(const MultiArray& ma) const
{
    return multi_array_base::operator!=(ma);
}

template<typename T, std::size_t D>
std::vector<size_type> MultiArray<T,D>::dims() const
{
    std::vector<size_type> d(D);
    for (uint64 i=0;i<D;i++)
    {
        d[i] = static_cast<size_type>(this->shape()[i]);
    }
    return d;
}


template<typename T, std::size_t D>
boost::array<int64, D> MultiArray<T,D>::bases() const
{
    boost::array<int64, D> b;
    for (uint64 i=0;i<D;i++)
    {
        b[i] = static_cast<int64>(this->index_bases()[i]);
    }
    return b;
}


template<typename T, std::size_t D>
IMAGEPLUS_INLINE
size_type MultiArray<T,D>::dims(size_type d) const
{
    return static_cast<size_type>(this->shape()[d]);
}

template<typename T, std::size_t D>
std::vector<uint64> MultiArray<T,D>::empty_extents() const
{
    std::vector<uint64> e(D);
    for (uint64 i=0;i<D;i++)
    {
        e[i] = 0;
    }
    return e;
}

/*
template<typename T, std::size_t D>
IMAGEPLUS_INLINE
void MultiArray<T,D>::constructor_for_1d( uint64 length )
{
#ifndef NDEBUG
    if ( D != 1)
    {
        throw ImagePlusError("ERROR(MultiArray): Constructor(x) only works with 1 dimension.");
    }
#endif
    std::vector<uint64> shape(1);
    shape[0] = length;
    this->resize(shape);
}
*/


//    template<typename T, std::size_t D, std::size_t S>
//    MultiArray<T,D> & operator=(MultiArray<T,D> & in,  const boost::array<T,S> & array)
//    {
//        ASSERT(D==1, "operator=(const boost::array<T,S> array) only works with  1 dimension." )
//        T* d = in.data();
//        
//        uint64 nelem = in.num_elements();
//   
//        // resize to array size if needed
//        if(nelem != S)
//        {
//            std::vector<uint64> shape(D);
//            shape[0] = S;
//            in.resize(shape);
//        }
//        //copy values
//        for (uint64 p = 0; p < S; p++)
//        {
//            *d++ = array[p];
//        }
//        
//        return in;
//    }
//

#endif
