% Uses the home made classifier for comparison w/ Naive Bayes
% Yuko Ulrich, 10/09/15
% set PLOT to 0 or 1 (L.19)

function [plate] = S_AnalyzePlateFrame(ref,Trck,current_colList,HandmadeMasks,folder,f,box,name)

binnum=64;

if isempty(ref.fileList{f,folder})
    plate = struct('ants',struct(),'frame',f);
    return;
end

% Get camera image and plaster mask
IM = imCorrect_7(ref,folder,f); 
Im = cutin4_2(IM);
I=(Im{box});  figure, imshow(I)
mask=HandmadeMasks{folder, box};

pixPrb = getPlatePixPrb_HomeMade(I,Trck.SmColorPnormPlate,Trck.ColorMax,binnum);

% eliminate breadboard and camera-bug (black) frames (empirical)
if mean(pixPrb.Ant(:))>0.5 || mean(pixPrb.Ant(:))<0.1 || mean(pixPrb.Plaster(:))<0.05
    plate.ants={};
    plate.frame = f;
    plate.absTime=ref.AbsTimes(f,folder);
    disp(f)
else
    plate = S_tag_pairs_search_HomeMade(I,pixPrb,mask,Trck,1,binnum,current_colList,f); % 5th variable: 1 or 0, to plot or not 
    plate.frame = f;
    plate.absTime=ref.AbsTimes(f,folder);
end

%% Optional plot

% figure, imshow(I);
% title([name ' ' num2str(f)]);
% hold on
% for i=1:length(plate.ants)
%     text(plate.ants(i).position(1),plate.ants(i).position(2),plate.ants(i).color);
% end
% hold off

end