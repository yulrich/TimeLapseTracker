function [square,dx,dy] = RectMkr(centroid,length,width)
% this function creates a square of size 'size' and centered (approximately, i.e. with one
% pixel resolution) on 'centroid'.
% the function returns the square and dx and dy, which are the differences
% between the square center and the centroid

x0 = round(centroid(1));
y0 = round(centroid(2));
dx = x0 - centroid(1);
dy = y0 - centroid(2);

square.Position = [x0-length/2 y0-width/2 length width];