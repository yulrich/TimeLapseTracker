% for Ofer's tracking method
% IMPROVE : L25-26, cut above half pic? Use J's TopBottomBlobStatsVals.m to ID ants?
% Yukos' version of Molly's IDTwoTags.
% Same thresholds (0.99, 0.85) as in FindAnts_6.m but relaxed size and
% connectivity criteria
% Testing out assigning color probabilities
% Molly Liu, 2/27/14

function [colorID] = IDTwoTags3_HomeMade(AntpixPrb,Antpic,BWpic,colorthresh,PLOT,f)

colorID = {'?','?'};
maxblob = [0,0];
tagcolors = {'Green','Blue','Pink','Orange'};
H = vision.BlobAnalysis('MinimumBlobArea',6,... %changed from 7 on 11/09/15
    'MaximumBlobArea',220,...
    'BoundingBoxOutputPort',false,...
    'LabelMatrixOutputPort',true,...
    'Connectivity',8); %changed from 4 on 11/19/15

% Find blobs for each color
for nc=1:size(tagcolors,2)
    
    % remove small elements (e.g. parts of other ants) from mask
    picture = im2bw(AntpixPrb.(tagcolors{nc}),colorthresh(nc)) & bwareaopen(BWpic,100,4);
    
    %     figure, imshow(picture), hold on, imshow(Antpic), alpha(0.35)
    [n,~] = size(picture);
    %     thorax.graypic=AntpixPrb.(tagcolors{nc})(1:round(n/2),:);
    %     abdomen.graypic=AntpixPrb.(tagcolors{nc})(round((n+1)/2):n,:);
    thorax.bwpic = picture(1:round(n/2),:);
    thorax.bwpic = bwareaopen(thorax.bwpic,6); %added on 12/14/15, removes isolated pix that shouldn't be included in hull
    
    abdomen.bwpic = picture(round((n+1)/2):n,:);
    abdomen.bwpic = bwareaopen(abdomen.bwpic,6);
    
    if nc==4
        % should remove orange tags with weird shapes (hollow, or 'patchy')
        if size(find(thorax.bwpic),1)>6
            [thoraxM]=convexHull2Mask(thorax.bwpic); %mask of the convex hull
            if (size(find(thoraxM),1)/size(find(thorax.bwpic),1))>1.3 %changed from 1.5 on 12/16/15
                %                 if size(find(thorax.bwpic),1)>40 % only to not plot too much (the small blobs are unlikely to be kept anyway), remove later
                %                     figure,subplot(1,3,1),imshow(thoraxM),subplot(1,3,2),imshow(thorax.bwpic),subplot(1,3,3),imshow(Antpic)
                %                     title(['frame ' num2str(f) ' ' tagcolors{nc}])
                %                 end
                thorax.bwpic(find(thorax.bwpic))=0;
            end
        end
        
        
        if size(find(abdomen.bwpic),1)>6
            [abdomenM]=convexHull2Mask(abdomen.bwpic); %mask of the convex hull
            if (size(find(abdomenM),1)/size(find(abdomen.bwpic),1))>1.3 %changed from 1.5 on 12/16/15
                %                 if size(find(abdomen.bwpic),1)>40 % only to not plot too much, remove later
                %                     figure,subplot(1,3,1),imshow(abdomenM),subplot(1,3,2),imshow(abdomen.bwpic),subplot(1,3,3),imshow(Antpic)
                %                     title(['frame ' num2str(f) ' ' tagcolors{nc}])
                %                 end
                abdomen.bwpic(find(abdomen.bwpic))=0;
            end
        end
    end
    
    
    [thorax.area,thorax.centroid,thorax.label] = step(H,thorax.bwpic);
    
    [abdomen.area,abdomen.centroid,abdomen.label] = step(H,abdomen.bwpic);
    tNum = size(thorax.area,1); % n thorax blobs
    aNum = size(abdomen.area,1); % n abdomen blobs
    %     thorax.linindxpixlist = getpixlist(thorax,'label',1);
    %     abdomen.linindxpixlist = getpixlist(abdomen,'label',1);
    %
    %     % mean brightness of blob pixels
    %     thoraxBright = mean(thorax.graypic(thorax.linindxpixlist{:}));
    %     abdomenBright = mean(abdomen.graypic(abdomen.linindxpixlist{:}));
    
    % Records the largest blobs from the top and bottom halves of the image
    
    for nt=1:max(tNum,aNum)
        if nt <= tNum
            % Thorax tag
            if thorax.area(nt) >= maxblob(1)
                colorID{1} = tagcolors{nc};
                maxblob(1) = thorax.area(nt);
                maxThoraxpic=thorax.bwpic;
            end
        end
        if nt <= aNum
            % Abdomen tag
            if abdomen.area(nt) >= maxblob(2)
                colorID{2} = tagcolors{nc};
                maxblob(2) = abdomen.area(nt);
                maxAbdomenpic=abdomen.bwpic;
            end
        end
    end
end

colorID = {lower(colorID{1}),lower(colorID{2})}; % lower case for later comparison w/ colorList

if PLOT==1 && maxblob(1)>0 && maxblob(2)>0 % maxThoraxpic, maxAbdomenpic undefined if no tag found
    finalpic=cat(1,maxThoraxpic,maxAbdomenpic);
    subplot(2,2,4),imshow(finalpic);
    hold on
    imshow(Antpic),alpha(0.35);
    text(20, 5,[colorID{1} ' ' colorID{2}]);
    hold off
end

end