% ASLtbx_resetimgorg.m
% function for reseting the mat file or the mat matrix so the origin will
% be in the center of the image box. 
% Latest modification: images converted using different software may get
% flipped using SPM "reset orientation" button or our original image reset
% function. This bug was fixed by trials and errors but is now fixed.  June 27 2015
% Ze Wang. All rights reserved. Hangzhou Normal University
function ASLtbx_resetimgorg(P)
if nargin==0, P=spm_select; end
filenum=size(P,1);
v=spm_vol(P);
[pth,nam,ext,num] = spm_fileparts(P(1,:));
for i=1:size(v,1)
    if filenum==1
        if size(v,1)>1
            imgfilename=[fullfile(pth, nam) ext ',' num2str(i)];
        else
            imgfilename=P;
        end
    else
        imgfilename=P(i,:);
    end
    M    = v(i).mat;
    vox  = sqrt(sum(M(1:3,1:3).^2));
    smat=abs(M(1:3,1:3));
    [mv,loc]=max(smat,[],1);
    [mv,locoff]=max(smat,[],2);
    % get the right sign for vox
    if M(loc(1),1)<0, vox(1)=-vox(1); end
    if M(loc(2),2)<0, vox(2)=-vox(2); end
    if M(loc(3),3)<0, vox(3)=-vox(3); end
    % be careful for using the following lines: this will only
    % work if the data were acquired or saved from right to
    % left, from anterior to posterio and inferior to superior
%     vox(1)=-abs(vox(1));
%     vox(2)=-abs(vox(2));

    orig = (v(i).dim(1:3)+1)/2;
    off  = -vox.*orig;
    M    = [0      0      0      off(locoff(1))
        0      0      0      off(locoff(2))
        0      0      0      off(locoff(3))
        0      0      0      1];
    M(loc(1),1)=vox(1);
    M(loc(2),2)=vox(2);
    M(loc(3),3)=vox(3);
    
    spm_get_space(imgfilename,M);
end