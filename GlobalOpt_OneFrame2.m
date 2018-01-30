


function [GlobOptants]= GlobalOpt_OneFrame2(ants,colorList,I,NAC,PLOT)


%     IM=imread(ref.fileList{frame,folder});
%     % I=imread(ref.fileList{frame,folder});
%     Im = cutin4_2(IM);
%     % if nargin == 5;
%     I=Im{box};
GlobOptants=struct;
UnassignedDetectionCost=[];


if ~isempty(ants)
    Probmat=cat(1,ants(:).colProb)';
    Costmat=-log(Probmat);
    
    %option 1
        UnassignedDetectionCost=(cat(1,ants(:).quality)).*(cat(1,ants(:).nac));
%         UnassignedDetectionCost=(cat(1,ants(:).quality)).*(2.*(cat(1,ants(:).nac)));
%         UnassignedDetectionCost=(10*(cat(1,ants(:).quality))+ 2*(cat(1,ants(:).nac)))/3;
    
    %option 2
%     UnassignedTrackCost=[ants(:).nac];
    
    %        [assignments,unassignedTracks,unassignedDetections]=assignDetectionsToTracks(Costmat,10);% non assignment cost changed from a flat value of 10
    
    [assignments,~,~]=assignDetectionsToTracks(Costmat,zeros(1,size(colorList,1)),UnassignedDetectionCost');% non assignment cost changed from a flat value of 10
    
    GlobOptants = struct('position',{},'color',{});
    
    for i=1:size(assignments,1)
        foundInd=assignments(i,2);
        AssignedInd=assignments(i,1);
        GlobOptants(i).position = [ants(foundInd).position(1),ants(foundInd).position(2)];
        GlobOptants(i).color = colorList(AssignedInd);
    end
end

if PLOT==1
    
    %before global optimization
    figure, imshow(I);
    % title(name);
    hold on
    for i=1:size(ants,2)
        if ~isempty(ants(i).position)&& ants(i).orient
            text(ants(i).position(1),ants(i).position(2),[num2str(i) ' ' ants(i).color]);
        elseif ~isempty(ants(i).position)&& ~ants(i).orient
            text(ants(i).position(1),ants(i).position(2),[num2str(i) '(' ants(i).color ')']);
        end
    end
    hold off
    
    %after optimization
    figure, imshow(I);
    title(num2str(NAC));
    % title(name);
    hold on
    for i=1:size(assignments,1)
        foundInd=assignments(i,2);
        AssignedInd=assignments(i,1);
        text(ants(foundInd).position(1),ants(foundInd).position(2),colorList(AssignedInd),'Color',rgb('red'));
    end
    hold off
    
    
end

end



