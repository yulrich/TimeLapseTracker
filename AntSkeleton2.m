
% Antpic is the cropped image of a single ant, BWpic the corresponding mask
% (1 for ant or tag, 0 for the rest), P=1 to plot the skeleton

function [dilSkelD,NBranchpoints]=AntSkeleton2(Antpic,BWpic,P)

blobSkel=bwmorph(BWpic,'Skel',Inf);
lineSkel=bwmorph(blobSkel, 'thin');

% CLEAN THE SKELETON (REMOVE SIDE BRANCHES SHORTER THAN 5 PIXELS)

% % first round
B = bwmorph(lineSkel, 'branchpoints');
E = bwmorph(lineSkel, 'endpoints');
[y,x] = find(E);
B_loc = find(B);
Dmask = false(size(lineSkel)); % matrix of 0's the size of blobSKel
for k = 1:numel(x)
    D = bwdistgeodesic(lineSkel,x(k),y(k)); % all distance from endpoint k 
    distanceToBranchPt = min(D(B_loc)); % distance to closest branchpoint 
    if distanceToBranchPt<5
    Dmask(D < distanceToBranchPt) =true; % all pixels beyon a branchpoint
    end
end
skelD = logical(lineSkel - Dmask);

% REMOVE ALL BUT THE LARGEST SKELETON COMPONENTS
comp_size=[];
% CC = bwconncomp(blobSkel); % finds connected components
CC = bwconncomp(skelD); % finds connected components

if size(CC.PixelIdxList,2)>1
   for comp=1:size(CC.PixelIdxList,2)
    comp_size(comp)=size(CC.PixelIdxList{comp},1);% number of pixels per component
    [~,index]=sort(comp_size); % sorts increasing size by default
    decreasing_I=fliplr(index);
    for sc=2:size(decreasing_I,2)
      ind=decreasing_I(sc);
      skelD(CC.PixelIdxList{ind})=0; 
    end
   end
end

finB = bwmorph(skelD, 'branchpoints');
NBranchpoints=size(find(finB),1);
% DILATE THE SKELETON

% linear structuring element 
Tse90 = strel('line', 8, 90); % vertical, changed from 2 on 02/07
Tse0 = strel('line', 2, 0); % horizontal

dilSkelD = imdilate(skelD, [Tse90 Tse0]);

if P==1
    figure, imshow(dilSkelD);
    hold on
    imshow(Antpic), alpha(0.35)
    [y,x] = find(B); plot(x,y,'bo')
    text(-10, -10,[num2str(NBranchpoints) ' branchpoints']);
end
end