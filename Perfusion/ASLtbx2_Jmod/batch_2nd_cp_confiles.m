% Move contrasts to analyze and manage them

% load subject etc details

disp('Congratuations! Ready to perform group analysis!');
org_pwd=pwd;

%2nd level-analisis dir
group_dir = fullfile(PAR.root,PAR.groupdir);
if ~exist(group_dir)
    mdir=['!mkdir ' group_dir];
    eval(mdir);
end
for i=1:length(PAR.con_names)
    conf_dir=fullfile(PAR.root,PAR.groupdir,PAR.con_names{i});
    if ~exist(conf_dir)
        mdir=['!mkdir ' conf_dir];
        eval(mdir);
    else
        cd(conf_dir);
        !rm -fr con*
    end

    %copy contrasts
    for sub=1:PAR.nsubs
        ana_dir = fullfile(PAR.root,PAR.subjects{sub},PAR.ana_dir);
        source_file=spm_select('FPList',ana_dir,['^con_00\w*\.img$']);
        source_file=spm_str_manip(source_file,'s');
        dest_file=fullfile(conf_dir,['con_' PAR.subjects{sub}  '_' num2str(sub)]);
        if isunix
            cpf=['!cp -f ' source_file '.img ' dest_file '.img'];
            eval(cpf);
            cpf=['!cp -f ' source_file '.hdr ' dest_file '.hdr'];
            eval(cpf);
        else
            copyfile([source_file '.img '], [dest_file '.img'],'f');
            copyfile([source_file '.hdr '], [dest_file '.hdr'],'f');
        end
    end
end  %end for each contrast

cd(org_pwd);