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
#ifndef IMAGEPLUS_FOP_HPP
#define IMAGEPLUS_FOP_HPP

#include <map>
#include <misc/mex_helpers.hpp>
#include <misc/intersection_matrix.hpp>

/*! Constants identifying each type of intances classification of the ObjectsAndPartsF measures.
 *
 *  \author Jordi Pont Tuset <jordi.pont@upc.edu>
 */
enum RegionClassificationTypes
{
    NOT_CLASSIFIED,
    OBJECT,
    PART
};


/*!
 *  F-measure for objects and parts, as presented in:
 *
 *  J.Pont-Tuset, F.Marques,
 *  "Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation"
 *  CVPR 2013.
 *
 *  \author Jordi Pont Tuset <jordi.pont@upc.edu>
 */
class ObjectsAndPartsF
{
    //! Resulting Precision
    double                 _precision;
    //! Resulting Recall
    double                 _recall;
    //! Resulting F
    double                 _f_measure;

    //! Threshold for a region to be classified as object
    double                 _gamma_obj;
    //! Threshold for a region to be classified as part
    double                 _gamma_part;
    //! Weight given to parts
    double                 _beta;
public:

    /*! Default constructor
     *
     *  \author Jordi Pont Tuset <jordi.pont@upc.edu>
     */
    ObjectsAndPartsF(): _precision(), _recall(), _f_measure(), _gamma_obj(0.9), _gamma_part(0.25), _beta(0.1)
    {
    }

    /*! Constructor for a non-default gamma and thresholds
     *
     *  \author Jordi Pont Tuset <jordi.pont@upc.edu>
     */
    ObjectsAndPartsF(double gamma_object, double gamma_part, double beta)
       : _precision(), _recall(), _f_measure(), _gamma_obj(gamma_object), _gamma_part(gamma_part), _beta(beta)
    {
    }


    /*!
     *  \author Jordi Pont Tuset <jordi.pont@upc.edu>
     *
     *  \param[in] intersect_matrix : Intersection matrices between the partition and the set of GT partitions
     */
    void calculate(const std::vector<inters_type>& intersect_matrices);

    /*!
     * ObjectsAndParts precision
     *
     * \return ObjectsAndParts precision
     */
    double precision()
    {
        return _precision;
    }

    /*!
     * ObjectsAndParts recall
     *
     * \return ObjectsAndParts recall
     */
    double recall()
    {
        return _recall;
    }


    /*!
     * ObjectsAndParts F measure
     *
     * \return ObjectsAndParts F measure
     */
    double f_measure()
    {
        return _f_measure;
    }


//     /*!
//      *
//      * \return Classified partition
//      */
//     template<typename T>
//     ImagePartition<T> classified_part(const ImagePartition<T>& partition) const
//     {
//         ImagePartition<T> rel_part(partition.size_x(),partition.size_y());
//         ImagePartition<T> class_part(partition.size_x(),partition.size_y());
//         part_bimap foo;
//         relabel(partition,rel_part,foo,(uint32)0);
// 
//         for(std::size_t ii=0; ii<partition.size_x(); ii++)
//         {
//             for(std::size_t jj=0; jj<partition.size_y(); jj++)
//             {
//                 class_part[ii][jj] = (T)_classification_part[rel_part[ii][jj]];
//             }
//         }
//         return class_part;
//     }
// 
//     /*!
//      *
//      * \return Classified ground_truth
//      */
//     template<typename T>
//     ImagePartition<T> classified_gt(const ImagePartition<T>& gt) const
//     {
//         ImagePartition<T> rel_gt(gt.size_x(),gt.size_y());
//         ImagePartition<T> class_gt(gt.size_x(),gt.size_y());
//         part_bimap foo;
//         relabel(gt,rel_gt,foo,(uint32)0);
// 
//         for(std::size_t ii=0; ii<gt.size_x(); ii++)
//         {
//             for(std::size_t jj=0; jj<gt.size_y(); jj++)
//             {
//                 class_gt[ii][jj] = (T)_classification_gt[0][rel_gt[ii][jj]];
//             }
//         }
//         return class_gt;
//     }

private:

    //! Clears everything
    void _clear()
    {
        _classification_gt.resize(0);
        _classification_part.resize(0);
        _mapping_gt.resize(0);
        _mapping_part.clear();
        _candidate_part.resize(0);
        _candidate_gt.resize(0);
    }

