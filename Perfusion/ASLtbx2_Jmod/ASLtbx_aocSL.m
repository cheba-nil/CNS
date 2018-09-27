function [oidx]=ASLtbx_aocSL(cbfimgs, c1img, c2img, maskimg, th, motionfile, imgs2clean)
% Adaptive outlier cleaning (AOC) for ASL CBF quantification.
% AOC should be applied after the perfusion subtraction. It is designed to adaptively remove 
%    outlier ASL CBF acquisition timepoints and get the cleaned result.
% please cite:
% Ze Wang, Sandhitsu R. Das, Sharon X. Xie, Steven E. Arnold, John A. Detre, David A. Wolk, for the Alzheimer's Disease Neuroimaging Initiative, 
%   Arterial Spin Labeled MRI in Prodromal Alzheimer's Disease: A Multi-Site Study, Neuroimage: clinical, 2, 630?636, 2013.
% 
% input arguments:  
%   cbfimgs: file names for CBF images
%   c1img: GM tissue probability map (should have the same size as the cbfimgs)
%   c2img: WM tissue probability map (should have the same size as the cbfimgs)
%   maskimg: image mask file used for selecting voxels of interest for calculating the similarity between each CBF map and the mean map. This file should have the 
%            same dimension as that of the CBF image series
%            if no mask is provide, a rough mask will be generated from the images provided.
%   th: threshold for identifying outliers, default is 0.17
%   iter: number of iterations for AOC. Default is 2
% output: oidx - IDs for all identified outliers
% Ze Wang. 2013 @ Upenn.    zewang@mail.med.upenn.edu   redhatw@gmail.com
% this version do aoc slice by slice but conditioned on std of the current slice.  
CBFcutoff=5;
if nargin<1,
   fprintf('Please provide images to be cleaned!\n');
   fprintf('For example:\n');
   fprintf('cbfimgs=spm_select;\n');
   fprintf('aoc(cbfimgs);\n');
   return;
end
ERRTH=3; % 3/60=0.05  5%
if ~exist('th', 'var')  th=1; end
v=spm_vol(cbfimgs);

% read in CBF images.	
orgdat=spm_read_vols(v);
orgdat(isnan(orgdat(:)))=0;
Xdim=size(orgdat,1);
Ydim=size(orgdat,2);
Zdim=size(orgdat,3);
Tdim=size(orgdat,4);

zeroidx=[1:2 (Zdim-1):Zdim];
% get mask
if ~isempty(maskimg)
   vm=spm_vol(maskimg);
   mask=spm_read_vols(vm);
   mask=mask>0;
else
   mask=squeeze(mean(orgdat,4));
   mask=mask>5;  % this is an empirical value, assume normal brain tissue should have CBF>5.   
end
bmask=mask;

bmask(:,:,zeroidx)=0;
% read prior image
vc1=spm_vol(c1img);
c1dat=spm_read_vols(vc1);
c1mask=c1dat>0.4;

vc2=spm_vol(c2img);
c2dat=spm_read_vols(vc2);
c2mask=c2dat>0.8;

pcbf=(c1dat*1.8+c2dat)*10;
c1mask=(c1mask.*bmask)>0;
c2mask=(c2mask.*bmask)>0;
dat=reshape(orgdat,Xdim*Ydim*Zdim,Tdim);
ndat=dat(bmask(:),:);
gs=mean(ndat,1);
gsidx= (gs>mean(gs)+3*std(gs) ) | (gs<mean(gs)-3*std(gs));
% motion
if exist('motionfile', 'var')
    mot=spm_load(motionfile);
    mot=mot(1:2*Tdim, 1:6);
    difmot=abs(mot(2:2:end,:)-mot(1:2:end,:));
    difidx= difmot>repmat(median(difmot), Tdim, 1)+repmat(3*std(difmot), Tdim, 1);
    difidx=sum(difidx, 2)>0;
    gsidx=gsidx|difidx';
end
nou_mg=sum(gsidx);
startingidx=find(gsidx==0);

Tdim=length(startingidx);
% start AOC
sltcmatrix=zeros(Zdim, Tdim);           

if exist('imgs2clean', 'var')
    v=spm_vol(imgs2clean);
    cdat=spm_read_vols(v);
    cdat=cdat(:,:,:, startingidx);
