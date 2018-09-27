
for sb = 1:PAR.nsubs % for each subject

    sprintf('Calculate perfusion and CBF signals for subject #%g ... %g subjects left...\n',sb,length(PAR.subjects)-sb)
    for c=1:PAR.ncond
        P =  spm_select('ExtFPList', PAR.condirs{sb,c}, ['^cbf_.*\.nii'], 1:900 );
%         maskimg=spm_select('FPList', PAR.condirs{sb,c}, ['^brainmask\.nii']);
        c1img=spm_select('FPList', PAR.structdir{sb}, ['^rbk_c1.*\.nii$']);
        c2img=spm_select('FPList', PAR.structdir{sb}, ['^rbk_c2.*\.nii$']);
        c3img=spm_select('FPList', PAR.structdir{sb}, ['^rbk_c3.*\.nii$']);
        SCORE_denoising(P,c1img,c2img,c3img,0.95)
    end
end