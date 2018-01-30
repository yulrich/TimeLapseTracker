% BEFORE RUNNING: check color model (GBOP or GBRV) in
% AnalyzeColony_HM_colListupdate, check Trck.SmColorPnormPlate vs.
% Trck.SmColorPnorm in AnalyzePlateFrame_HomeMade

%list of colonies that have already been manually tracked
Already={};

% list of colonies to exclude from the analysis
Problems={};

EXPname='GS';
load([EXPname 'colonies.mat']);
colonies=eval([EXPname 'colonies']);
collist=colonies(:,1);
saveToFolder = uigetdir('','pick the folder to store the data');

c=parcluster();
Job=createJob(c);

    for tasknum = 1:size(collist,1)
        name = collist{tasknum};
        disp(name)
        if ~ismember(name,Already) && ~ismember(name,Problems)
            tasks{tasknum}=createTask(Job, 'S_AnalyzeColony',0,{name,saveToFolder,EXPname,colonies});
        end
    end
    
    submit(Job);
