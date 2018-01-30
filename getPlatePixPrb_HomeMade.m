% check that ImColorProb_4 is the correct function (changed from
% ImSmthColorProb_4 because it didn't exist)
% Assigning color probabilities, using ImSmthColorProb_4
% Molly Liu -- CURRENT AS OF 2/28/14

function [pixPrb] = getPlatePixPrb_HomeMade(I,SmColorPnorm,ColorMax,binnum)

% tagcolors = {'green','orange','pink','blue','ant','plaster','brood'};
tagcolors = fieldnames(SmColorPnorm)';

for color_num=1:size(tagcolors,2)
    pixPrb.(tagcolors{color_num}) = ImColorProb(I,SmColorPnorm.(tagcolors{color_num}),binnum,0,ColorMax);
end
end