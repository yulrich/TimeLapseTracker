% Testing out assigning color probabilities
% Molly Liu, 2/27/14

function [colorID,PROB] = IDOneTag2_HomeMade(pixPrb,tagblob,c,colorList)

colorID = {' ',' '};
maxIntensity = 0;
tags = {'Green','Blue','Pink','Orange'};

nTargets=size(colorList,1); % n ants in colony
prob=zeros(1,nTargets);
PROB=zeros(1,nTargets);

for nc=1:size(tags,2)
    
    pixIntensity =mean(pixPrb.(tags{nc})(tagblob.linindxpixlist{c}));
    
    % Records the brightest color
    if pixIntensity > maxIntensity
        colorID = tags{nc};
        maxIntensity = mean(pixPrb.(tags{nc})(tagblob.linindxpixlist{c}));
    end
end

colorID = lower(colorID); % lower case for later comparison w/ colorList

% for tag=1:size(colorID,2)
    
    r=cellfun(@(x) strfind(x,colorID),colorList,'uni',false);% find matches for
    match = cellfun(@(x) size(x,2), r); %all matches for a single tag
    nMatches=size(find(match),1); % to give same prob (1/7) to all ID's containing e.g.  P
    %     nMatches=sum(match); % to give higher prob (1/4) to PP than other IDs containing e.g. P (1/8) 
    matchInd=find(match);

%     PROB(matchInd)=match(matchInd)/nMatches;
    PROB(matchInd)=1/nMatches; %changed from the above on 11/24/15

    
% end


end