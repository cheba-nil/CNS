% Toolbox for batch processing ASL perfusion based fMRI data.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
% Batch calculation for the perfusion signals.

for sb = 1:PAR.nsubs % for each subject

    sprintf('Calculate perfusion and CBF signals for subject #%g ... %g subjects left...\n',sb,length(PAR.subjects)-sb)
    for c=1:PAR.ncond
        P =  spm_select('ExtFPList', PAR.condirs{sb,c}, ['^cbf_.*\.nii'], 1:900 );
        movefile = spm_select('FPList', PAR.condirs{sb,c}, ['^rp_.*\w*.*\.txt$']);
        maskimg=spm_select('FPList', PAR.condirs{sb,c}, ['^brainmask\.nii']);
        c1mask=spm_select('FPList', PAR.structdir{sb}, ['^rbk_c1.*\.nii$']);
        c2mask=spm_select('FPList', PAR.structdir{sb}, ['^rbk_c2.*\.nii$']);
%         c3mask=spm_select('FPList', PAR.structdir{sb}, ['^rc3.*\.nii$']);
        ASLtbx_aocSL(P, c1mask, c2mask, maskimg, 2, movefile, P);
%        [oidx]=ASLtbx_aoc(P, movefile, maskimg, -10.0, 1);
    end
end