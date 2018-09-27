function [reconout,noimgout,indxout]=SCORE_denoising(cbfimgs,c1img,c2img,c3img,thresh)

% SCORE_denoising: performs Structural Correlation based Outlier REjection.
% Input:
%   cbfimgs: CBF time series, either series of 3D volumes
%   or one 4D volume
%   c1img: GM tissue probability map (should have the same size as the cbfimgs)
%   c2img: WM tissue probability map (should have the same size as the cbfimgs)
%   c3img: CSF tissue probability map (should have the same size as the cbfimgs)
%   thresh: Threshold to create gm, wm and csf masks from tpms, default =
%   0.95. If TPMs are smoothed, then set a smaller threshold, e.g. 0.75
%
% Output:
%   recon: Estimated mean CBF map
%   noimg: Number of volumes retained
%   indx: Index file;  0: volumes retained for the mean CBF computation
%                      1: volumes rejected based on GM threshold
%                      2: volumes rejected based on structural correlation
% Additional:
%   1: Saves the mean CBF map using SCORE as a nifti file with the
% name "SCORE" added as a prefix to the filename
%   2: Saves the index file containing information about which volumes are
%   retained and which ones are discarded based on GM threshold and
%   structural correlation criterion
%
% Report any bug to Sudipto Dolui: sudiptod@mail.med.upenn.edu



if ~exist('cbfimgs','var')||isempty(cbfimgs)
    cbfimgs=spm_select(Inf,'image','Select CBF volumes',[],pwd,'.nii',1:1000);
end
if isempty(cbfimgs)
    fprintf('No CBF time series file provided, exiting without running SCORE...\n');
    return
end

if ~exist('c1img','var')||isempty(c1img)
    c1img=spm_select(1,'image','Select c1 image in native space',[],pwd,'.nii',1);
end

if ~exist('c2img','var')||isempty(c2img)
    c2img=spm_select(1,'image','Select c2 image in native space',[],pwd,'.nii',1);
end

if ~exist('c3img','var')||isempty(c3img)
    c3img=spm_select(0:1,'image','Select c3 image in native space',[],pwd,'.nii',1);
end

if ~exist('thresh','var')||isempty(thresh)
    thresh = 0.95;
end

dat = spm_read_vols(spm_vol(cbfimgs));
[xD,yD,zD,TD]=size(dat);

tpmfiles = strvcat(c1img,c2img,c3img);

flagtpm = 0; % Will check if tpm files are in native space
tpm = spm_read_vols(spm_vol(tpmfiles));
[xtpm,ytpm,ztpm,~]=size(tpm);
if norm([xD,yD,zD]-[xtpm,ytpm,ztpm])~=0
    flagtpm=1;
end

if flagtpm == 1
    tpm = mean(dat,4)~=0;
end

tpm = tpm>thresh;  % Creating tissue probability masks
msk=sum(tpm,4)>0;  % Creating mask for computing correlation


%%%% Discarding CBF volumes outside 2.5 standard deviation of mean
MnGM=zeros(TD,1);
for tdim=1:TD
    cbfvol=dat(:,:,:,tdim);
    MnGM(tdim)=mean(cbfvol(tpm(:,:,:,1)));
end
MedMnGM=median(MnGM);           % Robust estimation of mean
SDMnGM=mad(MnGM,1)/0.675;       % Robust estimation of standard deviation
indx=double(abs(MnGM-MedMnGM)>2.5*SDMnGM);    % Volumes outside 2.5 SD of Mean are discarded

counttpm = zeros(size(tpm,4),1);
for k=1:size(tpm,4)
    tpmvol = tpm(:,:,:,k);
    counttpm(k) = sum(tpmvol(:)>0)-1;
end
R=mean(dat(:,:,:,indx==0),4);
V=0;
for k=1:length(counttpm)
    if counttpm(k)>0
        V=V+counttpm(k)*var(R(tpm(:,:,:,k)));
    end
end
V_prev=V+1;

%%%% Discarding CBF volumes based on structural correlation
while (V<V_prev)&&(sum(indx==0)>1)
    V_prev=V;
    R_prev=R;
    indx_prev=indx;
    CC=-2*ones(TD,1);
    for tdim=1:TD
        if(indx(tdim)~=0)
            continue;
        end
        cbfvol=dat(:,:,:,tdim);
        CC(tdim)=corr(R(msk),cbfvol(msk));
    end
    [~,inx]=max(CC);
    indx(inx)=2;
    R=mean(dat(:,:,:,indx==0),4);
    
    V=0;
    for k=1:length(counttpm)
        if counttpm(k)>0
            V=V+counttpm(k)*var(R(tpm(:,:,:,k)));
        end
    end
end

recon=R_prev;
indx=indx_prev;
noimg=sum(indx==0);

v=spm_vol(cbfimgs(1,:));
v=v(1);
v.fname=fullfile(spm_str_manip(v.fname,'H'),['SCORE_' spm_str_manip(v.fname,'ts') '.nii']);
spm_write_vol(v,recon);

save(fullfile(spm_str_manip(v.fname,'H'),['SCORE_indx_' spm_str_manip(v.fname,'ts') '.mat']),'indx');

if nargout > 0
    reconout = recon;
end
if nargout > 1
    noimgout = noimg;
end
if nargout >2
    indxout = indx;
end

