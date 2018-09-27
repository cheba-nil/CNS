par;

fprintf('%s\n',repmat(sprintf('-'),1,30))
fprintf('Set Origin\n');

% epiorg   functional origins
% t1org      t1 origins

PAR.subs(1).cond(1).epiorg= [-3.1 21.8 -4.4];      %sub1
PAR.subs(1).t1org = [-2.9 22.5 -2.9];

PAR.subs(2).cond(1).epiorg= [-3.4 13.0 -13.7];      %sub2
PAR.subs(2).t1org = [-2.9 4.0 -12.3];

PAR.subs(3).cond(1).epiorg= [-1.7 22.5 -10.2];      %sub3
PAR.subs(3).t1org = [0.0 30.1 -14.9];



for sb = 1:PAR.nsubs % for each subject
    %go get the sessions
    str   = sprintf('sub #%3d/%3d: %-5s',sb,PAR.nsubs,PAR.subjects{sb});
    fprintf('\r%-40s  %30s',str,' ')
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...seting epi')  %-#

    %now get all images to reset orientation
    %prepare directory
    P=[];
    for c=1:PAR.ncond
        
        % get files in this directory
        Ptmp=spm_select('FPList', char(PAR.condirs{sb,c}), ['^'  PAR.confilters{c} '\w*\.img$']);
        P=strvcat(P,Ptmp);
          Ptmp=spm_select('FPList', char(PAR.M0dirs{sb,c}), ['^' PAR.M0filters{c} '\w*\.img$']);
        P=strvcat(P,Ptmp);
        
        
        if strcmp(P(1,:),'/'),continue;end;
        
        if ~isempty(PAR.subs(sb).cond(c).epiorg)
            st.B=cat(2, -1*(PAR.subs(sb).cond(c).epiorg), [0 0 0 1 1 1 0 0 0]);
            %-----------------------------------------------------------------------
            mat = spm_matrix(st.B);
            if det(mat)<=0
                spm('alert!','This will flip the images',mfilename,0,1);
            end;
            Mats = zeros(4,4,size(P,1));
            spm_progress_bar('Init',size(P,1),'Reading current orientations',...
                'Images Complete');
            for i=1:size(P,1),
                Mats(:,:,i) = spm_get_space(P(i,:));
                spm_progress_bar('Set',i);
            end;
            spm_progress_bar('Init',size(P,1),'Reorienting images',...
                'Images Complete');
            for i=1:size(P,1),
                spm_get_space(P(i,:),mat*Mats(:,:,i));
                spm_progress_bar('Set',i);
            end;
            spm_progress_bar('Clear');
        end
    end

    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'seting epi done')  %-#
    str   = sprintf('sub #%3d/%3d: %-5s',sb,PAR.nsubs,PAR.subjects{sb} );
    fprintf('\r%-40s  %30s',str,' ')
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...seting T1')  %-#

    if ~isempty(PAR.subs(sb).t1org)
        st.B=cat(2, -1*PAR.subs(sb).t1org, [0 0 0 1 1 1 0 0 0]);
        mat = spm_matrix(st.B);
        P=[];
        Ptmp=spm_select('FPList', char(PAR.structdir{sb}), ['^' PAR.structprefs '\w*.img$']);
        P=strvcat(P,Ptmp);
        if strcmp(P(1,:),'/'),continue;end;
        Mats = zeros(4,4,size(P,1));
        for i=1:size(P,1),
            Mats(:,:,i) = spm_get_space(P(i,:));
        end;
        for i=1:size(P,1),
            spm_get_space(P(i,:),mat*Mats(:,:,i));
        end;
    end
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'seting T1  done')  %-#
end



