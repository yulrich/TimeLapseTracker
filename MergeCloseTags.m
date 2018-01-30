function newTagBW= MergeCloseTags(G,maxdist,I)

% G=bwmorph(im2bw(pixPrb.Green,.65),'bridge');% changed on 10/09/15
% G=G&mask;

% figure, imshow(G), hold on, imshow(I), alpha(0.35)

H = vision.BlobAnalysis('MinimumBlobArea',7,... % changed from 200 on 1/28/15
    'MaximumBlobArea',10000,...
    'MaximumCount',220,...
    'OrientationOutputPort',true,...
    'BoundingBoxOutputPort',true,...
    'LabelMatrixOutputPort',true,...
    'PerimeterOutputPort',true,...
    'Connectivity',8); % changed from 4 on 09/21/15
[tagblob.area,tagblob.centroid,tagblob.bbox,tagblob.orient,tagblob.perimeter,tagblob.label] = step(H,G);

tagN = length(tagblob.area);
tagblob.linindxpixlist = getpixlist(tagblob,'label',tagN);

% % if PLOT==1
% figure,imshow(G);
% hold on
% imshow(I), alpha(0.35);
% title('Initial search for color tags');
% for i=1:size(tagblob.centroid,1)
%     text(tagblob.centroid(i,1),tagblob.centroid(i,2),num2str(i),'Color','red');
% end
% hold off
% % end

% calculate pariwise dist between tag blobs
% IS THIS STILL NECESSARY? (considering there's geodist below)
TagblobDist=zeros(size(tagblob.centroid,1),size(tagblob.centroid,1));

for i=1:size(tagblob.centroid,1)
    for j=i:size(tagblob.centroid,1)
        if i==j
            TagblobDist(j,i)=1000;
        else
            TagblobDist(j,i)= norm(tagblob.centroid(i,:)-tagblob.centroid(j,:));
        end
    end
end

% rough pre selection of tag pairs (more below using bwgeodesic)
% keep tag pairs that are at the right distance
CloseBlobs=TagblobDist<maxdist & TagblobDist>0;

[tag1,tag2]=find(CloseBlobs);
newTagBW=G;

% disp(size(tag1,1))

if ~isempty(tag1)
    
    for s=1:size(tag1,1)
        
        [tag1X,tag1Y]=ind2sub([size(I,1),size(I,2)],tagblob.linindxpixlist{tag1(s)});
        [tag2X,tag2Y]=ind2sub([size(I,1),size(I,2)],tagblob.linindxpixlist{tag2(s)});
        
        X=cat(1,tag1X,tag2X);
        Y=cat(1,tag1Y,tag2Y);
        
        if size(unique(X),1)>1 && size(unique(Y),1)>1
            try
                [Hull,~]=convhull(X,Y); %conver hull
                M=poly2mask(Y(Hull),X(Hull),size(I,1),size(I,2));
                
                %         figure, imshow(M), hold on, imshow(I), alpha(0.35);
                
                newTagBW= newTagBW | M;
            catch   
            end
        else

        end
    end
end

% figure, imshow(newTagBW), hold on, imshow(I), alpha(0.35);


