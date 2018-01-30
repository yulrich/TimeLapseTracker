% EASY PAIR CULLING :remove a link between two tags if doing does not increase the number of orphan
% tags (works for tags a-b-c-d in a line fore example : removing b-c
% creates no new orphans since b and c still have another partner)

function [uniqueCandidates]= PairCulling(SubCandidates,SubMatInd)

SymMat= SubCandidates + transpose(SubCandidates);
Pairings=sum(SymMat); % sums columns
Orphans=find(Pairings==0);
nOrphans=size(Orphans,2);
AllCandidates=[];
nTags=size(SubCandidates,1);

if ~(nOrphans==0)
    warning('the submatrix cannot contain orphans');
end

Ambiguous=find(Pairings>1);% index of tags with more than one potential partner
nAmbiguous=size(Ambiguous,2);

Ind=find(SubCandidates);

for link=Ind' % loop through all possible starting points  
    newOrphans=0;
    nNewAmbiguous=0;
    i=link;
    [x,y]=ind2sub([nTags nTags],i); % row and col in SubCandidates
    Tag1=SubMatInd(x);
    Tag2=SubMatInd(y);
    tempCandidates=SubCandidates;
    
    while newOrphans==0 && nNewAmbiguous<nAmbiguous &&~isempty(i)
        NewCandidates=tempCandidates;
        
        for t=1:size(i,1)
            tempCandidates(i(t))=0; % break the link
            tempSymMat= tempCandidates + transpose(tempCandidates); % symetrical matrix
            tempPairings=sum(tempSymMat); % sums columns
            tempOrphans=find(tempPairings==0);
            newOrphans=size(tempOrphans,2);
            
            if newOrphans>0
                tempCandidates(i(t))=1; % restore link
                continue %next t
            else
                tempAmbiguous=find(tempPairings>1);% tags with more than one potential partner
                nNewAmbiguous=size(tempAmbiguous,2);
                % SubCandidates=tempCandidates;
                i=find(tempCandidates); %remaining links
                break
            end
        end
    end
%     disp([num2str(Tag1) ' ' num2str(Tag2) ' ' num2str(sum(sum(NewCandidates)))]);
%     disp(NewCandidates);
    % store all possible NewCandidates, find unique solutions
    AllCandidates=cat(1,AllCandidates,NewCandidates(:)');  
end

uniqueCandidates=unique(AllCandidates,'rows');
% find minimal solutions
S=sum(uniqueCandidates,2);
M=min(S);
MInd=find(S==M);
uniqueCandidates=uniqueCandidates(MInd,:);




