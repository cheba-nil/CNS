function ASLtbx_splitsiemenspasl(imgfile)
%   Copyright by Ze Wang
%   Ze Wang @CCBD HNU 2014
%   redhatw@gmail.com
% 
%
% Reference: Ze Wang, Geoffrey K. Aguirre, Hengyi Rao, Jiongjiong Wang,
% Maria A. Fernandez-Seara, Anna R. Childress, and John A. Detre, Epirical
% optimization of ASL data analysis using an ASL data processing toolbox:
% ASLtbx, Magnetic Resonance Imaging, 2008, 26(2):261-9.
mo=fullfile(spm_str_manip(imgfile(1,:),'H'),['M0' spm_str_manip(imgfile,'ts') '.nii']);
v=spm_vol(imgfile(1,:));
dat=spm_read_vols(v);
v.fname=mo;
v=spm_write_vol(v,dat);
v=spm_vol(imgfile);
data=spm_read_vols(v);
n4dfile=fullfile(spm_str_manip(imgfile,'H'),[spm_str_manip(imgfile,'ts') '_split.nii']);
for im=2:size(v,1)
    vo=v(im);
    vo.fname=n4dfile;
    vo.n=[im-1 1];
    dat=squeeze(data(:,:,:,im));
    vo=spm_write_vol(vo,dat);
end

