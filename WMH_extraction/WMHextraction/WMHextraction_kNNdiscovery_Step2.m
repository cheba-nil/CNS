

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WMHextraction_kNNdiscovery_Step2: kNN calculation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function WMHextraction_kNNdiscovery_Step2 (k, ID, classifier, template, probThr, trainingFeatures1, trainingFeatures2, varargin)

nsegs=3;

switch classifier
    case 'built-in'
        feature4training = strcat (template.CNS_path, '/WMH_extraction/4kNN_classifier/feature_forTraining.txt');
        decision4training = strcat (template.CNS_path, '/WMH_extraction/4kNN_classifier/decision_forTraining.txt');
    case 'customised'
        feature4training = [template.studyFolder '/customiseClassifier/textfiles/feature_forTraining.txt'];
        decision4training = [template.studyFolder '/customiseClassifier/textfiles/decision_forTraining.txt'];
end

if exist (decision4training, 'file') == 2
    if exist (feature4training, 'file') == 2
        
        %% generate features for prediction
        if nargin == 7
            generateFeatures_forPrediction (ID, [template.studyFolder '/subjects'], template);
        elseif (nargin >= 8) && strcmp(varargin{1},'noGenF')
            % no need to generate features
        elseif (nargin >= 8) && ~strcmp(varargin{1},'noGenF')
            generateFeatures_forPrediction (ID, [template.studyFolder '/subjects'], template);
        end


        %% build kNN model
        if (nargin == 7) || ((nargin == 8) && strcmp(varargin{1},'noGenF'))
            int_kNN_mdl = build_kNN_classifier (k,feature4training, decision4training, trainingFeatures1);
        elseif nargin > 8 && strcmp(varargin{1},'noGenF')
            int_kNN_mdl = build_kNN_classifier (k,feature4training, decision4training, trainingFeatures1, varargin{2:end});
        elseif nargin > 7 && ~strcmp(varargin{1},'noGenF')
            int_kNN_mdl = build_kNN_classifier (k,feature4training, decision4training, trainingFeatures1, varargin{:});
        end

        
        %% examine the quality of the kNN model
        rloss = resubLoss(int_kNN_mdl); % Examine the resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of Mdl.
        CVMdl = crossval(int_kNN_mdl); % Construct a cross-validated classifier from the model.
        kloss = kfoldLoss(CVMdl); % Examine the cross-validation loss, which is the average loss of each cross-validation model when predicting on data that is not used for training.
        
        fprintf('UBO Detector: resubstitution loss of the kNN model is %1.4f\n',rloss);
        fprintf('UBO Detector: cross-validation loss of the kNN model is %1.4f\n',kloss);

        %% predict
        predictionTBL_path = [template.studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_feature_4prediction.txt'];
        predictionTBL = importdata(predictionTBL_path, ' ');
%         [label, score, cost] = predict (kNN_mdl, predictionTBL);
        [label, score, cost] = predict (int_kNN_mdl, predictionTBL(:,trainingFeatures1));
        

        %% saved seg012 clusters with label ID
        seg_lablIDs = cell(nsegs,1)
        for i = 1:nsegs
            seg_lablIDs{i} = nifitread([template.studyFolder,'/subjects', ...
                ID,'/mri/extractedWMH/temp/',ID,'_seg',i-1,'.nii']);
            seg_max(i) = max(max(max(seg_lablIDs{i})));
        end
        
        
        seg012_max = seg_max(1); 
        seg012_combined4D = seg_lablIDs{1};
        for i = 2:nsegs
            seg012_max = cat (2, seg012_max, seg_max(i));
            seg012_combined4D = cat (4, seg012_combined4D, seg_lablIDs{i});
        end
        
        clear seg_lablIDs;
        
        
%         seg012_combined4D_label = seg012_combined4D; % duplicate for assigning different values
        seg012_combined4D_score = seg012_combined4D;
        
        clear seg012_combined4D;
        
        %% probability map
        fprintf (['UBO Detector: generating WMH score map (i.e. WMH probability map) for ' ID ' ...\n']);

        offset = 0;
        for i = 1:nsegs
            score_cell {i} = score (1+offset:offset+seg_max(i),2);
            offset = offset + seg_max(i);
        end
        
        for p = 1:nsegs
            for m = 1:seg012_max(1,p)
                [r,c,v] = ind2sub(size(seg012_combined4D_score(:,:,:,p)),find(seg012_combined4D_score(:,:,:,p) == m)); % find index in 3D array
                [r_Nrow,~] = size(r);
               
                for q = 1: r_Nrow
                    seg012_combined4D_score(r(q),c(q),v(q),p) = score_cell{p}(m);
                end
            end
        end     
        
        seg012_score_img = seg012_combined4D_score(:,:,:,1) + seg012_combined4D_score(:,:,:,2) + seg012_combined4D_score(:,:,:,3);
        niftiwrite(seg012_score_img, [template.studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_ProbMap.nii']);

        % copy geometry
        system(['$FSLDIR/bin/fslcpgeom ' template.studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_seg0.nii'  ...
               ' ' template.studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_ProbMap.nii']);
        
        clear seg012_combined4D_score;
        
        %% thresholded probability map
        fprintf (['UBO Detector: generating WMH map with probability threshold applied (probability threshold = ' num2str(probThr) ') for ' ID ' ...\n']);
        thresholded_probMap = seg012_score_img;
        
        clear seg012_score_img;
        
        thresholded_probMap (thresholded_probMap <= probThr) = 0;
        thresholded_probMap (thresholded_probMap > probThr) = 1;
        probThr = sprintf ('%1.2f', probThr); % two decimals
        probThr_parts = strsplit (probThr, '.');
        niftiwrite (thresholded_probMap, [template.studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_Prob' probThr_parts{1} '_' probThr_parts{2} '.nii']);
        system(['$FSLDIR/bin/fslcpgeom ' template.studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_seg0.nii' ...
               ' ' template.studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_Prob' probThr_parts{1} '_' probThr_parts{2} '.nii']);
        

        %% number of focal incidences count
        % fprintf ('Counting number of incidences ...');

        % WMHclusters = bwconncomp(thresholded_probMap, 6);
        % whlBrn_NoI = WMHclusters.NumObjects; % whole brain number of incidences

        % load lobar map

        clear thresholded_probMap;

        %% Refinement with specified ProbThr
%         fprintf (['Generating WMH map with specified probability threshold and refinement applied for ' ID ' ...\n']);
%         if (nargin == 10) || ((nargin == 11) && strcmp(varargin{1}, 'noGenF'))
%             [secondKNNlabel,secondKNNscore] = WMHextraction_postprocessing_refinement (template.studyFolder,ID,label,feature4training,decision4training, k, trainingFeatures2);
%         elseif nargin > 11 && strcmp(varargin{1}, 'noGenF')
%             [secondKNNlabel,secondKNNscore] = WMHextraction_postprocessing_refinement (template.studyFolder,ID,label,feature4training,decision4training, k, trainingFeatures2, varargin{2:end});  % same setting as the first kNN
%         elseif nargin > 10 && ~strcmp(varargin{1}, 'noGenF')
%             [secondKNNlabel,secondKNNscore] = WMHextraction_postprocessing_refinement (template.studyFolder,ID,label,feature4training,decision4training, k, trainingFeatures2, varargin{:});
%         end
%             
%         label_cell_refined {1} = secondKNNlabel (1:seg0_max);
%         label_cell_refined {2} = secondKNNlabel ((seg0_max+1):(seg0_max+seg1_max));
%         label_cell_refined {3} = secondKNNlabel ((seg0_max+seg1_max+1):(seg0_max+seg1_max+seg2_max));
%         for k = 1:3
%             for t = 1:seg012_max(1,k)
%                 [h, l, s] = ind2sub(size(seg012_combined4D_label_refined(:,:,:,k)),find(seg012_combined4D_label_refined(:,:,:,k) == t)); % find index in 3D array
%                 [h_Nrow,~] = size(h);
%    
%                 for u = 1: h_Nrow        
%                     % ------ refined image ------
%                     if strcmp(label_cell_refined{k}{t},'Yes')
%                         seg012_combined4D_label_refined(h(u),l(u),s(u),k) = 1;                   
%                     else
%                         seg012_combined4D_label_refined(h(u),l(u),s(u),k) = 0;
%                     end                    
%                 end
%             end
%         end
%                         
%         seg012_label_img_refined = seg012_combined4D_label_refined(:,:,:,1) + seg012_combined4D_label_refined(:,:,:,2) + seg012_combined4D_label_refined(:,:,:,3);
% %         size (seg012_label_img_refined)
% %         max(nonzeros(seg012_label_img_refined))
% %         size (thresholded_probMap)
% %         size (label)
% %         size (secondKNNlabel)
%         % seg012_label_img_refined = seg012_label_img_refined .* thresholded_probMap;
% %         niftiwrite(make_nii (seg012_label_img_refined),...
% %                             [template.studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_Prob' probThr_parts{1} '_' probThr_parts{2} '_refined.nii']); 
%         niftiwrite(make_nii (seg012_label_img_refined),...
%                             [template.studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_refinementKNN.nii']); 
        
        
        
    else
        fprintf ('%s\n', 'ERROR: no feature_forTraining.txt');
    end
else
    fprintf ('%s\n', 'ERROR: no decision_forTraining.txt');
end


    
    
    
    
    
