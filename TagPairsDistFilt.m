
function [Candidates]= TagPairsDistFilt(tagblob, anttagblob, maxdist, mindist)

% calculate pariwise dist between tag blobs
% IS THIS STILL NECESSARY? (considering there's geodist below)
TagblobDist=zeros(size(tagblob.centroid,1),size(tagblob.centroid,1));
SameBlob=zeros(size(tagblob.centroid,1),size(tagblob.centroid,1));

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
CloseBlobs=TagblobDist<maxdist & TagblobDist>mindist;

% find pairs of tags that are on the same anttag blob

for i=1:size(tagblob.centroid,1)
    %     for j=i:size(tagblob.centroid,1) % look for all tag pairs on same blob
    closeB=find(CloseBlobs(:,i)>0); % look only within distance-pre-filtered pairs (faster)
    for j=closeB'
        for k=1:size(anttagblob.centroid,1)
            if ~isempty(intersect(anttagblob.linindxpixlist{k},tagblob.linindxpixlist{i}))&& ~isempty(intersect(anttagblob.linindxpixlist{k},tagblob.linindxpixlist{j}))
                % tagblob.anttagblob(i)=k; %can a tag be on several anttagblobs?
                SameBlob(j,i)=1; 
            end
        end
    end
end

% find tag pairs that are close and on the same anttag blob
Candidates=SameBlob & CloseBlobs;