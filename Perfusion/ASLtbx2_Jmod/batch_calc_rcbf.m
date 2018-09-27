% Toolbox for batch processing ASL perfusion based fMRI data.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
% Batch calculation for the perfusion signals.

for sb = 1:PAR.nsubs  % for each subject

    sprintf('Calculate perfusion and CBF signals for subject #%g ... %g subjects left...\n',sb,length(PAR.subjects)-sb)
    for c=1:PAR.ncond

        P =  spm_select('FPList', PAR.condirs{sb,c}, ['^meanCBF.*\.nii'] );
       
        maskimg=spm_select('FPList', PAR.condirs{sb,c}, ['^brainmask\.nii']);
        vm=spm_vol(maskimg);
        mask=spm_read_vols(vm);
        mask=mask>0;
        
	    v=spm_vol(P);
        dat=spm_read_vols(v);
        gs=mean(dat(mask(:)));
        dat=dat/gs;
        vo=v;
        vo.n=[1 1];
        vo.fname=fullfile(PAR.condirs{sb,c}, 'rmeanCBF.nii');
        vo=spm_write_vol(vo, dat);
        
        fprintf('\n%40s%30s','',' ');
    end
end

