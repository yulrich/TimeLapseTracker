
% returns a lists of interconnected tags

function [SubMatInd] = FindSubNetwork(c,SymMat)

    ConnTags=c;
    SubMatInd=c;
%     SymMat= Candidates + transpose(Candidates);
    while ~isempty(find(SymMat(ConnTags,:)))% ~ismember(
        %    disp(c)
        [~,colInd] = find(SymMat(ConnTags,:)>0);
        
        if size(colInd,1)>size(colInd,2)% when size(ConnTags)>1 , colInd is a column (otherwise a line vector)
            colInd=colInd';
        end
        newInd=find(~ismember(colInd,SubMatInd)); % find tags that are not already in list 
        ConnTags=colInd(newInd);
        SubMatInd=cat(2,SubMatInd,ConnTags);
    end
    SubMatInd=sort(unique(SubMatInd));
%     SubMat=SymMat(SubMatInd,SubMatInd);
    
