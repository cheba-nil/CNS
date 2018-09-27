function ASLtbx_tstd(imgs, maskimg)
% calculating temporal snr and standard deviations
vm=spm_vol(maskimg);
mask=spm_read_vols(vm);
mask=mask(:)>0;
v=spm_vol(imgs);
dat=spm_read_vols(v);
           
vo=vm;
tsnr=zeros(vo.dim(1),vo.dim(2),vo.dim(3));
dat=reshape(dat,vo.dim(1)*vo.dim(2)*vo.dim(3),size(dat,4));
dat=dat(mask,:);
%             tsnr(mask)=mean(dat,2)./std(dat,0,2);
tsnr(mask)=std(dat,0,2);
vo.dt(1)=16;
vo.fname=fullfile(spm_str_manip(maskimg, 'h'),['tSTD_epi_r.nii']);
vo=spm_write_vol(vo,tsnr);

tsnr(mask)=mean(dat,2)./std(dat,0,2);
vo.fname=fullfile(spm_str_manip(maskimg, 'h'),['tsnr_epi_r.nii']);
vo=spm_write_vol(vo,tsnr);

tsnr(mask)=std(dat,0,2)./mean(dat,2);
vo.fname=fullfile(spm_str_manip(maskimg, 'h'),['cv_epi_r.nii']);
vo=spm_write_vol(vo,tsnr);