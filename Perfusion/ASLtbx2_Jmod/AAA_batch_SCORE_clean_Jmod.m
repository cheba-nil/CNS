

global PAR;

parfor sb = 1:PAR.Nids % for each subject

    fprintf('SCORE cleaning for subject #%g ... %g subjects left...\n',sb,(PAR.Nids-sb))
    % for c=1:PAR.ncond
        P =  spm_select('ExtFPList', PAR.imgs4ASLtbxFolder{sb}, ['^cbf_.*\.nii'], 1:900 );
%         maskimg=spm_select('FPList', PAR.condirs{sb,c}, ['^brainmask\.nii']);
        c1img=spm_select('FPList', PAR.imgs4ASLtbxFolder{sb}, ['^rbk_c1.*\.nii$']);
        c2img=spm_select('FPList', PAR.imgs4ASLtbxFolder{sb}, ['^rbk_c2.*\.nii$']);
        c3img=spm_select('FPList', PAR.imgs4ASLtbxFolder{sb}, ['^rbk_c3.*\.nii$']);
        SCORE_denoising(P,c1img,c2img,c3img,0.95)
    % end
end