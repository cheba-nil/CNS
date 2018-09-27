function [oidx]=ASLtbx_aoc(cbfimgs, motionfile, maskimg, th, iter)
% Adaptive outlier cleaning (AOC) for ASL CBF quantification.
% AOC should be applied after the perfusion subtraction. It is designed to adaptively remove 
%    outlier ASL CBF acquisition timepoints and get the cleaned result.
% please cite:
% Ze Wang, Sandhitsu R. Das, Sharon X. Xie, Steven E. Arnold, John A. Detre, David A. Wolk, for the Alzheimer¡¯s Disease Neuroimaging Initiative, 
%   Arterial Spin Labeled MRI in Prodromal Alzheimer¡¯s Disease: A Multi-Site Study, Neuroimage: clinical, 2, 630¨C636, 2013.
% 
% input arguments:  
%   cbfimgs: file names for CBF images
%   motionfile: head motions estimated after motion correction. If motionfile is empty, the first outlier cleaning section will be skipped.
%           in scripts, assume the motion correction output is saved in current folder, you can use the following sentence to get motionfile
%           motionfile = spm_select('FPList', pwd, ['^rp_\w*.*\.txt$']);
%   maskimg: image mask file used for selecting voxels of interest for calculating the similarity between each CBF map and the mean map. This file should have the 
%            same dimension as that of the CBF image series
%            if no mask is provide, a rough mask will be generated from the images provided.
%   th: threshold for identifying outliers, default is 0.17
%   iter: number of iterations for AOC. Default is 2
% output: oidx - IDs for all identified outliers
% Ze Wang. 2013 @ Upenn.    zewang@mail.med.upenn.edu   redhatw@gmail.com

if nargin<1,
   fprintf('Please provide images to be cleaned!\n');
   fprintf('For example:\n');
   fprintf('cbfimgs=spm_select;\n');
   fprintf('aoc(cbfimgs);\n');
   return;
end
if nargin<2,   motionfile=[]; end
if nargin<3,   maskimg=[];   end
if nargin<4,   th=0.17; end
if nargin<5,   iter=2; end

v=spm_vol(cbfimgs);
nsca=size(v,1);
if ~isempty(motionfile)
	movefil=motionfile(1,:);
	moves = spm_load(motionfile);
	% if you were using spm_realign_asl.m
	if size(moves, 2)>6
	  moves=moves(:,7:12);
	end
	moves(:, 4:6)=moves(:, 4:6)*180/pi;
	% Note: the head motions are estimated from the L/C images, so they have double the timepoints of CBF images.
	avgmov=((moves(2:2:nsca*2,:)+moves(1:2:nsca*2,:))/2);
  relmov=(moves(2:2:nsca*2,:)-moves(1:2:nsca*2,:));
  crelmov=mean(abs(relmov),2);
  cavgmov=mean(abs(avgmov),2);
  th1=mean(crelmov)+std(crelmov);
  th2=mean(cavgmov)+2*std(cavgmov);
  loc=(crelmov>th1)+(cavgmov>th2);
else
  loc=zeros(nsca, 1);
end  

% read in CBF images.	
dat=spm_read_vols(v);
dat(isnan(dat(:)))=0;
Xdim=size(dat,1);
Ydim=size(dat,2);
Zdim=size(dat,3);
Tdim=size(dat,4);

% get mask
if ~isempty(maskimg)
   vm=spm_vol(maskimg);
   mask=spm_read_vols(vm);
   mask=mask>0;
else
   mask=squeeze(mean(dat,4));
   mask=mask>5;  % this is an empirical value, assume normal brain tissue should have CBF>5.   
end
dat=reshape(dat,Xdim*Ydim*Zdim,Tdim);
  
dat=dat(mask(:),:);
% calculate the global CBF
gs=mean(dat,1);
gs=gs';
loc=loc+ (gs<5);  
loc=loc>0;
tl=ones(Tdim,1);
tl(loc)=0;
[mgs, ml]=max(gs);
gidx=find(gs>120);
% removing the extremely high gs point
for ml=1:length(gidx)
    if gs(gidx(ml)) > (mean(gs)+std(gs)) 
        tl( gidx(ml) )=0;
    end
end
tl=tl>0;
% start AOC
            
orgmcbf=mean(dat,2);

aidx=tl;
nidx=0;
for it=1:iter
    aidx=(aidx-nidx')>0;           % recursively removing outliers
     mcbf=mean(dat(:,aidx),2);     % initial guess
     % different from the first version, iteration below is still performed
     % across all images
     for t=1:Tdim
         % calculating mapwise correlation between each image and the current average map
         c2m(t)=corr(mcbf,dat(:,t));        
     end

     nidx=c2m<th;
                     
     if sum(nidx)<1, break; end
     th=th-0.01;
end
aidx=(tl-nidx')>0;   % Note: for each iteration, the temporary mean map is updated and similarities of all images to the mean are updated too.
                     % it is likely that an outlier identified in previous iteration can be deidentified in later iterations. But you can always
                     % disable this line to simply exclude all identified outliers. I use this line to keep the number of outliers minimal
                     
                     
fprintf('%d images left after ada.\n ', sum(aidx));

mcbf=mean(dat(:,aidx),2);
imgbuf=zeros(Xdim,Ydim,Zdim);

imgbuf(mask(:))=mcbf;

vo=v(1);
vo.fname=fullfile(spm_str_manip(vo.fname,'H'),['cmeanCBF_cleaned.nii']);
vo=spm_write_vol(vo,imgbuf);
oidx=nidx;
