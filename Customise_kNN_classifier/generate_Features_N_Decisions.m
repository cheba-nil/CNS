function generate_Features_N_Decisions (ID, studyFolder, VisModImg, dartelTemplate, ageRange)

global CNSP_path

% copy modified image to extractedWMH/manuallyModified
if exist ([studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified'],'dir') == 7
    rmdir ([studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified'],'s');
end

mkdir ([studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified']);
copyfile (VisModImg,[studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified']);


% generate nonWMH images
system (['chmod +x ' CNSP_path '/Customise_kNN_classifier/generateNonWMHimg_fromVisAdj.sh']);
system ([CNSP_path '/Customise_kNN_classifier/generateNonWMHimg_fromVisAdj.sh ' VisModImg ' ' ID ' ' studyFolder]);


seg0_nonWMH_cell = cellstr(ls ([studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified/' ID '_seg0_nonWMH*']));
seg0_nonWMH = seg0_nonWMH_cell{1};

seg1_nonWMH_cell = cellstr(ls ([studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified/' ID '_seg1_nonWMH*']));
seg1_nonWMH = seg1_nonWMH_cell{1};

seg2_nonWMH_cell = cellstr(ls ([studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified/' ID '_seg2_nonWMH*']));
seg2_nonWMH = seg2_nonWMH_cell{1};

% load images
visModImg = load_nii (VisModImg);
seg0_nonWMH = load_nii (seg0_nonWMH);
seg1_nonWMH = load_nii (seg1_nonWMH);
seg2_nonWMH = load_nii (seg2_nonWMH);

flair_path_char = ls (strcat (studyFolder, '/customiseClassifier/subjects/', ID, '/mri/preprocessing/FAST_nonBrainRemoved_wr', ID, '_*_restore.nii*'));
flair_path_cell = cellstr(flair_path_char);
flair_path = flair_path_cell{1};
flair_nii = load_nii (flair_path);

t1_path_char = ls (strcat (studyFolder, '/customiseClassifier/subjects/', ID, '/mri/kNN_intermediateOutput/', ID, '_wT1_NBTR_FAST_restore.nii.gz'));
t1_path_cell = cellstr (t1_path_char);
t1_path = t1_path_cell{1};
t1_nii = load_nii (t1_path);

switch dartelTemplate
    case 'existing'
        GM_average_mask_nii = load_nii ([CNSP_path ...
                                        '/Templates/DARTEL_GM_WM_CSF_prob_maps/' ...
                                        ageRange ...
                                        '/DARTEL_GM_prob_map_thr0_8.nii.gz']);

        WM_average_mask_nii = load_nii ([CNSP_path ...
                                        '/Templates/DARTEL_GM_WM_CSF_prob_maps/' ...
                                        ageRange ...
                                        '/DARTEL_WM_prob_map_thr0_8.nii.gz']);

        WM_prob_map_nii = load_nii ([CNSP_path ...
                                    '/Templates/DARTEL_GM_WM_CSF_prob_maps/' ...
                                    ageRange ...
                                    '/DARTEL_WM_prob_map.nii.gz']);

        GM_prob_map_nii = load_nii ([CNSP_path ...
                                    '/Templates/DARTEL_GM_WM_CSF_prob_maps/' ...
                                    ageRange ...
                                    '/DARTEL_GM_prob_map.nii.gz']);

        CSF_prob_map_nii = load_nii ([CNSP_path ...
                                    '/Templates/DARTEL_GM_WM_CSF_prob_maps/' ...
                                    ageRange ...
                                    '/DARTEL_CSF_prob_map.nii.gz']);
    case 'creating'
        GM_average_mask_nii = load_nii ([studyFolder '/subjects/cohort_probability_maps/cohort_GM_probability_map_thr0_8.nii.gz']);
        WM_average_mask_nii = load_nii ([studyFolder '/subjects/cohort_probability_maps/cohort_WM_probability_map_thr0_8.nii.gz']);
        WM_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_WM_probability_map.nii']);
        GM_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_GM_probability_map.nii']);
        CSF_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_CSF_probability_map.nii']);
end


Vent_distanceMap_nii = load_nii ([CNSP_path ...
                                '/Templates' ...
                                '/DARTEL_ventricle_distance_map' ...
                                '/DARTEL_ventricle_distance_map.nii.gz']);

% indWMnoCSF_path_char = ls (strcat (studyFolder, '/customiseClassifier/subjects/', ID, '/mri/kNN_intermediateOutput/', ID, '_accurateCSFmasked_OATSaverageWM.nii*'));
% indWMnoCSF_path_cell = cellstr (indWMnoCSF_path_char);
% indWMnoCSF_path = indWMnoCSF_path_cell{1};
% individualAccCSFmasked_WMaverageMaskNii = load_nii (indWMnoCSF_path);



%%%%%%%%%%%%%%%%%%%%
% change data type %
%%%%%%%%%%%%%%%%%%%%
visModImg = cast (visModImg.img,'double');
seg0_nonWMHimg = cast (seg0_nonWMH.img, 'double');
seg1_nonWMHimg = cast (seg1_nonWMH.img, 'double');
seg2_nonWMHimg = cast (seg2_nonWMH.img, 'double');

flair_nii_img = cast (flair_nii.img, 'double');
t1_nii_img = cast (t1_nii.img, 'double');
GM_average_mask_nii_img = cast (GM_average_mask_nii.img, 'double');
WM_average_mask_nii_img = cast (WM_average_mask_nii.img, 'double');

GM_prob_map_nii_img = cast (GM_prob_map_nii.img, 'double');
WM_prob_map_nii_img = cast (WM_prob_map_nii.img, 'double');
CSF_prob_map_nii_img = cast (CSF_prob_map_nii.img, 'double');
Vent_distanceMap_nii_img = cast (Vent_distanceMap_nii.img, 'double');
%WM_average_mask_nii_img_accCSFapplied = cast (individualAccCSFmasked_WMaverageMaskNii.img, 'double');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WM/GM region mean intensity on T1 and FLAIR %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flair_WM = flair_nii_img .* (WM_average_mask_nii_img);
flair_GM = flair_nii_img .* (GM_average_mask_nii_img);
t1_WM = t1_nii_img .* (WM_average_mask_nii_img);
t1_GM = t1_nii_img .* (GM_average_mask_nii_img);
MI_WM_flair = mean(nonzeros(flair_WM)); % mean intensity of WM regions on FLAIR
MI_GM_flair = mean(nonzeros(flair_GM)); % mean intensity of GM regions on FLAIR
MI_WM_t1 = mean(nonzeros(t1_WM)); % mean intensity of WM regions on T1
MI_GM_t1 = mean(nonzeros(t1_GM)); % mean intensity of GM regions on T1


%%%%%%%%%%%%%%%%%
% find clusters %
%%%%%%%%%%%%%%%%%
visModImg_clusters_struct = bwconncomp(visModImg, 6);  % 6-connected neighborhood
seg0_nonWMHimg_clusters_struct = bwconncomp (seg0_nonWMHimg, 6);
seg1_nonWMHimg_clusters_struct = bwconncomp (seg1_nonWMHimg, 6);
seg2_nonWMHimg_clusters_struct = bwconncomp (seg2_nonWMHimg, 6);

NumClusters = cat (2, visModImg_clusters_struct.NumObjects, ...
                        seg0_nonWMHimg_clusters_struct.NumObjects, ...
                        seg1_nonWMHimg_clusters_struct.NumObjects, ...
                        seg2_nonWMHimg_clusters_struct.NumObjects);

visModImgClustersLableMatrix = cast(labelmatrix (visModImg_clusters_struct),'double'); % lable each cluster (first cluster as 1, second as 2...)
seg0nonWMHImgClustersLableMatrix = cast(labelmatrix (seg0_nonWMHimg_clusters_struct),'double');
seg1nonWMHImgClustersLableMatrix = cast(labelmatrix (seg1_nonWMHimg_clusters_struct),'double');
seg2nonWMHImgClustersLableMatrix = cast(labelmatrix (seg2_nonWMHimg_clusters_struct),'double');

allClusters = cat (4, visModImgClustersLableMatrix, ...
                        seg0nonWMHImgClustersLableMatrix, ...
                        seg1nonWMHImgClustersLableMatrix, ...
                        seg2nonWMHImgClustersLableMatrix);

save_nii(make_nii (visModImgClustersLableMatrix),[studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified/', ID, '_WMH_labelledClusters.nii']); % save labelled image
save_nii(make_nii (seg0nonWMHImgClustersLableMatrix),[studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified/', ID, '_seg0nonWMH_labelledClusters.nii']);
save_nii(make_nii (seg1nonWMHImgClustersLableMatrix),[studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified/', ID, '_seg1nonWMH_labelledClusters.nii']);
save_nii(make_nii (seg2nonWMHImgClustersLableMatrix),[studyFolder '/customiseClassifier/subjects/' ID '/mri/extractedWMH/manuallyModified/', ID, '_seg2nonWMH_labelledClusters.nii']);



%%%%%%%%%%%%%%%%%%%%%%%%%
% delete existing files %
%%%%%%%%%%%%%%%%%%%%%%%%%

clusterLookup = [studyFolder '/customiseClassifier/textfiles/', ID, '_lookUp_forTraining_VisAdj.txt'];
finaldecision = [studyFolder '/customiseClassifier/textfiles/', ID, '_decision_forTraining_VisAdj_unequalYN.txt'];
finalfeature = [studyFolder '/customiseClassifier/textfiles/', ID, '_feature_forTraining_VisAdj_unequalYN.txt'];


if exist(finaldecision, 'file')==2
  delete(finaldecision);
end

if exist(finalfeature, 'file')==2
  delete(finalfeature);
end


if exist(clusterLookup, 'file')==2
  delete(clusterLookup);
end

featureCellArr = cell ((NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)+NumClusters(1,4)), 12);
decisionCellArr = cell ((NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)+NumClusters(1,4)), 1);
lookUpCellArr = cell ((NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)+NumClusters(1,4)), 3);

%%%%%%%%%%%%%%%%%%%%%%
% calculate features %
%%%%%%%%%%%%%%%%%%%%%%

for j = 1:4
fprintf ('Calculating %s features to train kNN classifier (%d clusters, %d-conncected neighbours)\n', ...
                ID, NumClusters(1,j), visModImg_clusters_struct.Connectivity);
            
    for i = 1:NumClusters(1,j) % exhaust all clusters

        clusterMask = cast ((allClusters (:,:,:,j) == i), 'double');
        % feature5 = nnz(clusterMask);  %%%%%%%%%%%%%%% FEATURE 5 %%%%%%%%%%%%%%%
        
        clusterMasked_flair = clusterMask .* flair_nii_img; % apply cluster mask to FLAIR
        clusterMasked_t1 = clusterMask .* t1_nii_img; % apply cluster mask to T1
        clusterMasked_flair_mean = mean(nonzeros(clusterMasked_flair)); % mean intensity in the cluster on FLAIR
        clusterMasked_t1_mean = mean(nonzeros(clusterMasked_t1)); % mean intensity in the cluster on T1
        clusterMasked_flair_sd = std (cast(nonzeros(clusterMasked_flair),'double')); % SD of the intensity in the cluster
        clusterCentroid = regionprops(clusterMask,'Centroid');
        
        % intensity features
        feature1 = (clusterMasked_t1_mean)/(MI_GM_t1); %%%%%%%%% FEATURE 1 %%%%%%%%%%%%%
        feature2 = (clusterMasked_flair_mean)/(MI_GM_flair); %%%%%%%%% FEATURE 2 %%%%%%%%%%%%%
        feature3 = (clusterMasked_t1_mean)/(MI_WM_t1); %%%%%%%%% FEATURE 3 %%%%%%%%%%%%%
        feature4 = (clusterMasked_flair_mean)/(MI_WM_flair); %%%%%%%%% FEATURE 4 %%%%%%%%%%%%%
        
        % cluster size
        feature5 = log10(nnz(clusterMask));  %%%%%%%%%%%%%%% FEATURE 5 lg-transformed cluster size %%%%%%%%%%%%%%%
        
        % GM/WM/CSF probability, and distance to ventricles (nonzeros mean)
%         feature6 = mean(nonzeros(GM_prob_map_nii_img .* clusterMask));
%         feature7 = mean(nonzeros(WM_prob_map_nii_img .* clusterMask));
%         feature8 = mean(nonzeros(CSF_prob_map_nii_img .* clusterMask));
%         feature9 = mean(nonzeros(Vent_distanceMap_nii_img .* clusterMask));
                
        % GM, WM, CSF probability and distance to ventricles (cluster mean)
        feature6 = sum(nonzeros(GM_prob_map_nii_img .* clusterMask)) / nnz(clusterMask);
        feature7 = sum(nonzeros(WM_prob_map_nii_img .* clusterMask)) / nnz(clusterMask);
        feature8 = sum(nonzeros(CSF_prob_map_nii_img .* clusterMask)) / nnz(clusterMask);
        feature9 = sum(nonzeros(Vent_distanceMap_nii_img .* clusterMask)) / nnz(clusterMask);
        
        
        % cluster centroid coordinate
        feature10 = clusterCentroid.Centroid(1,2); % centroid x coordinate
        feature11 = clusterCentroid.Centroid(1,1); % centroid y coordinate
        feature12 = clusterCentroid.Centroid(1,3); % centroid z coordinate

  
        if j == 1
            % modified Yes clusters
            featureCellArr{i,1} = feature1;
            featureCellArr{i,2} = feature2;
            featureCellArr{i,3} = feature3;
            featureCellArr{i,4} = feature4;
            featureCellArr{i,5} = feature5;
            featureCellArr{i,6} = feature6;
            featureCellArr{i,7} = feature7;
            featureCellArr{i,8} = feature8;
            featureCellArr{i,9} = feature9;
            featureCellArr{i,10} = feature10;
            featureCellArr{i,11} = feature11;
            featureCellArr{i,12} = feature12;
            decisionCellArr{i,1} = 'Yes';
            lookUpCellArr{i,1} = ID;
            lookUpCellArr{i,2} = 0;
            lookUpCellArr{i,3} = i;
        elseif j == 2
            % non-WMH clusters in seg0
            featureCellArr{(i+NumClusters(1,1)),1} = feature1;
            featureCellArr{(i+NumClusters(1,1)),2} = feature2;
            featureCellArr{(i+NumClusters(1,1)),3} = feature3;
            featureCellArr{(i+NumClusters(1,1)),4} = feature4;
            featureCellArr{(i+NumClusters(1,1)),5} = feature5;
            featureCellArr{(i+NumClusters(1,1)),6} = feature6;
            featureCellArr{(i+NumClusters(1,1)),7} = feature7;
            featureCellArr{(i+NumClusters(1,1)),8} = feature8;
            featureCellArr{(i+NumClusters(1,1)),9} = feature9;
            featureCellArr{(i+NumClusters(1,1)),10} = feature10;
            featureCellArr{(i+NumClusters(1,1)),11} = feature11;
            featureCellArr{(i+NumClusters(1,1)),12} = feature12;
            decisionCellArr{(i+NumClusters(1,1)),1} = 'No';
            lookUpCellArr{(i+NumClusters(1,1)),1} = ID;
            lookUpCellArr{(i+NumClusters(1,1)),2} = 1;
            lookUpCellArr{(i+NumClusters(1,1)),3} = i;            
        elseif j == 3
            % non-WMH clusters in seg1
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),1} = feature1;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),2} = feature2;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),3} = feature3;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),4} = feature4;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),5} = feature5;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),6} = feature6;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),7} = feature7;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),8} = feature8;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),9} = feature9;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),10} = feature10;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),11} = feature11;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),12} = feature12;
            decisionCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),1} = 'No';
            lookUpCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),1} = ID;
            lookUpCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),2} = 2;
            lookUpCellArr{(i+NumClusters(1,1)+NumClusters(1,2)),3} = i; 
        elseif j == 4
            % non-WMH clusters in seg2
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),1} = feature1;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),2} = feature2;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),3} = feature3;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),4} = feature4;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),5} = feature5;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),6} = feature6;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),7} = feature7;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),8} = feature8;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),9} = feature9;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),10} = feature10;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),11} = feature11;
            featureCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),12} = feature12;
            decisionCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),1} = 'No';
            lookUpCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),1} = ID;
            lookUpCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),2} = 3;
            lookUpCellArr{(i+NumClusters(1,1)+NumClusters(1,2)+NumClusters(1,3)),3} = i;             
        end
    end
