// --------------------------------------------------------------
// Copyright (C)
// Universitat Politecnica de Catalunya (UPC) - Barcelona - Spain
// --------------------------------------------------------------
//
// Copyright (C) 2004      Yefeng Zheng
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You are free to use this program for non-commercial purpose.
// If you plan to use this code in commercial applications,
// you need additional licensing:
// please contact zhengyf@cfar.umd.edu
// --------------------------------------------------------------
//
// version 1.0 - 4 September 1996
// author: Roy Jonker @ MagicLogic Optimization Inc.
//
//   "A Shortest Augmenting Path Algorithm for Dense and Sparse Linear
//    Assignment Problems," Computing 38, 325-340, 1987
// Main program file to run and check Jonker-Volgenant LAP code
//
// A bug was fixed by Yefeng Zheng 03/07/2004
// --------------------------------------------------------------
// Adapted to ImagePlus by Jordi Pont 09/09/2009
//*************************************************************************/


//!
//!  \file hungarian.hpp
//!
//!  \brief Implementation of the Hungarian algorithm
//!
#ifndef IMAGEPLUS_HUNGARIAN_HPP
#define IMAGEPLUS_HUNGARIAN_HPP

#include <time.h>
#include <stdlib.h>

//! Implementation of the Hungarian Algorithm for solving the assignment problem.
//! 
//! Intuitively: Assume that we have N workers and N jobs that should be done. 
//!              For each pair (worker, job) we know the salary that should be paid to the worker 
//!              for him to perform the job. 
//!              Our goal is to complete all jobs minimizing total inputs, while assigning each worker 
//!              to exactly one job and vice versa.
//!
//! Mathematically: The algorithms looks for the minimum matching of the weighted bipartite
//!                 between workers and jobs (vertices) linked by their salaries (edges).
//!
//! Please refer to: H. W. Kuhn, The Hungarian method for the assignment problem,
//!                  Naval Research Logistic Quarterly, vol. 2, pp. 83-97, 1955.
//!
//! \author Jordi Pont Tuset <jpont@gps.tsc.upc.edu>
//!
//! \date 09-09-2009
//!
//! \param[in]   costs: Cost matrix (position (i,j) is the weight of the edge between worker i and job j)
//! \param[out] rowsol: Column assigned to row in solution
//! \param[out] colsol: Row assigned to column in solution
//! \return The total cost of the assignment
float32 hungarian(const MultiArray<float32,2>& costs, std::vector<int32>& rowsol, std::vector<int32>& colsol)
{
    int32 dim = costs.dims(0);
    ASSERT(dim == (int32)costs.dims(1), "hungarian: Costs must be a square matrix");

    float32 big = std::numeric_limits<float32>::max();
    bool unassignedfound;
    int32  i, imin, numfree = 0, prvnumfree, f, i0, k, freerow;
    int32  j, j1, j2=0, endofpath=0, last=0, low, up;
    float32 min=0, h, umin, usubmin, v2;

    rowsol.resize(dim);
    colsol.resize(dim);

    std::vector<int32>    free(dim);    // list of unassigned rows.
    std::vector<int32> collist(dim);    // list of columns to be scanned in various ways.
    std::vector<int32> matches(dim);    // counts how many times a row could be assigned.
    std::vector<float32>    d(dim);    // 'cost-distance' in augmenting path calculation.
    std::vector<int32>    pred(dim);    // row-predecessor of column in augmenting/alternating path.
    std::vector<float32>    v(dim);

    // init how many times a row will be assigned in the column reduction.
    for (i = 0; i < dim; i++)
    {
        matches[i] = 0;
    }

    // COLUMN REDUCTION
    for (j = dim-1; j >= 0; j--)    // reverse order gives better results.
    {
        // find minimum cost over rows.
        min = costs[0][j];
        imin = 0;
        for (i = 1; i < dim; i++)
        {    if (costs[i][j] < min)
            {
                min = costs[i][j];
                imin = i;
            }
        }
        v[j] = min;

        if (++matches[imin] == 1)
        {
            // init assignment if minimum row assigned for first time.
            rowsol[imin] = j;
            colsol[j] = imin;
        }
        else
        {
            colsol[j] = -1;        // row already assigned, column not assigned.
        }
    }

    // REDUCTION TRANSFER
    for (i = 0; i < dim; i++)
    {
        if (matches[i] == 0)     // fill list of unassigned 'free' rows.
            free[numfree++] = i;
        else
        {
            if (matches[i] == 1)   // transfer reduction from rows that are assigned once.
            {
                j1 = rowsol[i];
                min = big;
                for (j = 0; j < dim; j++)
                    if (j != j1)
                        if (costs[i][j] - v[j] < min)
                            min = costs[i][j] - v[j];
                v[j1] = v[j1] - min;
            }
        }
    }

    // AUGMENTING ROW REDUCTION
    int loopcnt = 0;           // do-loop to be done twice.
    do
    {
        loopcnt++;
    
        // scan all free rows.
        // in some cases, a free row may be replaced with another one to be scanned next.
        k = 0;
        prvnumfree = numfree;
        numfree = 0;             // start list of rows still free after augmenting row reduction.
        while (k < prvnumfree)
        {
            i = free[k];
            k++;

            // find minimum and second minimum reduced cost over columns.
            umin = costs[i][0] - v[0];
            j1 = 0;
            usubmin = big;
            for (j = 1; j < dim; j++)
            {
                h = costs[i][j] - v[j];
                if (h < usubmin)
                {
                    if (h >= umin)
                    {
                        usubmin = h;
                        j2 = j;
                    }
                    else
                    {
                        usubmin = umin;
                        umin = h;
                        j2 = j1;
                        j1 = j;
                    }
                }
            }

            i0 = colsol[j1];

        /* Begin modification by Yefeng Zheng 03/07/2004 */
            //if( umin < usubmin )
            if (fabs(umin-usubmin) > 1e-10)
        /* End modification by Yefeng Zheng 03/07/2004 */
            {
                // change the reduction of the minimum column to increase the minimum
                // reduced cost in the row to the subminimum.
                v[j1] = v[j1] - (usubmin - umin);
            }
            else                   // minimum and subminimum equal.
            {
                if (i0 >= 0)         // minimum column j1 is assigned.
                {
                    // swap columns j1 and j2, as j2 may be unassigned.
                    j1 = j2;
                    i0 = colsol[j2];
                }
            }
            
            // (re-)assign i to j1, possibly de-assigning an i0.
            rowsol[i] = j1;
            colsol[j1] = i;

            if (i0 >= 0)           // minimum column j1 assigned earlier.
            {
/* Begin modification by Yefeng Zheng 03/07/2004 */
                //if( umin < usubmin )
                if (fabs(umin-usubmin) > 1e-10)
/* End modification by Yefeng Zheng 03/07/2004 */
                {
                    // put in current k, and go back to that k.
                    // continue augmenting path i - j1 with i0.
                    free[--k] = i0;
                }
                else
                {
                    // no further augmenting reduction possible.
                    // store i0 in list of free rows for next phase.
                    free[numfree++] = i0;
                }
            }
        }
    }
    while (loopcnt < 2);       // repeat once.

    // AUGMENT SOLUTION for each free row.
    for (f = 0; f < numfree; f++)
    {
        freerow = free[f];       // start row of augmenting path.

        // Dijkstra shortest path algorithm.
        // runs until unassigned column added to shortest path tree.
        for (j = 0; j < dim; j++)
        {
            d[j] = costs[freerow][j] - v[j];
            pred[j] = freerow;
            collist[j] = j;        // init column list.
        }

        low = 0; // columns in 0..low-1 are ready, now none.
        up = 0;  // columns in low..up-1 are to be scanned for current minimum, now none.
                 // columns in up..dim-1 are to be considered later to find new minimum,
                 // at this stage the list simply contains all columns
        unassignedfound = false;
        do
        {
            if (up == low)         // no more columns to be scanned for current minimum.
            {
                last = low - 1;

                // scan columns for up..dim-1 to find all indices for which new minimum occurs.
                // store these indices between low..up-1 (increasing up).
                min = d[collist[up++]];
                for (k = up; k < dim; k++)
                {
                    j = collist[k];
                    h = d[j];
                    if (h <= min)
                    {
                        if (h < min)     // new minimum.
                        {
                            up = low;      // restart list at index low.
                            min = h;
                        }
                        // new index with same minimum, put on undex up, and extend list.
                        collist[k] = collist[up];
                        collist[up++] = j;
                    }
                }

                // check if any of the minimum columns happens to be unassigned.
                // if so, we have an augmenting path right away.
                for (k = low; k < up; k++)
                {   
                    if (colsol[collist[k]] < 0)
                    {
                        endofpath = collist[k];
                        unassignedfound = true;
                        break;
                    }
                }
            }

            if (!unassignedfound)
            {
                // update 'distances' between freerow and all unscanned columns, via next scanned column.
                j1 = collist[low];
                low++;
                i = colsol[j1];
                h = costs[i][j1] - v[j1] - min;

                for (k = up; k < dim; k++)
                {
                    j = collist[k];
                    v2 = costs[i][j] - v[j] - h;
                    if (v2 < d[j])
                    {
                        pred[j] = i;
                        if (v2 == min)   // new column found at same minimum value
                        {
                            if (colsol[j] < 0)
                            {
                                // if unassigned, shortest augmenting path is complete.
                                endofpath = j;
                                unassignedfound = true;
                                break;
                            }
                        // else add to list to be scanned right away.
                            else
                            {
                                collist[k] = collist[up];
                                collist[up++] = j;
                            }
                        }
                        d[j] = v2;
                    }
                }
            }
        }
        while (!unassignedfound);

        // update column prices.
        for (k = 0; k <= last; k++)
        {
            j1 = collist[k];
            v[j1] = v[j1] + d[j1] - min;
        }

        // reset row and column assignments along the alternating path.
        do
        {
            i = pred[endofpath];
            colsol[endofpath] = i;
            j1 = endofpath;
            endofpath = rowsol[i];
            rowsol[i] = j1;
        }
        while (i != freerow);
    }

    // calculate optimal cost.
    float32 lapcost = 0;
    for (i = 0; i < dim; i++)
    {
        j = rowsol[i];
        lapcost = lapcost + costs[i][j];
    }

    return lapcost;
}
            
            
//! Implementation of the Hungarian Algorithm for solving the assignment problem.
//! 
//! Intuitively: Assume that we have N workers and N jobs that should be done. 
//!              For each pair (worker, job) we know the salary that should be paid to the worker 
//!              for him to perform the job. 
//!              Our goal is to complete all jobs minimizing total inputs, while assigning each worker 
//!              to exactly one job and vice versa.
//!
//! Mathematically: The algorithms looks for the minimum matching of the weighted bipartite
//!                 between workers and jobs (vertices) linked by their salaries (edges).
//!
//! Please refer to: H. W. Kuhn, The Hungarian method for the assignment problem,
//!                  Naval Research Logistic Quarterly, vol. 2, pp. 83-97, 1955.
//!
//! \author Jordi Pont Tuset <jpont@gps.tsc.upc.edu>
//!
//! \date 09-09-2009
//!
//! \param[in]   costs: Cost matrix (position (i,j) is the weight of the edge between worker i and job j)
//! \return The total cost of the assignment
float32 hungarian(const MultiArray<float32,2>& costs)
{
    std::vector<int32> row;
    std::vector<int32> col;
    return hungarian(costs, row, col);
}

#endif