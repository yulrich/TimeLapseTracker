% uses RectMkr instead of SqrMkr to crop closer ot the ant
% rotates before cropping, not after

function [Antpic,BWpic]=cropAnt4(I,antBW,midpointX,midpointY,Rad,width,length)


% angle between the line connecting the two tags and the x-axis (in degrees)
angle = 180 * Rad / pi; 
% Rotate entire frame to have focal ant vertical (around the center point
% by default)
rotatedIm = imrotate(I,angle+90,'bilinear','crop');
rotatedMask = imrotate(antBW,angle+90,'bilinear','crop');


% new coordinates of midpoint

sz = size(I) / 2;
n_midpointX = midpointX - sz(2);
n_midpointY = midpointY - sz(1);
rot_mat=[cosd(angle+90), -sind(angle+90); sind(angle+90) ,cosd(angle+90)];
n_midpoint = [n_midpointX n_midpointY];
new_midpoint = n_midpoint * rot_mat;
new_midpoint(1) = new_midpoint(1) + sz(2);
new_midpoint(2) = new_midpoint(2) + sz(1);


% Crop original image to the ant image
[antcrop,~,~] = RectMkr([new_midpoint(1),new_midpoint(2)],width,length);% changed from 52 (square) on 1/28
pos = antcrop.Position;
Antpic = imcrop(rotatedIm,pos);
Maskpic= imcrop(rotatedMask,pos);
BWpic = im2bw(Maskpic,0.1);


% Crop BW image to single ant, getting rid of items on border
% BW = bsxfun(@times, plate.antBW, plate.antblob.label==na);
% imshow(rotatedMask), alpha(0.35)

end