end

featureTbl = cell2table (featureCellArr);
decisionTbl = cell2table (decisionCellArr);
lookUpTbl = cell2table (lookUpCellArr);


writetable (featureTbl, ...
            finalfeature, ...
            'WriteVariableNames', false, ...
            'WriteRowNames', false, ...
            'Delimiter', ' '...
            );
        
writetable (decisionTbl, ...
            finaldecision, ...
            'WriteVariableNames', false, ...
            'WriteRowNames', false...
            );
        
writetable (lookUpTbl, ...
            clusterLookup, ...
            'WriteVariableNames', false, ...
            'WriteRowNames', false, ...
            'Delimiter', ' '...
            );





% whether to equlize the number of Yes/No
equalYNdecision = getappdata (0, 'equalYN');

decision_forTraining_unequalYN = finaldecision;
feature_forTraining_unequalYN = finalfeature;
lookup_forTraining_unequalYN = clusterLookup;
decision_forTraining = [studyFolder '/customiseClassifier/textfiles/' ID '_decision_forTraining_VisAdj_final.txt'];
feature_forTraining = [studyFolder '/customiseClassifier/textfiles/' ID '_feature_forTraining_VisAdj_final.txt'];
lookup_forTraining = [studyFolder '/customiseClassifier/textfiles/' ID '_lookUp_forTraining_VisAdj_final.txt'];