    //! Area percentile considered
    double _area_percentile;
    //! Map between each region index in scanning order of partition and its RegionClassificationTypes
    std::vector<RegionClassificationTypes>                _classification_part;
    //! Map between each region index in scanning order of ground_truth and its RegionClassificationTypes
    std::vector<std::vector<RegionClassificationTypes> >    _classification_gt;
    //! Mapping between the regions in partition to those in ground_truth
    std::map<uint32,uint32>                         _mapping_part;
    //! Mapping between the regions in ground_truth to those in partition
    std::vector<std::map<uint32,uint32> >             _mapping_gt;
    //! Is each region in the partition a candidate?
    std::vector<unsigned char>                            _candidate_part;
    //! Is each region in the GT a candidate?
    std::vector<std::vector<unsigned char>>                _candidate_gt;
    //! Degree of fragmentation for GT regions
    std::vector<std::vector<double>>                 _recall_gt;
    //! Degree of fragmentation for partition regions
    std::vector<double>                               _prec_part;

    //! Number of candidates in partition
    uint32 num_candidates_part;
    //! Number of candidates in GT
    uint32 num_candidates_gt;
    //! Number of objects in the partition
    uint32 num_objects_part;
    //! Number of objects in the GT
    uint32 num_objects_gt;
    //! Number of parts in the partition
    uint32 num_parts_part;
    //! Number of parts in the GT
    uint32 num_parts_gt;
    //! Degree of fragmentation in partition
    double num_underseg_part;
    //! Degree of fragmentation in GT
    double num_overseg_gt;
};




