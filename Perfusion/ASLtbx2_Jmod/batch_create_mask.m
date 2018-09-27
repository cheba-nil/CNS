% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
% Batch calculation for the perfusion signals.

global PAR
par;
for sb = 1:PAR.nsubs % for each subject
    clear P;
    for c=1:PAR.ncond
        % creating a mask image for removing background
        dir_fun = PAR.condirs{sb,1};
        PF=spm_select('ExtFPList',PAR.condirs{sb,c},['^mean' PAR.confilters{1} '\w*\.img$'],1:200);
        if size(PF,1)<1
            fprintf('No mean images for subject %s!\n',PAR.subjects{sb});
            continue;
        end
        PF=PF(1,:);
        vm=spm_vol(PF);
        dat=spm_read_vols(vm);
        mask=dat>0.2*max(dat(:));
        vo=vm;
        [path,name,ext]=fileparts(PF);
        vo.fname=fullfile(path,'mask_perf_cbf.img');
        vo=spm_write_vol(vo,mask);
    end
end