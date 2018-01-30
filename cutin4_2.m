% Yuko : changed the location of the center point compared to Molly's
% version
function  [Im, dim] = cutin4_2(I)

% imshow(I);
% [x,y]=ginput(1);
% x=int64(round(x));
% y=int64(round(y));

center=[1271 970];
margin = 70;
Im{1}=I(1:center(2)+margin,250:center(1)+margin,:);
Im{2}=I(1:center(2)+margin,center(1)-margin:2320,:);
Im{3}=I(center(2)-margin:1944,250:center(1)+margin,:);
Im{4}=I(center(2)-margin:1944,center(1)-margin:2320,:);

dim{1}=size(Im{1});
dim{2}=size(Im{2});
dim{3}=size(Im{3});
dim{4}=size(Im{4});




