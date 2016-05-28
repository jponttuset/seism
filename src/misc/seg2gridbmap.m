function [gridbmap, idx_neighbors, junctions] = seg2gridbmap(seg, borders)
% [gridbmap, idx_neighbors, junctions] = seg2gridbmap(seg, borders)
%
% From a segmentation, compute a binary boundary map with 1 pixel wide
% boundaries on the contour grid. (As opposed to the pixel grid commenly used, 
% where the boundary pixels are offset by 1/2 pixel towards the origin from 
% the actual segment boundary.)
%
% INPUTS
%	seg		Segments labeled from 1..k.
%   borders Whether boundary with borders is selected (1) or not (0)
%
% OUTPUTS
%	gridbmap		Binary boundary map on contour grid.
%
% Jordi Pont-Tuset <jordi.pont@upc.edu>
% January 2012

if nargin==0
    %% Dummy test
    seg = [1 1 1
           1 1 1
           2 3 4];
else
    seg = double(seg);
end
if nargin<2
    borders = 0;
end

%% To gridbmap
gridbmap = zeros(size(seg)*2 +1);
gridbmap(2:2:end, 3:2:end-1) = (seg(:,1:end-1)~=seg(:,2:end));
gridbmap(3:2:end-1, 2:2:end) = (seg(1:end-1,:)~=seg(2:end,:));

if nargout>1
    %% Neighbor indices
    idx_neighbors.matrix_min = zeros(size(seg)*2 +1);
    idx_neighbors.matrix_max = zeros(size(seg)*2 +1);
    
    idx_neighbors.matrix_min(2:2:end, 3:2:end-1) = gridbmap(2:2:end, 3:2:end-1).*min(seg(:,1:end-1), seg(:,2:end));
    idx_neighbors.matrix_max(2:2:end, 3:2:end-1) = gridbmap(2:2:end, 3:2:end-1).*max(seg(:,1:end-1), seg(:,2:end));
    
    idx_neighbors.matrix_min(3:2:end-1, 2:2:end) = gridbmap(3:2:end-1, 2:2:end).*min(seg(1:end-1,:), seg(2:end,:));
    idx_neighbors.matrix_max(3:2:end-1, 2:2:end) = gridbmap(3:2:end-1, 2:2:end).*max(seg(1:end-1,:), seg(2:end,:));
    if borders
        idx_neighbors.matrix_max(1, 2:2:end) = seg(1,:);
        idx_neighbors.matrix_max(end, 2:2:end) = seg(end,:);
        idx_neighbors.matrix_max(2:2:end, 1) = seg(:,1);
        idx_neighbors.matrix_max(2:2:end, end) = seg(:,end);
    end
end


if nargout>2
    %% Junctions
    junctions.gridbmap = imfilter(gridbmap, [0 1 0; 1 0 1; 0 1 0]);
    junctions.gridbmap = double(junctions.gridbmap>2); % Juntion with more than 2 neighbors
    junctions.gridbmap(2:2:end, 2:2:end) = 0;
   
    tmp_seg = zeros(size(gridbmap));
    tmp_seg(2:2:end, 2:2:end) = seg;
    
    [y,x] = find(junctions.gridbmap);
    
    junctions.points = [];
    for ii=1:length(x)
        junctions.points(ii).x = x(ii);
        junctions.points(ii).y = y(ii);
        junctions.points(ii).neighs = ...
            sort(unique([tmp_seg(y(ii)+1, x(ii)+1)
                         tmp_seg(y(ii)-1, x(ii)+1)
                         tmp_seg(y(ii)-1, x(ii)-1)
                         tmp_seg(y(ii)+1, x(ii)-1)]));
    end
end

if borders
    % Add borders of the image
    gridbmap(2:2:end-1, 1) = 1;
    gridbmap(2:2:end-1, end) = 1;
    gridbmap(1, 2:2:end-1) = 1;
    gridbmap(end, 2:2:end-1) = 1;
end

% gridbmap = logical(gridbmap);