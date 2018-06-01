clear;
clc;

% iterate file to for upload
testCaseIndex = 1 : 40;
weighted = 0;

TS_index = [2];
num_of_motif = 1;
% GroundTruthFilePath = ['/Users/sliu104/Desktop/Test_Case_Jan_30/Variate_Shifted_GroundTruth/FeaturePosition_MotifShift'];
GroundTruthFilePath = ['/Users/sliu104/Desktop/Test_Case_Jan_30/GroundTruth_Variate_Shifted_Flexible/FeaturePosition_MoCap'];

% MatrixProfileFilePath = ['/Users/sliu104/Desktop/Test_Case_Jan_30/Motif3/MatrixProfile_Accuracy/Motif'];
MatrixProfileFilePath = ['/Users/sliu104/Desktop/Test_Case_Jan_30/MatrixProfile_Accuracy_Variate_Shifted_Flexible/MoCap'];
% RMTMotifFilePath = ['/Users/sliu104/Desktop/Test_Case_Jan_30/Motif3/RMT_Accuracy/AP_DepO_2_DepT_2_Motif'];
% RMTMotifFilePath = ['/Users/sliu104/Desktop/Test_Case_Jan_30/RMT_Accuracy_Variate_Shifted_Flexible/AP_DepO_2_DepT_2_MoCap'];

% savePathRMT = ['/Users/sliu104/Desktop/Test_Case_Jan_30_Results/RMT_Accuracy_Variate_Shifted_Flexible'];
savePathMatrixProfile = ['/Users/sliu104/Desktop/Test_Case_Jan_30_Results/MatrixProfile_Accuracy_Variate_Shifted_Flexible'];

MatrixProfileEntropy = [];
RMTMotifEntropy = [];
index_count = 1;
for j = 1 : size(TS_index, 2)
    for i = 1 : size(testCaseIndex, 2)
        fprintf('Test case: %d, TS index: %d .\n', testCaseIndex(i), TS_index(j));
        
        % FeaturePosition_Motif3_127_instance_7
        % GroundTruthFile = [GroundTruthFilePath, num2str(num_of_motif), '_', num2str(TS_index(j)), '_instance_', num2str(testCaseIndex(i)), '.csv'];
        GroundTruthFile = [GroundTruthFilePath, num2str(num_of_motif), '.csv'];
        
        % MatrixProfileFile = [MatrixProfileFilePath, num2str(num_of_motif), '_', num2str(TS_index(j)), '_instance_', num2str(testCaseIndex(i)), '.csv'];
        % RMTMotifFile = [RMTMotifFilePath, num2str(num_of_motif), '_', num2str(TS_index(j)), '_instance_', num2str(testCaseIndex(i)), '.csv'];
        % RMTMotifFile = [RMTMotifFilePath, num2str(num_of_motif), '.csv'];
        MatrixProfileFile = [MatrixProfileFilePath, num2str(num_of_motif), '.csv'];
        
        % threshold = 0.5; % if it captures half of what we injected, then it is a motif instance
        threshold = eps; % if it is non-zero
        
        windowSize = 58;
        if(weighted == 1)
            % algorithmType = 'MatrixProfile';
            % [currentMatrixProfileEntropy, precisionMatrixMatrixProfile, recallMatrixMatrixProfile, FScoreMatrixMatrixProfile] = motifEvaluationWeighted(GroundTruthFile, MatrixProfileFile, algorithmType, windowSize);
            % algorithmType = 'RMT';
            % [currentRMTMotifEntropy, precisionMatrixRMT, recallMatrixRMT, FScoreMatrixRMT] = motifEvaluationWeighted(GroundTruthFile, RMTMotifFile, algorithmType, windowSize);
            
            % algorithmType = 'RME';
            % [currentRMEMotifEntropy, precisionMatrixRME, recallMatrixRME, FScoreMatrixRME] = motifEvaluationWeighted(GroundTruthFile, RMEMotifFile, algorithmType, windowSize);
        else
            algorithmType = 'MatrixProfile';
            [currentMatrixProfileEntropy,  precisionMatrixMatrixProfile, recallMatrixMatrixProfile, FScoreMatrixMatrixProfile, total_index] = motifEvaluation(GroundTruthFile, MatrixProfileFile, algorithmType, windowSize, threshold);
            
            % algorithmType = 'RMT';
            % [currentRMTMotifEntropy, precisionMatrixRMT, recallMatrixRMT, FScoreMatrixRMT, total_index] = motifEvaluation(GroundTruthFile, RMTMotifFile, algorithmType, windowSize, threshold);
        end
        
        MatrixProfileEntropy = [MatrixProfileEntropy ; currentMatrixProfileEntropy];
        % RMTMotifEntropy = [RMTMotifEntropy ; currentRMTMotifEntropy];
        
        % save current Matrix to files
        savePathMatrixProfilePrecision = [savePathMatrixProfile, '/MatrixProfilePrecision_', num2str(index_count), '.csv'];
        savePathMatrixProfileRecall = [savePathMatrixProfile, '/MatrixProfileRecall_', num2str(index_count), '.csv'];
        savePathMatrixProfileFScore = [savePathMatrixProfile, '/MatrixProfileFScore_', num2str(index_count), '.csv'];
        savePathRemainIndex = [savePathMatrixProfile, '/RemainIndex', num2str(index_count), '.csv'];
        csvwrite(savePathMatrixProfilePrecision, precisionMatrixMatrixProfile);
        csvwrite(savePathMatrixProfileRecall, recallMatrixMatrixProfile);
        csvwrite(savePathMatrixProfileFScore, FScoreMatrixMatrixProfile)
        csvwrite(savePathRemainIndex, total_index);
        
        
%         savePathRMTPrecision = [savePathRMT, '/RMTPrecision_', num2str(index_count), '.csv'];
%         savePathRMTRecall = [savePathRMT, '/RMTRecall_', num2str(index_count), '.csv'];
%         savePathRMTFScore = [savePathRMT, '/RMTFScore_', num2str(index_count), '.csv'];
%         savePathRemainIndex = [savePathRMT, '/RemainIndex', num2str(index_count), '.csv'];
%         csvwrite(savePathRMTPrecision, precisionMatrixRMT);
%         csvwrite(savePathRMTRecall, recallMatrixRMT);
%         csvwrite(savePathRMTFScore, FScoreMatrixRMT);
%         csvwrite(savePathRemainIndex, total_index);
        
        
        index_count = index_count + 1;
    end
end


% entropy: precision entropy, recall entropy, FScore entropy
% RMT_Entropy_Ouput_Path = [savePathRMT, '/RMTMotifEntropy.csv'];
MatrixProfile_Entropy_Ouput_Path = [savePathMatrixProfile, '/MatrixProfileEntropy.csv'];

% csvwrite(RMT_Entropy_Ouput_Path, RMTMotifEntropy);
csvwrite(MatrixProfile_Entropy_Ouput_Path, MatrixProfileEntropy);

fprintf('All done .\n');