function linindxpixlist = getpixlist(blobs,labelfieldname,Nblobs)
% this function finds for each blob in the structure 'blobs' the list of
% corresponding pixels.
% The 'LabelMatrixOutputPort' of the system object should be set to true
% and the resulting label matrix should be stored in the field 'labelfieldname'
% of the structure 'blobs'
% It's probably a good idea to store the results in 'blobs'.
% for instance: blobs.linindxpixlist = getpixlist(blobs,'label');
% Nblob is the number of blobs 'blobs'.
% Molly: whoa thank you Jonathan!!
% ahaha no worries.
% maybe you can change the cell if you don't like it...
% imshow(label2rgb(blobs.label)) provides a (useful) image with every blob
% with a different color. and it's pretty

linindxpixlist = cell(Nblobs,1); 
for nb = 1:Nblobs
    linindxpixlist{nb} = find(blobs.(labelfieldname) == nb);
end