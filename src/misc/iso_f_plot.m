function iso_f_plot(F,color)
% iso_f_plot(F)
% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  March 2011
% ------------------------------------------------------------------------
% This function plots an iso-f curve for a given value of F
% ------------------------------------------------------------------------
if nargin<2
    color=[0.9 0.9 0.9];
end

% Find recall value of precision 1
Rzero = F/(2-F);

% Range of valid R
R = [Rzero:0.01:1 1];
P = (F*R)./(2*R-F);

% Plot
plot(R,P, 'Color', color)
