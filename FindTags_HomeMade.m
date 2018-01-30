% for ColorModel2 (7 classes, including shadows but not food)

function [tagblob, anttagblob, antBW, tags,G_bias]= FindTags_HomeMade(pixPrb,I,mask,PLOT)

mintagsize=6;
maxtagsize=230; % changed from 220 on 12/9/15
% Finding ant color tags
G=bwmorph(im2bw(pixPrb.Green,.75),'bridge');% changed from 0.625 on 12/07/15
G=G&mask;
G= MergeCloseTags(G&mask,10,I); % maxdist changed form 10 on 11/09/15

G_bias=0;

if size(find(G),1)>1000 % loop added on 09/05/16 to deal w/ frames w/ tons of green
   G_bias=1;
   G=bwmorph(im2bw(pixPrb.Green,.9),'bridge');% changed from 0.625 on 12/07/15 
   G=bwmorph(G,'diag'); % added on 11/06/15
   G=G&mask;
end

B=im2bw(pixPrb.Blue,.06); % changed from .1 on 11/09/15
P=im2bw(pixPrb.Pink,.75);% changed from .9 on 09/5/16, from 0.9 on 12/9/15
O=im2bw(pixPrb.Orange,0.2); % changed back to .2 on 09/28/16 (for stringent orange color model)

% O=im2bw(pixPrb.Orange,0.86); % changed from .93 on 11/19/15 (for stringent orange color model)

% remove large orange blobs (more stringent than for other colors)
sizeFilteredO_1 = bwareaopen(O, 210, 4); %195 connectivity changed to 4 on 12/10
sizeFilteredO_2 = bwareaopen(O, 7, 4); % changed from 12 on 11/04
O = sizeFilteredO_2 - sizeFilteredO_1;

S = im2bw(pixPrb.Shadow,.18); 
% S = im2bw(pixPrb.Shadow,.11); % changed from .18 on 11/20/15

tags=(G|B|P|O)& mask & ~S; % added pm 02/03


% remove tags that are smaller than 12 or bigger 175 (same as in H above)
% this removes some tags that would be useful to build AntTag, skip?
sizeFilteredTags1 = bwareaopen(tags, maxtagsize, 4); % connectivity changed to 4 on 12/10
sizeFilteredTags2 = bwareaopen(tags, mintagsize, 4); % changed from 12 on 11/04
sizeFilteredTags3 = sizeFilteredTags2-sizeFilteredTags1;

clear sizeFilteredTags1
clear sizeFilteredTags2

% figure,imshow(sizeFilteredTags3), hold on, imshow(I), alpha(0.35);

% COMBINE ANT COLOR WITH TAG COLOR
% could be decreased if def of orange was more stringent
cuticle=im2bw(pixPrb.Ant,.6); % changed from 0.9 on 09/20/15
AntTag=sizeFilteredTags3|cuticle;
% figure, imshow(AntTag), hold on, imshow(I), alpha(0.35)

% AntTag=tags+cuticle;
clear cuticle

% figure,imshow(AntTag),hold on,imshow(I), alpha(0.35);

Tse90 = strel('line', 2, 90);%vertical
Tse0 = strel('line', 2, 0);%horizontal
Tdil = imdilate(AntTag, [Tse90 Tse0]);
Tdil=bwmorph(Tdil,'bridge'); % added 11/06/15

% Tdil = imdilate(Tdil, [Tse90 Tse0]);
% figure, imshow(Tdil), hold on, imshow(I), alpha(0.35)

seD = strel('diamond',1);
% changed from same as above [Tse90 Tse0] to seD on 09/21/15
antBW2 = imerode(Tdil,seD);

clear Tdil
% antBW2 = imerode(antBW1,seD);
clear antBW1
antBW=antBW2.*mask;
% figure, imshow(antBW), hold on, imshow(I), alpha(0.35)
clear antBW2

H = vision.BlobAnalysis('MinimumBlobArea',mintagsize,... % changed from 7 on 11/04
    'MaximumCount',100,...% changed from 10000
    'MaximumBlobArea',maxtagsize-1,... % changed from 200 on 20/09/15
    'OrientationOutputPort',true,...
    'MajorAxisLengthOutputPort', true, ...
    'MinorAxisLengthOutputPort', true, ...
    'BoundingBoxOutputPort',false,...
    'LabelMatrixOutputPort',true,...
    'Connectivity',4);%changed from 8 on 12/09
[tagblob.area,tagblob.centroid,tagblob.majoraxislength,tagblob.minoraxislength,tagblob.orient,tagblob.label] = step(H,tags);

if PLOT==1   
    figure,imshow(tags);
    hold on
    imshow(I), alpha(0.35);
    title('Initial search for color tags');
    for i=1:size(tagblob.centroid,1)
        text(tagblob.centroid(i,1),tagblob.centroid(i,2),num2str(i),'Color','red');
    end
    hold off 
end

H = vision.BlobAnalysis('MinimumBlobArea',130,... % changed from 170 on 1/28/15
    'MaximumBlobArea',Inf,...
    'MaximumCount',100,... %changed from 10000
    'OrientationOutputPort',true,...
    'MajorAxisLengthOutputPort', true, ...
    'MinorAxisLengthOutputPort', true, ...
    'BoundingBoxOutputPort',true,...
    'LabelMatrixOutputPort',true,...
    'PerimeterOutputPort',true,...
    'Connectivity',8); % changed from 4 on 09/21/15
[anttagblob.area,anttagblob.centroid,anttagblob.bbox,anttagblob.majoraxislength,anttagblob.minoraxislength,anttagblob.orient,anttagblob.perimeter,anttagblob.label] = step(H,logical(antBW));

if PLOT==1
    figure,imshow(antBW);
    hold on
    imshow(I), alpha(0.35);
    title('Search for ant+color tags');
    
    for i=1:size(anttagblob.centroid,1)
        text(anttagblob.centroid(i,1),anttagblob.centroid(i,2),num2str(i),'Color','red');
    end
    hold off
end

anttagN = length(anttagblob.area);
tagN = length(tagblob.area);
anttagblob.nTags = zeros(1,anttagN);
anttagblob.linindxpixlist = getpixlist(anttagblob,'label',anttagN);
tagblob.linindxpixlist = getpixlist(tagblob,'label',tagN);
% plate.antBW = antBW;

tagblob.linindxpixlist = getpixlist(tagblob,'label',tagN);
anttagblob.linindxpixlist = getpixlist(anttagblob,'label',anttagN);