function generateFeatures_forPrediction (ID, subj_dir, CNSP_path, dartelTemplate, ageRange)

csfMasked_seg0_path = strcat (subj_dir, '/', ID, '/mri/kNN_intermediateOutput/', ID, '_accurateCSFmasked_seg0.nii.gz');
csfMasked_seg1_path = strcat (subj_dir, '/', ID, '/mri/kNN_intermediateOutput/', ID, '_accurateCSFmasked_seg1.nii.gz');
csfMasked_seg2_path = strcat (subj_dir, '/', ID, '/mri/kNN_intermediateOutput/', ID, '_accurateCSFmasked_seg2.nii.gz');
seg0_nii_ventricleRemoved = load_nii (csfMasked_seg0_path);
seg1_nii_ventricleRemoved = load_nii (csfMasked_seg1_path);
seg2_nii_ventricleRemoved = load_nii (csfMasked_seg2_path);

flair_path_char = ls (strcat (subj_dir, '/', ID, '/mri/preprocessing/FAST_nonBrainRemoved_wr', ID, '_*_restore.nii.gz'));
flair_path_cell = cellstr(flair_path_char);
flair_path = flair_path_cell{1};
flair_nii = load_nii (flair_path);

% used intensity normalised T1
t1_path_char = ls (strcat (subj_dir, '/', ID, '/mri/kNN_intermediateOutput/', ID, '_wT1_NBTR_FAST_restore.nii.gz'));
t1_path_cell = cellstr (t1_path_char);
t1_path = t1_path_cell{1};
t1_nii = load_nii (t1_path);

switch dartelTemplate
    case 'existing template'
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

    case 'creating template'
        GM_average_mask_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_GM_probability_map_thr0_8.nii.gz']);
        WM_average_mask_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_WM_probability_map_thr0_8.nii.gz']);
        WM_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_WM_probability_map.nii']);
        GM_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_GM_probability_map.nii']);
        CSF_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_CSF_probability_map.nii']);

end

                           
Vent_distanceMap_nii = load_nii ([CNSP_path ...
                                '/Templates' ...
                                '/DARTEL_ventricle_distance_map' ...
                                '/DARTEL_ventricle_distance_map.nii.gz']);
                            
                            
% indWMnoCSF_path_char = ls (strcat (subj_dir, '/', ID, '/mri/kNN_intermediateOutput/', ID, '_accurateCSFmasked_OATSaverageWM.nii.gz'));
% indWMnoCSF_path_cell = cellstr (indWMnoCSF_path_char);
% indWMnoCSF_path = indWMnoCSF_path_cell{1};
% individualAccCSFmasked_WMaverageMaskNii = load_nii (indWMnoCSF_path);


%%%%%%%%%%%%%%%%%%%%
% change data type %
%%%%%%%%%%%%%%%%%%%%
seg0_nii_img_ventricleRemoved = cast (seg0_nii_ventricleRemoved.img,'double');
seg1_nii_img_ventricleRemoved = cast (seg1_nii_ventricleRemoved.img,'double');
seg2_nii_img_ventricleRemoved = cast (seg2_nii_ventricleRemoved.img,'double');
flair_nii_img = cast (flair_nii.img, 'double');
t1_nii_img = cast (t1_nii.img, 'double');
GM_average_mask_nii_img = cast (GM_average_mask_nii.img, 'double');
WM_average_mask_nii_img = cast (WM_average_mask_nii.img, 'double');
WM_prob_map_nii_img = cast (WM_prob_map_nii.img, 'double');
GM_prob_map_nii_img = cast (GM_prob_map_nii.img, 'double');
CSF_prob_map_nii_img = cast (CSF_prob_map_nii.img, 'double');
Vent_distanceMap_nii_img = cast (Vent_distanceMap_nii.img, 'double');
% WM_average_mask_nii_img_accCSFapplied = cast (individualAccCSFmasked_WMaverageMaskNii.img, 'double');
% view_nii(WM_average_mask_nii);
% view_nii(individualAccCSFmasked_WMaverageMaskNii);


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
seg0Clusters = bwconncomp(seg0_nii_img_ventricleRemoved, 6);  % 6-connected neighborhood
seg1Clusters = bwconncomp(seg1_nii_img_ventricleRemoved, 6);
seg2Clusters = bwconncomp(seg2_nii_img_ventricleRemoved, 6);
seg_NumOfClusters = cat (2, seg0Clusters.NumObjects, seg1Clusters.NumObjects, seg2Clusters.NumObjects);

