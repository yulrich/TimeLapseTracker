function vbin = bindbl(v,binsz)
% find the bin to which the value 'v' belongs
vbin =  max(ceil(v/binsz),1);
