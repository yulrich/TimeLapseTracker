% uses a simpler form of illumination correction (compared to imCorrect_2.m)
% with(unsaturated) grey bckgd pics instead of white bckgd pics
% No white balance correction, only grey background correction

% Calls: getWhite, WhiteBalance0, ColorConstancy1


function [correct,I] = imCorrect_7(ref,folder,frame)

foundIm=0;

while ~foundIm % keep trying until the image is found (i.e until disk reconnects)
    
white = getWhite_2(folder,ref.greyfileList); % Obtain white image in the directory
I = im2double(imread(ref.fileList{frame,folder})); % Loads image
%figure,imshow(I);
correct = I./(white+eps);
foundIm=1;

end
% correct = WhiteBalanceCrrct_2(correctWhite,ref.transform(:,:,folder)); % Correct color balance


% correct(find(correct > 1)) = 1-eps;
% correct(find(correct < 0)) = 0+eps;

%figure, imshow(correct)
end

