% Function that will return only the max n peaks, for use in directionality
% and in finding tags
% Molly Liu, 3/5/14

function [pks,loc,nPeaks] = findMaxPeaks(pixmean,n,minpeakheight,minpeakdist)

[totpks,totloc] = findpeaks(pixmean,'MINPEAKHEIGHT',minpeakheight,'MINPEAKPROMINENCE',0.1,'MINPEAKDISTANCE',minpeakdist);
% last term (min peak prominence) added on 12/18/15

nPeaks=size(totloc,1);

% Sort by descending height to find the highest n peaks
[hipks,pkindex] = sort(totpks,'descend');
if length(hipks) > n
    pks1 = hipks(1:n);
    index = pkindex(1:n);
else
    pks1 = hipks;
    index = pkindex;
end
loc1 = totloc(index);

% Sort by ascending loc to return in order of the x axis
[loc,index] = sort(loc1,'ascend');
pks = pks1(index);

end