function TOPMAL_summariseOutputInCohort_UDver (studyFolder, atlasCode, atlasProbThr, excldList, varargin)

switch atlasCode
    case 'JHU-ICBM_WM_tract_prob_1mm'
        atlasNvol = 20;
        atlasAbb = 'JHUwm';
    case 'HO_subcortical_1mm'
        atlasNvol = 21;
        atlasAbb = 'HOsub';
end

T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
[Nsubj,~] = size (T1folder);

excldIDs = strsplit (excldList, ' ');

cohortOutput = cell ((Nsubj + 1), (atlasNvol*3 + 3));

titleArr = TOPMAL_getTitleArr (atlasCode);
cohortOutput(1,:) = titleArr;

for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    if ismember(ID, excldIDs) == 0
        % read csv
        if nargin == 4
            subjectOutput = csvread([studyFolder '/subjects/' ID '/stats/' ID '_TOPMAL_' atlasAbb '_' atlasProbThr '.dat']);
        elseif (nargin == 5) && strcmp (varargin{1}, 'allprob')
            subjectOutput = csvread([studyFolder '/subjects/' ID '/mri/TOPMAL/' ID '_lesionOn_' atlasAbb '_allprob.dat']);
        end
        
        cohortOutput{(i+1),1} = ID;
        cohortOutput((i+1),2:(atlasNvol+1)) = num2cell (subjectOutput (:,1));
        cohortOutput((i+1),(atlasNvol+2):(2*atlasNvol+1)) = num2cell (subjectOutput (:,2));
        cohortOutput((i+1),(2*atlasNvol+2):(end-2)) = num2cell (subjectOutput(:,3));
        cohortOutput((i+1),(end-1):end) = num2cell (subjectOutput(1,4:5)); % number of complete void voxels. 
                                                                           % The 4th column should be identical, 
                                                                           % so used row 1 col 4.
                                                                           % Ditto for total void loading of partial void vox
                                                                           % row 1 col 5.
    else
        cohortOutput{(i+1),1} = ID;
        cohortOutput((i+1),2:end) = cellstr ('EXCLD');
    end
end


% write to output
cohortOutputTBL = cell2table (cohortOutput);

if exist ([studyFolder '/subjects/TOPMAL_' atlasAbb '_' atlasProbThr '.txt'], 'file') == 2
    delete ([studyFolder '/subjects/TOPMAL_' atlasAbb '_' atlasProbThr '.txt']);
end

writetable (cohortOutputTBL, ...
            [studyFolder '/subjects/TOPMAL_' atlasAbb '_' atlasProbThr '.txt'], ...
            'FileType', 'text', ...
            'WriteVariableNames', false, ...
            'WriteRowNames', false, ...
            'Delimiter', ','...
            );
        
if nargin == 5 && strcmp (varargin{1}, 'allprob')
    system (['mv ' studyFolder '/subjects/TOPMAL_' atlasAbb '_' atlasProbThr '.txt ' ...
                studyFolder '/subjects/TOPMAL_' atlasAbb '_allprob.txt']);
end
