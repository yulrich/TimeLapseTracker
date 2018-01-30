% 12/05/14, uses antHeadUp3, adapted to Ofer's method
% Molly Liu, 2/27/14

function [colorID,prob,PROB,orient] = AnalyzeTwoTags5(headup,BWpic,AntpixPrb,colorList,Ambig,Antpic,PLOT,f)

orient=abs(headup);

if headup == -1 % head is down
    %     fprintf('Rotated antblob %d\n',na);
    AntpixPrb.Green = imrotate(AntpixPrb.Green,180);
    AntpixPrb.Orange = imrotate(AntpixPrb.Orange,180);
    AntpixPrb.Pink = imrotate(AntpixPrb.Pink,180);
    AntpixPrb.Blue = imrotate(AntpixPrb.Blue,180);
    BWpic = imrotate(BWpic,180);
end

nTargets=size(colorList,1); % n ants in colony
prob=zeros(1,nTargets);
PROB=zeros(1,nTargets);

% order: G, B, P, O
colorthresh = [0.6, 0.07, 0.65, 0.2]; % blue thresh changed from 0.02 on 11/09/15 (larger than thresh for whole plate because of the differences bet. pixPrb and AntpixPrb)
% O thresh changed from 0.4 on 9/5/16, then from 0.28 on 12/4/15, then
% from 0.6 on 12/7/15
% P thresh changed from 0.73 on 12/4/15
% Find tag colors of the ant
colorID = IDTwoTags3_HomeMade(AntpixPrb,Antpic,BWpic,colorthresh,PLOT,f);

if ~isempty(regexp(strcat(colorID{:}),'?','ONCE'))
    colorthresh = [0.6, 0.05, 0.6, 0.15]; % O thresh changed from 0.6 on 12/03/15
    colorID = IDTwoTags3_HomeMade(AntpixPrb,Antpic,BWpic,colorthresh,PLOT,f);
end

if orient % if the ant is oriented, look for a full match (both tags)
    fullID=[colorID{1} ' ' colorID{2}];
    matchInd=find(strcmp(fullID,colorList));
    % TO DO: implement error/warning if >1 match here
    prob(matchInd)=1/size(matchInd,1); % should always be 1
    if isempty(matchInd) % if the ID is not in color list, look for flipped ID, assign it low prob
        flippedID=[colorID{2} ' ' colorID{1}];
        flippedmatchInd=find(strcmp(flippedID,colorList));
        prob(flippedmatchInd)=1/(5*size(flippedmatchInd,1)); % should always be 1
        
    end
    PROB=prob/Ambig; %sum of corprob not necessarily 1
elseif ~orient
    if strcmp(colorID{1},colorID{2}) % for PP,BB,GG,OO,assign ID even if unoriented
        orient=1;
        fullID=[colorID{1} ' ' colorID{2}];
        matchInd=find(strcmp(fullID,colorList));
        % TO DO: implement error/warning if >1 match here
        prob(matchInd)=1/size(matchInd,1); % should always be 1
        PROB=prob/Ambig; %sum of corprob not necessarily 1
    else
        r1=cellfun(@(x) strfind(x,colorID{1}),colorList,'uni',false);
        r2=cellfun(@(x) strfind(x,colorID{2}),colorList,'uni',false);
        match1 = ~cellfun(@isempty, r1);
        match2 = ~cellfun(@isempty, r2);
        matchInd=find(match1 & match2);
        % TO DO: implement error/warning if >2 matches here
        prob(matchInd)=1/size(matchInd,1);% should be 0.5 for BP and PB, for example (sum of prob should be one)
        PROB=prob/Ambig; %sum of corprob not necessarily 1
    end
end

end

