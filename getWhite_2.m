
% Yuko's version modified from Molly's getWhite 
% white images organized as color images in a separate folderm retrieved
% using a separate file list (whitefileList, stored in ref)
% Get the white image for a directory
% Called by: ImageCorrection1, imCorrect

function [white] = getWhite_2(folder,whitefileList)

% path=['/Volumes/GS2_AS1_2/14_01_28_18_09_45_wht_bckgd/CAM_' num2str(folder) '/']; 
% 
% 
% focusFolders = dir(strcat(path,'focus_*'));
% focusNames = {focusFolders.name}';
% 
% 
% % Obtain white image in the directory
% headdir = [path focusNames{1}];
% white = dir([headdir '/*.tif']);
% white = im2double(imread([headdir '/' white.name]));

white = im2double(imread(whitefileList{1,folder}));


end