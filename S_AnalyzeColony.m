% fct will not work for a single frame)

function AutoTracked=S_AnalyzeColony(name,saveToFolder,EXPname,colonies)

mkdir(saveToFolder);
cd(saveToFolder);

load([EXPname 'ants.mat']); % contains ovariole and death data for each ant
ants=eval([EXPname 'ants']);
load([EXPname 'ref_PC.mat']); % computer specific file, pathname of each picture
load([EXPname '_HandmadeMasks2.mat']); % handmade masks (2D 0/1 matrices)
load('HomeMadeClassifier_REF_8Classes.mat'); % classifier of pixels based on color (experiment & color-set specific) 

[~, box, folder,~,~,~,CList]= getColInfo(name,colonies,EXPname);

nFrames=size(ref.fileList,1);
lastframe=nFrames; 

index = 1;

for f = 1:nFrames 
    if f<lastframe
        if ~isempty(ref.fileList{f,folder}) 
            
            current_colList=updateColList(f,CList,name,ants); % looks for dead ants, remove them from colorList
            try
                AutoTracked1{index} = S_AnalyzePlateFrame(ref,Trck,current_colList,HandmadeMasks1,HandmadeMasks2,folder,f,box,name);
                index = index + 1;
            catch
                pause(30);
                AutoTracked1{index} = S_AnalyzePlateFrame(ref,Trck,current_colList,HandmadeMasks1,HandmadeMasks2,folder,f,box,name);
                index = index + 1;
            end
        else
            AutoTracked1{index}.ants={};
            AutoTracked1{index}.frame=f;
            AutoTracked1{index}.absTime=[];
            index=index+1;
        end
    end
end

AutoTracked = cell2mat(AutoTracked1');
save([saveToFolder filesep 'Auto_' name datestr(now, '_yy_mm_dd_HH_MM_SS'),'.mat'],'AutoTracked','-v7.3');

end