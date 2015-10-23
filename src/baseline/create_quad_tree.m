function [ grid_ucm, ucm ] = create_quad_tree( sx, sy )
% function [ grid_ucm, ucm ] = create_quad_tree( sx, sy )
% ------------------------------------------------------------------------ 
%  Code available at:
%  https://imatge.upc.edu/web/resources/supervised-evaluation-image-segmentation
% ------------------------------------------------------------------------
%  This file is part of the SEISM package presented in:
%    Jordi Pont-Tuset, Ferran Marques,
%    "Measures and Meta-Measures for the Supervised Evaluation of Image Segmentation,"
%    Computer Vision and Pattern Recognition (CVPR), 2013.
%  If you use this code, please consider citing the paper.
% ------------------------------------------------------------------------ 
% Create one quad tree at the needed resolution
% Maximum level of detail: 1024 regions: 32x32
%
% INPUT
%	- sx, sy   : Sizes of the image.
%
% OUTPUT
%	- grid_ucm : Ultrametric contour map in the contour grid (size 2sx+1 x 2sy+1)
%                Sometimes called ucm2.
%   - ucm      : UCM on the pixel grid (size sx, sy).

res = [sx, sy];
bounds = cell(2,5);
for ii=1:2
    tmp = floor(linspace(1,res(ii)+1,32+1));
    tmp = tmp(2:end-1);

    bounds{ii}{1} = 2*tmp-1;
    bounds{ii}{2} = bounds{ii}{1}(2:2:end-1);
    bounds{ii}{3} = bounds{ii}{2}(2:2:end-1);
    bounds{ii}{4} = bounds{ii}{3}(2:2:end-1);
    bounds{ii}{5} = bounds{ii}{4}(2:2:end-1);
end

curr_max = 1;
grid_ucm = zeros(2*res+1);
n_levels = length(bounds{1});
for ii=1:n_levels-1
    for jj=1:length(bounds{1}{ii})
        grid_ucm(bounds{1}{ii}(jj),2:1:bounds{2}{ii}) = curr_max;
        curr_max = curr_max + 1;
        for kk=1:(length(bounds{2}{ii})-1)
            grid_ucm(bounds{1}{ii}(jj),bounds{2}{ii}(kk)+1:1:bounds{2}{ii}(kk+1)) = curr_max;
            curr_max = curr_max + 1;
        end
        grid_ucm(bounds{1}{ii}(jj),bounds{2}{ii}(end)+1:1:end-1) = curr_max;
        curr_max = curr_max + 1;        
    end
    for jj=1:length(bounds{2}{ii})
        grid_ucm(2:1:bounds{1}{ii+1}(1),bounds{2}{ii}(jj)) = curr_max;
        curr_max = curr_max + 1;
        for kk=1:(length(bounds{1}{ii+1})-1)
            grid_ucm(bounds{1}{ii+1}(kk)+1:1:bounds{1}{ii+1}(kk+1),bounds{2}{ii}(jj)) = curr_max;
            curr_max = curr_max + 1;
        end
        grid_ucm(bounds{1}{ii+1}(end)+1:1:end-1,bounds{2}{ii}(jj)) = curr_max;
        curr_max = curr_max + 1;
    end
end

grid_ucm(bounds{1}{n_levels}, 2:1:(bounds{2}{n_levels})) = curr_max+1;
grid_ucm(bounds{1}{n_levels}, bounds{2}{n_levels}+1:1:end) = curr_max+2;
grid_ucm(2:1:end,bounds{2}{n_levels}) = curr_max+3;

grid_ucm(1:end,1) = grid_ucm(1:end,2);
grid_ucm(1:end,end) = grid_ucm(1:end,end-1);
grid_ucm(1,1:end) = grid_ucm(2,1:end);
grid_ucm(end,1:end) = grid_ucm(end-1,1:end);

ucm = grid_ucm(1:2:end-1, 1:2:end-1)/max(grid_ucm(:));

end

