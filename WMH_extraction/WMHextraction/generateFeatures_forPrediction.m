function generateFeatures_forPrediction (ID, subj_dir, template, nsegs)

    tmpf = strcat (subj_dir, '/', ID, '/mri/kNN_intermediateOutput/tmp.nii.gz');

    csfMasked_seg_paths = strings(nsegs,1);
    novent_segs = cell(nsegs,1);
    for i = 1:nsegs
        csfMasked_seg_paths(i) = strcat (subj_dir, '/', ID, ...
            '/mri/kNN_intermediateOutput/',ID, '_accurateCSFmasked_seg',string(i-1),'.nii.gz');
        novent_segs{i} = niftiread(csfMasked_seg_paths(i));
    end

    flair_path_char = ls (strcat (subj_dir, '/', ID, '/mri/preprocessing/FAST_nonBrainRemoved_wr', ID, '_*_restore.nii.gz'));
    flair_path_cell = cellstr(flair_path_char);
    flair_path = flair_path_cell{1};

    flair_nii_img = niftiread (flair_path);

    % used intensity normalised T1
    t1_path_char = ls (strcat (subj_dir, '/', ID, '/mri/kNN_intermediateOutput/', ID, '_wT1_NBTR_FAST_restore.nii.gz'));
    t1_path_cell = cellstr (t1_path_char);
    t1_path = t1_path_cell{1};

    t1_nii_img = niftiread (t1_path);

    GM_average_mask_nii_img = niftiread(template.gm_prob_thr);

    WM_average_mask_nii_img = niftiread(template.wm_prob_thr);

    WM_prob_map_nii_img = niftiread(template.wm_prob);

    GM_prob_map_nii_img = niftiread(template.gm_prob);

    CSF_prob_map_nii_img = niftiread(template.csf_prob);

    Vent_distanceMap_nii_img = niftiread(template.ventricles);
                                
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
    segClusterLabels = cell(nsegs,1);
    for i = 1:nsegs
        segClusters(i) = bwconncomp(novent_segs{i},6); % 6-connected neighborhood
        segClusterLabels{i} = cast(labelmatrix(segClusters(i)),'double');
        niftiwrite(segClusterLabels{i}, strcat(subj_dir, '/', ID, ...
            '/mri/extractedWMH/temp/', ID, '_seg',string(i-1),'.nii'));
        % copy over the correct geometry
        [a,o] = system(['$FSLDIR/bin/fslcpgeom ' char(csfMasked_seg_paths(i)) ' ' subj_dir '/' ID '/mri/extractedWMH/temp/' ID '_seg' char(string(i-1))]);
    end

    % imshow3Dfull (seg2ClustersLabelMatrix);
    allSegClusterLabelMatrix = segClusterLabels{1};
    for i = 2:nsegs
        allSegClusterLabelMatrix = cat(4,allSegClusterLabelMatrix,segClusterLabels{i});
    end
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
    totalClusters=0;
    for i = 1:nsegs
        totalClusters = totalClusters + segClusters(i).NumObjects;
    end

    featureCellArr = cell (totalClusters, 12);
    lookUpCellArr = cell (totalClusters, 2);

    for j = 1:nsegs % seg0-2
        fprintf ('UBO Detector: calculating features for ID %s (%d clusters in Seg%d) ...\n', ...
            ID, segClusters(j).NumObjects, (j-1));

        dim = size(allSegClusterLabelMatrix);

        % create an array of Linked Lists (one for each cluster) 
        n_clusters=segClusters(j).NumObjects;
        java_linked_lists = java.util.ArrayList;
        for k = 1:n_clusters
            java_linked_lists.add(java.util.LinkedList);
        end
        linked_lists = toArray(java_linked_lists);

        % For each cluster, we build a linked list of
        % coordinates which belong to the cluster

        for x = 1:dim(1)
        for y = 1:dim(2)
        for z = 1:dim(3)
            val = allSegClusterLabelMatrix(x,y,z,j);
            if val > 0
                linked_lists(val).add([x,y,z]);
            end
        end
        end
        end

        for i = 1:segClusters(j).NumObjects % exhaust all clusters

            % Initialize some variables we need to use ...
            clusterMask = zeros(dim(1),dim(2),dim(3)); 
            ll = linked_lists(i);
            cluster_size = ll.size();
            t1_values = zeros(1,cluster_size);
            flair_values = zeros(1,cluster_size);
            gm_prob_values = zeros(1,cluster_size);
            wm_prob_values = zeros(1,cluster_size);
            csf_prob_values = zeros(1,cluster_size);
            ventricle_distance_values = zeros(1,cluster_size);

            % Iterate through each of the coordinates belonging to
            % the cluster building lists of relevant values
            for k = 1:cluster_size
                cord = ll.poll();
                x=cord(1);
                y=cord(2);
                z=cord(3);
                clusterMask(x,y,z)=1;
                t1_values(k) = t1_nii_img(x,y,z);
                flair_values(k) = flair_nii_img(x,y,z);
                gm_prob_values(k) = GM_prob_map_nii_img(x,y,z);
                wm_prob_values(k) = WM_prob_map_nii_img(x,y,z);
                csf_prob_values(k) = CSF_prob_map_nii_img(x,y,z);
                ventricle_distance_values(k) = Vent_distanceMap_nii_img(x,y,z);
            end

            % Intensity features
            feature1 = (clusterMasked_t1_mean)/(MI_GM_t1); %%%%%%%%% FEATURE 1 %%%%%%%%%%%%%
            feature2 = (clusterMasked_flair_mean)/(MI_GM_flair); %%%%%%%%% FEATURE 2 %%%%%%%%%%%%%
            feature3 = (clusterMasked_t1_mean)/(MI_WM_t1); %%%%%%%%% FEATURE 3 %%%%%%%%%%%%%
            feature4 = (clusterMasked_flair_mean)/(MI_WM_flair); %%%%%%%%% FEATURE 4 %%%%%%%%%%%%%
            
            % cluster size
            info = niftiinfo(template.wm_prob);
            scale_factor = prod(info.PixelDimensions)/(1.5^3);
            feature5 = log10(cluster_size*scale_factor); %%%%%%%%%%%%%%% FEATURE 5 lg-transformed cluster size %%%%%%%%%%%%%%%
            
            feature6 = mean(gm_prob_values);
            feature7 = mean(wm_prob_values);
            feature8 = mean(csf_prob_values);
            feature9 = mean(ventricle_prob_values);
            feature10 = -1;
            feature11 = -1;
            feature12 = -1;
            
    %         disp (clusterMasked_flair_mean);      
            
            % calculate our offset
            offset = 0;
            for k = 1:(j-1)
                offset = offset + segClusters(k).NumObjects;
            end 
            featureCellArr{offset+i,1} = feature1;
            featureCellArr{offset+i,2} = feature2;
            featureCellArr{offset+i,3} = feature3;
            featureCellArr{offset+i,4} = feature4;
            featureCellArr{offset+i,5} = feature5;
            featureCellArr{offset+i,6} = feature6;
            featureCellArr{offset+i,7} = feature7;
            featureCellArr{offset+i,8} = feature8;
            featureCellArr{offset+i,9} = feature9;
            featureCellArr{offset+i,10} = feature10;
            featureCellArr{offset+i,11} = feature11;
            featureCellArr{offset+i,12} = feature12;
            lookUpCellArr{offset+i,1} = j-1;
            lookUpCellArr{offset+i,2} = i;
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
