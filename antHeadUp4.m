% Yuko's version of Molly's antHeadUp
% antHeadUp: gives 1 if head is up, -1 if head is not, 0 if this doesn't fit
% that pattern
% called by AnalyzeTwoTags3.m
% Molly Liu, 2/28/14

function [headup,nAntPeaks,nTagPeaks] = antHeadUp4(antmean,tagmean,Antpic,NBranchpoints,dilSkelD,PLOT)

headup = 0;

% findpeaks(antmean,maxpeaksnum,minpeakheight,minpeakdist);
% nAntPeaks records the numebr of peaks (even though only 2 are kept)
[~,antloc,nAntPeaks] = findMaxPeaks(antmean,2,1.4,12);  % min dist peaks changed from 10 on 12/07/15
[~,tagloc,nTagPeaks] = findMaxPeaks(tagmean,2,1.1,11); % min dist peaks changed from 15 on 11/06/15, minpeakheight changed from 0.5 on 12/15/15

% first condition changed from length(antloc) == 2 on 09/25/15
if nAntPeaks == 2 && length(tagloc) >= 1  && abs(mean(antloc)- mean(tagloc))> 2 
    if mean(antloc) < mean(tagloc) %min diff of 2 between average of two highest peaks 
        headup = 1;
    elseif mean(tagloc) < mean(antloc)
        headup = -1;
    end  
end

if PLOT==1
    % Graph antmean, tagmean, with found peaks (debugging purposes)
    data.graph = figure;
    x = 1:size(antmean,1);
    subplot(2,2,[1,2]),
    hold on
    plot(antmean,'Color',rgb('maroon'));
    plot(antloc, antmean(antloc),'*k')
    for al=1:size(antloc,1)
        text (antloc(al), antmean(antloc(al))+0.2, num2str(antloc(al)))
    end
    %     plot(x(antloc),antpks,'k^','markerfacecolor',rgb('red'));
    plot(tagmean,'Color',rgb('blue'));
    plot(tagloc, tagmean(tagloc),'*k')
    for tl=1:size(tagloc,1)
        text (tagloc(tl), tagmean(tagloc(tl))+0.2, num2str(tagloc(tl)))
    end
    %     plot(x(tagloc),tagpks,'k^','markerfacecolor',rgb('green'));
    hold off
    subplot(2,2,3),imshow(dilSkelD),hold on,imshow(Antpic),alpha(0.65);
    %     text(-10, -10,['headup : ' num2str(headup) '/ ' num2str(NBranchpoints) ' branchpoints']);
    text(20, 5,['headup : ' num2str(headup)])
    text(20, 15,[num2str(NBranchpoints) ' branchpoints']);
    text(20, 25,[num2str(nAntPeaks) ' antpeaks']);
    text(20, 35,[num2str(nTagPeaks) ' tagpeaks']);
    hold on
end

end