seg0ClustersLableMatrix = cast(labelmatrix (seg0Clusters),'double'); % lable each cluster (first cluster as 1, second as 2...)
seg1ClustersLableMatrix = cast(labelmatrix (seg1Clusters),'double');
seg2ClustersLableMatrix = cast(labelmatrix (seg2Clusters),'double');
save_nii(make_nii (seg0ClustersLableMatrix),strcat(subj_dir, '/', ID, '/mri/extractedWMH/temp/', ID, '_seg0.nii'));
save_nii(make_nii (seg1ClustersLableMatrix),strcat(subj_dir, '/', ID, '/mri/extractedWMH/temp/', ID, '_seg1.nii'));
save_nii(make_nii (seg2ClustersLableMatrix),strcat(subj_dir, '/', ID, '/mri/extractedWMH/temp/', ID, '_seg2.nii'));
% imshow3Dfull (seg2ClustersLableMatrix);
allSegClustersLableMatrix = cat (4, seg0ClustersLableMatrix, seg1ClustersLableMatrix, seg2ClustersLableMatrix); % concatenate cluster lable maps to a vector
%clusterMask (size(nii_img),Clusters.NumObjects);


%%%%%%%%%%%%%%%%%%%%%%%%%
% delete existing files %
%%%%%%%%%%%%%%%%%%%%%%%%%
clusterLookup = strcat (subj_dir, '/', ID, '/mri/extractedWMH/temp/', ID, '_clusterLookUp_4prediction.txt');
if exist(clusterLookup, 'file')==2
  delete(clusterLookup);
end

feature_path = strcat (subj_dir, '/', ID, '/mri/extractedWMH/temp/', ID, '_feature_4prediction.txt');
if exist(feature_path, 'file')==2
  delete(feature_path);
end


%%%%%%%%%%%%%%%%%%%%%%
% calculate features %
%%%%%%%%%%%%%%%%%%%%%%

featureCellArr = cell ((seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)+seg_NumOfClusters(1,3)), 12);
lookUpCellArr = cell ((seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)+seg_NumOfClusters(1,3)), 2);

