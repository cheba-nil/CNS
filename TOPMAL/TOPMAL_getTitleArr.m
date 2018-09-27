function titleArr = TOPMAL_getTitleArr (atlasCode)

TOPMAL_path = fileparts (which (mfilename));


switch atlasCode
    case 'JHU-ICBM_WM_tract_prob_1mm'
        NatlasVol = 20;
        titleArr = cell (1, (3*NatlasVol+3));
        
        titleArr{1,1} = 'ID';
        
        for i = 0:19
             [~, anatomy]= system (['grep -w JHU' num2str(i) ' ' TOPMAL_path '/Volume-Anatomy-mapping.txt | awk ''{print $2}'' | tr -d ''\n''']);
             titleArr{1,(i+2)} = [anatomy '_absLoading'];
             titleArr{1,(i+NatlasVol+2)} = [anatomy '_fraLoading'];
             titleArr{1,(i+2*NatlasVol+2)} = [anatomy '_Nvox'];
        end

        titleArr{1,3*NatlasVol+2} = 'N_complete_void_vox';
        titleArr{1,3*NatlasVol+3} = 'totalVoidLoading_partialVoidVox';
        
    case 'HO_subcortical_1mm'
        NatlasVol = 21;
        titleArr = cell (1, (3*NatlasVol+3));
        
        titleArr{1,1} = 'ID';
        
        for i = 0:20
            [~, anatomy] = system (['grep -w HO' num2str(i) ' ' TOPMAL_path '/Volume-Anatomy-mapping.txt | awk ''{print $2}'' | tr -d ''\n''']);
            titleArr{1,(i+2)} = [anatomy '_absLoading'];
            titleArr{1,(i+NatlasVol+2)} = [anatomy '_fraLoading'];
            titleArr{1,(i+2*NatlasVol+2)} = [anatomy '_Nvox'];
        end

        titleArr{1,3*NatlasVol+2} = 'N_complete_void_vox';
        titleArr{1,3*NatlasVol+3} = 'totalVoidLoading_partialVoidVox';
end