void ObjectsAndPartsF::calculate(const std::vector<inters_type>& intersect_matrices)
{
    _clear();
    _area_percentile = 0.99;
    uint32 num_reg_part = intersect_matrices[0].cols();
    std::size_t n_gts = intersect_matrices.size();
    _classification_part.resize(num_reg_part); // Allocate
    _prec_part.resize(num_reg_part); // Allocate
    _classification_gt.resize(n_gts); // Allocate
    _mapping_gt.resize(n_gts); // Allocate
    _recall_gt.resize(n_gts); // Allocate


    std::vector<uint64> region_areas_part(num_reg_part);
    std::vector<std::vector<uint64>> region_areas_gt(n_gts);
    std::vector<uint32> num_reg_gt(n_gts);
    uint64 image_area=0;

    // Get areas and intersections
    for(std::size_t part_id=0; part_id<n_gts; ++part_id)
    {
        num_reg_gt[part_id]  = intersect_matrices[part_id].rows();

        _classification_gt[part_id].resize(num_reg_gt[part_id]); // Allocate
        _recall_gt[part_id].resize(num_reg_gt[part_id]); // Allocate

        region_areas_gt[part_id] = std::vector<uint64>(num_reg_gt[part_id],0); // Allocate

        // Compute region and image areas
        if(part_id==0)
        {
            for(std::size_t ii=0; ii<num_reg_gt[part_id]; ii++)
            {
                for(std::size_t jj=0; jj<num_reg_part; jj++)
                {
                    image_area += intersect_matrices[part_id](part_id,ii);
                    region_areas_part[jj] = region_areas_part[jj] + intersect_matrices[part_id](jj,ii);
                    region_areas_gt[part_id][ii]   = region_areas_gt[part_id][ii]   + intersect_matrices[part_id](jj,ii);
                }
            }
        }
        else
        {
            for(std::size_t ii=0; ii<num_reg_gt[part_id]; ii++)
            {
                for(std::size_t jj=0; jj<num_reg_part; jj++)
                {
                    region_areas_gt[part_id][ii]   = region_areas_gt[part_id][ii]   + intersect_matrices[part_id](jj,ii);
                }
            }
        }
    }

    /* Get candidates in the partition (remove percentile of small area) */
    _candidate_part.resize(num_reg_part);
    std::multimap<double, uint32> area_map; // Mapping between each region area and its id
    for(std::size_t ii=0; ii<num_reg_part; ++ii)
    {
        area_map.insert(std::pair<double, uint32>(((double)region_areas_part[ii])/((double)image_area),ii));
    }
    double curr_pct = 0;
    for(std::multimap<double, uint32>::const_reverse_iterator rit = area_map.rbegin(); rit != area_map.rend(); ++rit)
    {
        if(curr_pct<_area_percentile)
            _candidate_part[rit->second] = 1;
        else
            _candidate_part[rit->second] = 0;

        curr_pct += rit->first;
    }

    /* Get candidates in the ground truth (remove percentile of small area) */
    _candidate_gt.resize(n_gts);
    for(std::size_t part_id=0; part_id<n_gts; ++part_id)
    {
        _candidate_gt[part_id].resize(num_reg_gt[part_id]);
        area_map.clear();
        for(std::size_t ii=0; ii<num_reg_gt[part_id]; ++ii)
        {
            area_map.insert(std::pair<double, uint32>(((double)region_areas_gt[part_id][ii])/((double)image_area),ii));
        }
        curr_pct = 0;
        for(std::multimap<double, uint32>::const_reverse_iterator rit = area_map.rbegin(); rit != area_map.rend(); ++rit)
        {
            if(curr_pct<_area_percentile)
                _candidate_gt[part_id][rit->second] = 1;
            else
                _candidate_gt[part_id][rit->second] = 0;

            curr_pct += rit->first;
        }
    }


    /* Scan intersection table */
    for(std::size_t part_id=0; part_id<n_gts; ++part_id)
    {
        /* Scan through table and find all OBJECT mappings */
        for(uint32 ii=0; ii<num_reg_gt[part_id]; ii++)
        {
            for(uint32 jj=0; jj<num_reg_part; jj++)
            {
                double recall    = (double)intersect_matrices[part_id](jj,ii)/(double)region_areas_gt[part_id][ii];
                double precision = (double)intersect_matrices[part_id](jj,ii)/(double)region_areas_part[jj];
                
                /* Ignore those regions with tiny area */
                if(_candidate_gt[part_id][ii]==1 && _candidate_part[jj]==1)
                {
                    /* Is it an object candidate? */
                    if(recall >= _gamma_obj  &&  precision >= _gamma_obj)
                    {
                        _classification_gt[part_id][ii]  = OBJECT;
                        _classification_part[jj]         = OBJECT;

                        _mapping_gt[part_id][ii] = jj;
                        _mapping_part[jj]        = ii;
                    }
                    else if(recall >= _gamma_part  &&  precision >= _gamma_obj)
                    {
                        if(_classification_part[jj] == NOT_CLASSIFIED) /* Does not have a classification yet */
                        {
                            _classification_part[jj] = PART;
                            _mapping_part[jj]        = ii;
                        }
                    }
                    else if(recall >= _gamma_obj  &&  precision >= _gamma_part)
                    {
                        /* Cannot have a classification already */
                        _classification_gt[part_id][ii] = PART;
                        _mapping_gt[part_id][ii] = jj;
                    }
                }

                // Get _recall_gt and _prec_part (no matter if candidates or not),
                //  discarding objects
                if(precision >= _gamma_obj && recall < _gamma_obj)
                    _recall_gt[part_id][ii] += recall;
                else if (recall >= _gamma_obj && precision < _gamma_obj)
                    _prec_part[jj] += precision;
            }
        }
    }

    // Count everything
    num_objects_part = 0;
    num_objects_gt = 0;
    num_parts_part = 0;
    num_parts_gt = 0;
    num_underseg_part = 0;
    num_overseg_gt = 0;
    num_candidates_part = 0;
    num_candidates_gt = 0;

    for(uint32 jj=0; jj<num_reg_part; jj++)
    {
        num_candidates_part += _candidate_part[jj];

        if(_classification_part[jj]==PART)
            num_parts_part++;
        else if(_classification_part[jj]==OBJECT)
            num_objects_part++;
        else if (_candidate_part[jj])// Compute degree of undersegmentation
            num_underseg_part += _prec_part[jj];
    }
    num_underseg_part = num_underseg_part/(double)n_gts;
    for(std::size_t part_id=0; part_id<n_gts; ++part_id)
    {
        for(uint32 ii=0; ii<num_reg_gt[part_id]; ii++)
        {
            num_candidates_gt += _candidate_gt[part_id][ii];
            if(_classification_gt[part_id][ii]==PART)
                num_parts_gt++;
            else if(_classification_gt[part_id][ii]==OBJECT)
                num_objects_gt++;
            else if(_candidate_gt[part_id][ii])// Compute degree of oversegmentation
                num_overseg_gt += _recall_gt[part_id][ii];
        }
    }

    // Precision and recall
    _precision = (num_objects_part + num_underseg_part + _beta*num_parts_part)/num_candidates_part;
    _recall    = (num_objects_gt   + num_overseg_gt    + _beta*num_parts_gt  )/num_candidates_gt;

    // F-measure for Region Detection
    if(_precision==0 && _recall==0)
        _f_measure = 0;
    else
        _f_measure = 2*_precision*_recall/(_precision+_recall);
}

#endif