% calculates pixels tag probabilities (L17) on masked images (mask is output of cropAnt2)
% Yuko's version of Molly's getAntTagPixPrb.m
% Uses getPlatePixPrb2 (which uses Naive Bayes), no pixPrb.Brood
% Get pixPrb of single ant with tags and display graph
% Molly Liu, 3/5/14

function [antmean,tagmean,AntpixPrb] = getAntTagPixPrb_HomeMade(Antpic,mask,SmColorPnormAnt,ColorMax,binnum,G_bias)

AntpixPrb = getPlatePixPrb_HomeMade(Antpic,SmColorPnormAnt,ColorMax,binnum);
[m,n,~] = size(Antpic);
tags = {'Green','Pink','Orange','Blue'};
tagpix = zeros(m,n);

for nt=1:length(tags)
    if (nt==1)&& G_bias
        tagpix = tagpix + (AntpixPrb.(tags{nt}))/5; % added on 09/05/16
    elseif (nt==4)||(nt==3)
        tagpix = tagpix + 5*AntpixPrb.(tags{nt}); % added on 09/05/16
    else
        tagpix = tagpix + AntpixPrb.(tags{nt});
    end
end

tagpix = tagpix.*(1-AntpixPrb.Plaster).*(1-AntpixPrb.Shadow).*mask;
noplaster = AntpixPrb.Ant.*(1-AntpixPrb.Plaster).*(1-AntpixPrb.Shadow);
notags = noplaster.*(1-tagpix).*mask;

tagstrip=tagpix.*mask;
antstrip=notags.*mask;

% figure,imshow(tagpix);
% title('tags | ~plaster | ~ant');
% figure,imshow(noplaster);
% title('ant | ~plaster');
% figure,imshow(notags);
% title('ant | ~plaster | ~tags');

antmean = smooth(sum(antstrip,2),8);
tagmean = smooth(sum(tagstrip,2),8);

end