for j = 1:3 % seg0-2
    fprintf ('UBO Detector: calculating features for ID %s (%d clusters in Seg%d) ...\n', ID, seg_NumOfClusters(1,j), (j-1));
    for i = 1:seg_NumOfClusters(1,j) % exhaust all clusters

        clusterMask = cast ((allSegClustersLableMatrix (:,:,:,j) == i), 'double');
        % feature5 = nnz(clusterMask);  %%%%%%%%%%%%%%% FEATURE 5 %%%%%%%%%%%%%%%
        
        clusterMasked_flair = clusterMask .* flair_nii_img; % apply cluster mask to FLAIR
        clusterMasked_t1 = clusterMask .* t1_nii_img; % apply cluster mask to T1
        clusterMasked_flair_mean = mean(nonzeros(clusterMasked_flair)); % mean intensity in the cluster on FLAIR
        clusterMasked_t1_mean = mean(nonzeros(clusterMasked_t1)); % mean intensity in the cluster on T1
        clusterMasked_flair_sd = std (cast(nonzeros(clusterMasked_flair),'double')); % SD of the intensity in the cluster
        clusterCentroid = regionprops(clusterMask,'Centroid');
        % rounded_clusterCentroid = round(clusterCentroid.Centroid);
        % FEATURE 6, looked at corresponding WM average mask value (after applying accurate CSF). 
        % Note: regionprops(__,'Centroid') returns x,y,z of the centroid. When indexing an array, use the order of y(row),x(col),z. 
        % feature6 = WM_prob_map_nii_img(rounded_clusterCentroid(1,2),rounded_clusterCentroid(1,1),rounded_clusterCentroid(1,3)); 
        % mean intensity on WM prob map as Feature 6
        
        % Intensity features
        feature1 = (clusterMasked_t1_mean)/(MI_GM_t1); %%%%%%%%% FEATURE 1 %%%%%%%%%%%%%
        feature2 = (clusterMasked_flair_mean)/(MI_GM_flair); %%%%%%%%% FEATURE 2 %%%%%%%%%%%%%
        feature3 = (clusterMasked_t1_mean)/(MI_WM_t1); %%%%%%%%% FEATURE 3 %%%%%%%%%%%%%
        feature4 = (clusterMasked_flair_mean)/(MI_WM_flair); %%%%%%%%% FEATURE 4 %%%%%%%%%%%%%
        
        % cluster size
        feature5 = log10(nnz(clusterMask));  %%%%%%%%%%%%%%% FEATURE 5 lg-transformed cluster size %%%%%%%%%%%%%%%
        
        % GM, WM, CSF probability and distance to ventricles (nonzeros
        % mean)
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
        
%         disp (clusterMasked_flair_mean);      
        
        if j == 1
            % seg0
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
            lookUpCellArr{i,1} = 0;
            lookUpCellArr{i,2} = i;
        elseif j == 2
            % seg1
            featureCellArr{(i+seg_NumOfClusters(1,1)),1} = feature1;
            featureCellArr{(i+seg_NumOfClusters(1,1)),2} = feature2;
            featureCellArr{(i+seg_NumOfClusters(1,1)),3} = feature3;
            featureCellArr{(i+seg_NumOfClusters(1,1)),4} = feature4;
            featureCellArr{(i+seg_NumOfClusters(1,1)),5} = feature5;
            featureCellArr{(i+seg_NumOfClusters(1,1)),6} = feature6;
            featureCellArr{(i+seg_NumOfClusters(1,1)),7} = feature7;
            featureCellArr{(i+seg_NumOfClusters(1,1)),8} = feature8;
            featureCellArr{(i+seg_NumOfClusters(1,1)),9} = feature9;
            featureCellArr{(i+seg_NumOfClusters(1,1)),10} = feature10;
            featureCellArr{(i+seg_NumOfClusters(1,1)),11} = feature11;
            featureCellArr{(i+seg_NumOfClusters(1,1)),12} = feature12;
            lookUpCellArr{(i+seg_NumOfClusters(1,1)),1} = 1;
            lookUpCellArr{(i+seg_NumOfClusters(1,1)),2} = i;            
        elseif j == 3
            % seg2
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),1} = feature1;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),2} = feature2;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),3} = feature3;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),4} = feature4;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),5} = feature5;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),6} = feature6;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),7} = feature7;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),8} = feature8;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),9} = feature9;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),10} = feature10;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),11} = feature11;
            featureCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),12} = feature12;
            lookUpCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),1} = 2;
            lookUpCellArr{(i+seg_NumOfClusters(1,1)+seg_NumOfClusters(1,2)),2} = i; 
        end

               
    end
end


featureTbl = cell2table (featureCellArr);
lookUpTbl = cell2table (lookUpCellArr);


writetable (featureTbl, ...
            feature_path, ...
            'WriteVariableNames', false, ...
            'WriteRowNames', false, ...
            'Delimiter', ' '...
            );
        
writetable (lookUpTbl, ...
            clusterLookup, ...
            'WriteVariableNames', false, ...
            'WriteRowNames', false, ...
            'Delimiter', ' '...
            );
