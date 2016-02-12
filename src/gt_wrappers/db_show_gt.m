% ------------------------------------------------------------------------ 
%  Copyright (C)
%  ETHZ - Computer Vision Lab
% 
%  Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
%  September 2015
% ------------------------------------------------------------------------ 
% This file is part of the BOP package presented in:
%    Pont-Tuset J, Van Gool, Luc,
%    "Boosting Object Proposals: From Pascal to COCO"
%    International Conference on Computer Vision (ICCV) 2015.
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------
function show_gt = db_show_gt(database, image_id)
    if strcmp(database,'COCO')
        % Load the ground truth and extra info
        [~, gt_set, im, anns] = db_gt( database, image_id );
        
        % Get COCO
        coco = evalin('base', ['coco_' gt_set]);
        
        % Create an invisible figure
        h = figure('Position',[0 0 size(im,2) size(im,1)]); set(h, 'Visible', 'off');
        
        % Show everything
        imagesc(im); axis('image'); set(gca,'XTick',[],'YTick',[]); set(gca, 'Position', [0 0 1 1]);
        coco.showAnns(anns);
        
        cdata = hardcopy(h, '-Dzbuffer', '-r0');
        show_gt = cdata;
        
        close(h);
    else
        error(['Not implemented for ' database])
    end
end