if exist (decision_forTraining,'file') == 2
    delete (decision_forTraining);
end

if exist (feature_forTraining,'file') == 2
    delete (feature_forTraining);
end

if exist (lookup_forTraining,'file') == 2
    delete (lookup_forTraining);
end

if strcmp(equalYNdecision, '1')
    
    TrainingDecisionUnequal = importdata (decision_forTraining_unequalYN);
    TrainingFeatureUnequal = importdata (feature_forTraining_unequalYN);
    TrainingLookupUnequal = importdata (lookup_forTraining_unequalYN);
    
    TrainingDecisionUnequal_No_idx = find (strcmp (TrainingDecisionUnequal (:), 'No'));
    TrainingDecisionUnequal_Yes_idx = find (strcmp (TrainingDecisionUnequal (:), 'Yes'));
    
    TrainingFeatureUnequal_No_entries = TrainingFeatureUnequal (TrainingDecisionUnequal_No_idx,:);
    TrainingFeatureUnequal_Yes_entries = TrainingFeatureUnequal (TrainingDecisionUnequal_Yes_idx,:);
    TrainingDecisionUnequal_No_decisions = TrainingDecisionUnequal(TrainingDecisionUnequal_No_idx);
    TrainingDecisionUnequal_Yes_decisions = TrainingDecisionUnequal(TrainingDecisionUnequal_Yes_idx);
    TrainingLookupUnequal_No_clusterLookup = TrainingLookupUnequal(TrainingDecisionUnequal_No_idx,:);
    TrainingLookupUnequal_Yes_clusterLookup = TrainingLookupUnequal(TrainingDecisionUnequal_Yes_idx,:);
    
    
    [Y_Nrow, Y_Ncol] = size (TrainingDecisionUnequal_Yes_idx);
    [N_Nrow, N_Ncol] = size (TrainingDecisionUnequal_No_idx);
    
    if N_Nrow >= Y_Nrow % more NO than YES
        rand_N_idx = reshape(randperm (N_Nrow,Y_Nrow), [Y_Nrow,1]); % random "YES" number of "NO", and convert to verticle array
        TrainingFeatureUnequal_No_randomlyPicked = TrainingFeatureUnequal_No_entries (rand_N_idx,:);
        TrainingDecisionUnequal_No_randomlyPicked = TrainingDecisionUnequal_No_decisions (rand_N_idx,:);
        TrainingLookupUnequal_No_randomlyPicked = TrainingLookupUnequal_No_clusterLookup (rand_N_idx,:);
        % write to file
        fprintf('Write to text output ...\n');
        finaldecision = vertcat (TrainingDecisionUnequal_Yes_decisions, TrainingDecisionUnequal_No_randomlyPicked);
        finalfeature = vertcat (TrainingFeatureUnequal_Yes_entries, TrainingFeatureUnequal_No_randomlyPicked);
        finallookup = vertcat (TrainingLookupUnequal_Yes_clusterLookup, TrainingLookupUnequal_No_randomlyPicked);
        
        writetable (cell2table (finaldecision), decision_forTraining, 'WriteVariableNames', 0);
        dlmwrite (feature_forTraining, finalfeature);
        writetable (cell2table (finallookup), lookup_forTraining, 'WrteVariableNames', 0);
        
    else  % more YES than NO
        % In most of the cases NO is much more than YES. If YES is
        % more than NO, and equalYN is true, we keep the original number of
        % YES's and NO's, as we do not want to lose positives.
        fprintf ('Write to text output ...\n');
        copyfile (decision_forTraining_unequalYN, decision_forTraining);
        copyfile (feature_forTraining_unequalYN, feature_forTraining);
        copyfile (lookup_forTraining_unequalYN, lookup_forTraining);
    end
    
else
    fprintf('Write to text output ...\n');
    copyfile (decision_forTraining_unequalYN, decision_forTraining);
    copyfile (feature_forTraining_unequalYN, feature_forTraining);
    copyfile (lookup_forTraining_unequalYN, lookup_forTraining);
end
