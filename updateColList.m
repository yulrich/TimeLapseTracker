function [current_colList]= updateColList(frame,CList,name,ants)

%columns
uniqueID = 1; % [boxID wID]
boxID = 4;
wID=7; % e.g. 'BP'
lastFrame=9; % lastframe where the ant was seen alive (=dead day -3)
death=10; % binary (dies before end experiment or not)
NOv=11; % number of ovarioles
nDvpOv=12; % number developped ovarioles
Eyes=13; % binary


col= find(strcmp(ants(:,4),name));
sub=ants(col,:);

DIED=find(cellfun(@isnumeric, sub(:,9)));

if ~isempty(DIED)
    for D=DIED'
        if  isnumeric(sub{D,9}) && sub{D,9}<frame % must be numeric (avoid 'lastframe's)
            ind=find(cellfun(@(IDX) ~isempty(IDX),strfind(CList, sub{D,7})));% find wID in CList
            CList(ind)=[];
        end
    end
end


current_colList=[];

if ~isempty(CList)
    for w=1:size(CList,1)
        [color_tag] = ColCodetoColName(CList(w));
        current_colList=cellstr([current_colList; color_tag]);
    end
end


