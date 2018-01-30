
%Yuko : goal : combine Molly's getColors.m and getFiles.m and obtain all info relevant to a colony (ant color list, folder#,
% box#) from a single excel file (see 'GS2_colonies.xls' in GS2 folder)
% if imported as cell array, problem : requires a lot of variable input (columns for folder, box info etc)
% in GS2_colonies, firstWcol = 12, maxWnum = 16, foldercol = 8, boxcol = 7;

function [colorList, box, folder,gs,treat,lastL,CList,col,intervals,manualCL]= getColInfo(name,colonies,EXPname)

firstWcol = 12;
maxWnum = 16;
col= find(strcmp(colonies(:,1),name));

folder=colonies{col,8};
box=colonies{col,7};
gs=colonies{col,3};
lastL=colonies{col,10};
treat=colonies{col,5};
intervals=colonies{col,4};
manualCL=colonies{col,11};

colorList=[];
CList=[];

for w=firstWcol:(firstWcol+maxWnum-1)
    %     colName=['W',num2str(w)];
    if w <= size(colonies,2)
        if ~isempty(colonies{col,w})
            if strcmp(EXPname, 'GS2')|| strcmp(EXPname, 'AGE2')|| strcmp(EXPname, 'GEN1')||strcmp(EXPname, 'MOL')||strcmp(EXPname, 'IW1')...
                    ||strcmp(EXPname, 'ING1')||strcmp(EXPname, 'ING2')||strcmp(EXPname,'GS3B')||strcmp(EXPname,'GS2B')||strcmp(EXPname,'GS1A')...
                    || strcmp(EXPname, 'GS')|| strcmp(EXPname, 'FN')% and other experiments that use pink and orange
                [color_tag] = ColCodetoColName(colonies{col,w});
                
            elseif strcmp(EXPname,'AGE3')||strcmp(EXPname,'IW2')||strcmp(EXPname,'LB')||strcmp(EXPname,'GEN2') % and other experiments that use purple and red
                
                [color_tag] = Alt_ColCodetoColName(colonies{col,w});
                
            end
            colorList=cellstr([colorList; color_tag]);
            CList=cellstr([CList; colonies{col,w}]);
        end
    end
end
end