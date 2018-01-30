function [pixPrb,rlvpix,eroddrlvpix] = ImColorProb(I,ColorPNorm,binnum,segthresh2,ColorMax)
% 04/22/15
% renamed 'ImColorProb'
% 01/28/15
% nan are forced to 0
% Provides with a list of relevant pixels without the border one.
% this version outputs a list of the non-zero pixel, and uses a
% segmentation threshold:  segthresh2=0.55 works fine
% this function evaluates for each pixel of an image 'frame' and in the list 'list' the probability that
% the pixel is of a given color, based on a probability distribution
% 'ColorPNorm' obtained empirically.
% [pixPrb,rlvpix,eroddrlvpix] = ImColorProb_5(rotframeCrop,ColorPNorm,Trck.prmtrs.ColorDef.binnum,0.55)

test = whos('I');
factor = 1;
if strcmp(test.class,'uint8')
    factor = 255;
end

pixPrb = zeros(size(I,1),size(I,2));
Npix = size(I,1)*size(I,2);
layer.red = double(I(:,:,1))/factor;
layer.green = double(I(:,:,2))/factor;
layer.blue = double(I(:,:,3))/factor;

% find the pixels where at least one 
% bindbl finds the bin to which the value 'v' belongs
if nargin == 5
    r =  bindbl(layer.red(:),ColorMax.R/binnum);
    g =  bindbl(layer.green(:),ColorMax.G/binnum);
    b =  bindbl(layer.blue(:),ColorMax.B/binnum);
else
    r =  bindbl(layer.red(:),1/binnum);
    g =  bindbl(layer.green(:),1/binnum);
    b =  bindbl(layer.blue(:),1/binnum);
end

    r = min(r,binnum);
    g = min(g,binnum);
    b = min(b,binnum);
    
% % attempt at vectorizing the commented loop below
% 
LinearIndex=sub2ind([binnum binnum binnum],r,g,b);
pixPrb = ColorPNorm(LinearIndex);
pixPrb = reshape(pixPrb,size(I,1),size(I,2));
% % try
% pixPrb(LinearIndex) = ColorPNorm(LinearIndex);%/binnum^3;
% % catch
% %     disp(num2str(r(npix),g(npix),b(npix)));
% % end


% for npix=1:Npix %VECTORIZE THIS
% %     if isequal([r(i) g(i) b(i)],51,38,39)
% %         disp(i)
% %     end
% try
% pixPrb(npix) = ColorPNorm(r(npix),g(npix),b(npix));%/binnum^3;
% catch
%     disp(num2str(r(npix),g(npix),b(npix)));
% end
% end


% pixPrb(:) = ColorPNorm(r(:),g(:),b(:));
pixPrb(isnan(pixPrb(:))) = 0;

rlvpix = find(pixPrb(:)>segthresh2);
bw = zeros(size(I,1),size(I,2));
bw(rlvpix) = 1;

%% the structuring element object should be an input argument of the function
bw2 = imerode(bw,strel('disk',1));
eroddrlvpix = find(bw2(:));


