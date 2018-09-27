% File: ASLtbx_spmcoreg.m
% using spm for registering source and allimgs to target.
function [output]=ASLtbx_spmcoreg(target, source, allimgs)
target=deblank(target(1,:));
VG = spm_vol(target);
defaults=spm_get_defaults;
flags = defaults.coreg;
source=source(1,:);
VF = spm_vol(source);
x  = spm_coreg(VG, VF,flags.estimate);

%get the transformation to be applied with parameters 'x'
M  = inv(spm_matrix(x));
%transform the mean image
%spm_get_space(deblank(PG),M);
%in MM we put the transformations for the 'other' images
MM = zeros(4,4,size(allimgs,1));
for im=1:size(allimgs,1),
    %get the transformation matrix for every image
    MM(:,:,im) = spm_get_space(deblank(allimgs(im,:)));
end
for im=1:size(allimgs,1),
    %write the transformation applied to every image
    %filename: deblank(PO(j,:))
    spm_get_space(deblank(allimgs(im,:)), M*MM(:,:,im));
end
output=allimgs;
return;