end
dat=orgdat(:,:,:,startingidx);
mcbfallslices=mean(dat,4);
for sl=1:Zdim
    if sl<3
        slidx=sl+[0:2];
        nslidx=1;
    elseif sl==4
        slidx=sl+[-1 0 1];
        nslidx=2;
    elseif sl>Zdim-2
        slidx=sl+[-2 -1 0];
        nslidx=3;
    else
        slidx=sl+[-2 -1 0 1 2];
        nslidx=3;
    end
    nslices=length(slidx);
    neislmask=mask(:,:,slidx);
    slpcbf=pcbf(:,:,slidx);
    slpcbf=slpcbf(neislmask(:));
    slpcbf(isnan(slpcbf))=0;
    ollidx=ones(1, Tdim)>0; % all time points should be included initially
    if sum(neislmask(:))>10
        ndat=reshape(dat(:,:, slidx, :), Xdim*Ydim*nslices, Tdim);
        ndat=ndat(neislmask(:), :);

        c2pm=corr(slpcbf, ndat);
        % locate those with negative cc with the pseudo cbf
        nidx=(c2pm<=0);
        mcc=mean(c2pm(nidx==0));  % mean of the remained timepoints
        stdcc=std(c2pm(nidx==0));
        nidx2=(c2pm<=mcc+th*stdcc);
        nidx=find(nidx+nidx2>0);          % mark the suspicious timepoints
        curnidx=nidx;           % ollidx has a fixed length, curnidx doesn't
    else
        nidx=find(ollidx);
        curnidx=nidx;
    end
        
    nb=0;
    slc1mask=squeeze(c1mask(:,:,slidx));
    slc2mask=squeeze(c2mask(:,:,slidx));
    curmcbf=mcbfallslices(:,:, sl);
    slmask=mask(:,:,sl);
    if sum(slmask(:))<10||mean(curmcbf(slmask(:)))<CBFcutoff, 
        continue;
    else
        while nb<length(nidx)         % iterating over all nuisances unless quit in the middle
            curmcbf=mcbfallslices(:,:, slidx);      % mean of the target slices
    %     curmcbf     = reshape(mean(sldat(:,ollidx),2), [Xdim Ydim nslices]); 
            prevc1c2std = std(curmcbf(slc1mask(:)))+ std(curmcbf(slc2mask(:)));
            dc1c2std =-inf*(ones(1, length(curnidx)));

            for it=1:length(curnidx)   
                llidx=ollidx;
                llidx(curnidx(it))=0;  % excluding the current suscipicious timepoint from the data pool.
                slcurmcbf     = reshape(mean(dat(:,:, sl, llidx), 4), [Xdim Ydim]);             % updating mean
                curmcbf(:,:,nslidx) = slcurmcbf; 
                dc1c2std(it)   = prevc1c2std-(std(curmcbf(slc1mask(:)))+std(curmcbf(slc2mask(:))));
    %             drelc1c2std(it)= prestddif-(std(curmcbf(slc1mask(:)))+std(curmcbf(slc2mask(:))));
            end
            % the following part needs further optimization. For example, we can remove the one whose removal improves the cc the most.
            [Y, tI]=sort(dc1c2std, 'descend');          % find the maximum gm-wm std
            % removing the one with the most significant gm-wm std difference improvement for the mean cbf map
            %    if its removal also improves the correlation between mean and the pseudo-cbf
            oi=1; 

            if Y(oi)>0 %& dmc1c2(tI(oi))>contrastratioth % & dmc1c2(tI(1))> 0 % 10 percent
    %             precc=cc2pcbf(tI(oi));
                ollidx(curnidx(tI(oi)))=0;        % curnidx is the index of suscipicious timepoints
                curnidx(tI(oi))=0;                % set the tI(oi)-item of curnidx to be 0
                curnidx=curnidx(curnidx>0);       % remove index of the most significant outlier. curnidx saves locations of the remained outliers
                nb=nb+1;
                slcurmcbf     = reshape(mean(dat(:,:, sl, ollidx), 4), [Xdim Ydim]);             % updating mean
                mcbfallslices(:,:,sl) = slcurmcbf; 
            else 
                break;
            end
        end
    end
%     if exist('imgs2clean', 'var')
%         mcbf(:,:,sl)=reshape(mean(cdat(:,:,sl,ollidx),4), [Xdim Ydim]);         
%     else
%         mcbf(:,:,sl)=reshape(mean(dat(:,:,sl,ollidx),4), [Xdim Ydim]);   
%     end
    oidx=find(ollidx==0); 
    sltcmatrix(sl, ollidx==0)=1;   % 1 means outliers
%     fprintf('AOC3 slicewise. %d outliers found in aoc.\n ', nou_mg+length(oidx));
end
% if one timepoint was marked as outlier for most of slices, it will be
% removed for all slices. If one timepoint was labeled as outlier by 1 or 2
% slices, it will not be treated as an outlier
tc_om=sum(sltcmatrix, 1);
commonol=(tc_om>floor(0.9*Zdim));
ncom_ol=(tc_om<2);
ncom_2 =find(tc_om<max(2,ceil(0.2*Zdim)) );
nmat=zeros(size(sltcmatrix));
nmat(:, ncom_2)=sltcmatrix(:, ncom_2);
dnmat=diff(nmat, 1, 1);
true_ncom_2=sum(abs(dnmat),1)>sum(nmat,1);    % not marked by successive slices
sltcmatrix(:, commonol)=1;                    % remove them from all slices  
sltcmatrix(:, ncom_ol) =0;                    % release the outlier label
sltcmatrix(:, true_ncom_2) =0;
mcbf=zeros(Xdim, Ydim, Zdim);
for sl=1:Zdim
    ollidx=sltcmatrix(sl, :)==0;
    if exist('imgs2clean', 'var')
        mcbf(:,:,sl)=reshape(mean(cdat(:,:,sl,ollidx),4), [Xdim Ydim]);         
    else
        mcbf(:,:,sl)=reshape(mean(dat(:,:,sl,ollidx),4), [Xdim Ydim]);   
    end
end
vo=v(1);
vo.fname=fullfile(spm_str_manip(vo.fname,'H'),['cmeanCBF_SL_' num2str(nou_mg+max(tc_om)) '.nii']);
vo=spm_write_vol(vo,mcbf);

