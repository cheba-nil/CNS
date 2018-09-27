function [secondKNNlabel, secondKNNscore] = WMHextraction_postprocessing_refinement (studyFolder,ID,firstKNNlabel,feature4training,decision4training,k,trainingFeatures2,varargin)

training_features = importdata (feature4training);
training_decision = importdata (decision4training);

%% second kNN model
if nargin == 6
    second_kNN_mdl = fitcknn (training_features(:,trainingFeatures2), training_decision, ...
                    'NumNeighbors', k, ...
                    'Standardize', 1);
elseif nargin > 6
    second_kNN_mdl = fitcknn (training_features(:,trainingFeatures2), training_decision, ...
                    'NumNeighbors', k, ...
                    varargin{:});
end


%% predict
predictionTBL_path = [studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_feature_4prediction.txt'];
predictionTBL = importdata(predictionTBL_path, ' ');
[label, score, ~] = predict (second_kNN_mdl, predictionTBL(:,trainingFeatures2));

secondKNNlabel = label;
secondKNNscore = score;

%% assing 'No' to those clusters removed by the first kNN
% [Nrows,~] = size(label);
% secondKNNlabel = cell(Nrows,1);
% parfor i = 1:Nrows
%     if strcmp(firstKNNlabel{i},'Yes')
%         secondKNNlabel{i,1} = label{i};
%     else
%         secondKNNlabel{i,1} = 'No';
%     end
% end
    