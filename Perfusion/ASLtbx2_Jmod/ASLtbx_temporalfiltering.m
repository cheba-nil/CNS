function   ASLtbx_temporalfiltering(P, maskimg, hcutoff, opt, maskimgs)
% temporal filtering. Assuming the ASL images are acquired in an order of label control label control ...
% opt -- if not set, just regress out motions
%      -- 1: regress out global signal
%      -- 2: regress out nuisances to be defined by the first mask image in the array: maskimgs
%      -- 3: regress out global signal and other nuisances (to be defined by the mask images, eg, csf or white matter signal)
%      -- 
if isempty(P), fprintf('Input images don''t exist!\n'); return; end;
[pth,nam,ext,num] = spm_fileparts(P(1,:));
% getting the motion correction results. Assuming it is located in the same folder as the images
 movefil = spm_select('FPList', pth, ['^rp_.*\w*.*\.txt$']);
 moves = spm_load(movefil);
 % reading data
 v=spm_vol(P);
 dat=spm_read_vols(v);
 [sx,sy,sz,st]=size(dat);
 dat(isnan(dat))=0;
 mimg=squeeze(mean(dat,4));
 dat=dat - repmat(mimg, [1, 1, 1, st]);
 if nargin<2 || isempty(maskimg)
     mask=mimg>0.23*max(mimg(:));
else    
     vm=spm_vol(maskimg);
     mask=spm_read_vols(vm);
     mask=mask>0;
end

orgdat=reshape(dat, sx*sy*sz, st);
gs=mean(orgdat(mask(:), :), 1);
if nargin==3
    cutoffh=hcutoff;
end
if nargin== 4 
    if isempty(maskimgs), nui=gs; 
    else
	    if opt==2
	       vm1=spm_vol(maskimgs(1,:));
	       mask1=spm_read_vols(vm1);
	       mask1=mask1>0;
	       nui = orgdat(mask1(:), :);
	    else
	       NN=size(maskimgs,1);
	       vm1=spm_vol(maskimgs);
	       mask1=spm_read_vols(vm1);
	       mask1=mask1>0;
	       mask1=reshape(mask1, sx*sy*sz, NN);
	       for nn=1:NN
	           nui=[nui; orgdat(mask1(:, nn), :)];
           end
        end
    end
else
     nui=[];	    
end
%  define the zigzag pattern
% ref=-ones(st,1);  
% ref(2:2:end)=1;
nui=[moves nui];      % concatenate motion timecourses and the other nuisances
mnui=mean(nui, 2);
nui = nui - repmat(mnui, 1, size(nui,2));
% nui = nui - ref/(ref'*ref)*ref'*nui;      % clean up the zigzag pattern
[u,s,vec]=svd(nui);
Nnui=size(nui,2);    % number of nuisance vectors
% taking the first several eigen vectors which usually accounts for >90% of the variance
if Nnui>6
    nu=u(:, 1:6);
elseif Nnui>2
    nu=u(:, 1:2);    
elseif Nnui==1
    nu=u;
end    
%  regressing out the nuisances
dat=orgdat(mask(:), :);      %  only process the intracranial voxels
dat=dat-(dat*nu*nu');
nmat=mean(dat,2);
dat=dat-repmat(nmat,1,st);
[lb,la]=fltbutter(1, cutoffh);    % if TR=2, omega=1~1/2TR =0.25 (fMax)
dat=filter(lb,la,dat,[],2);

[lb,la]=fltbutter(1,0.04,'high');  % high pass  
dat=filter(lb,la,dat,[],2); 
dat=repmat(nmat, 1, st) + dat;
orgdat(mask(:), :) = dat;
orgdat=reshape(orgdat, [sx sy sz st]);
orgdat=repmat(mimg, [1, 1, 1, st]) + orgdat;
% saving the filtered data
vo=v(1);
vo.fname=fullfile(pth, ['flt_' nam '.nii']); 
vo.dt=[16 1];
for im=1:st
    vo.n=[im 1];
    vo=spm_write_vol(vo, squeeze(orgdat(:,:,:, im)));
end
return;