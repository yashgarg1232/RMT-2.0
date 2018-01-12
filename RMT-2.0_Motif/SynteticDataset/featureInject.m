function [rndWalks, FeatPositions] = featureInject(patternFeature, depdScale, sameVariateGroup, NumInstances, rndWalks, FeatPositions, data)
% sameVariateGroup = 1: feature injected to same group of variates
% sameVariateGroup = 0: feature injected to different group of variates

% timeScope = patternFeature(4) * 3;
% intervalTime = (max(round((patternFeature(2) - timeScope), 0)) : (min(round((patternFeature(2) + timeScope)), size(data, 2)))); % feature time scope (integer)
% motifData = data(:, intervalTime);
% [~, motifColumn] = size(motifData);
myDepdScale = depdScale(depdScale ~= 0); 

% for different scale feature inseration, insert twice each time
if(sameVariateGroup ==1 )
    NumInstances = NumInstances / 2;
end

pStep = 0;
Step = floor(size(rndWalks, 2) / NumInstances); % avoid injecting features in the same position

for i = 1 : NumInstances
    if(sameVariateGroup == 0)
        % different variate group but same interval time
        timeScope = patternFeature(4) * 3;
        intervaltime = (max(round((patternFeature(2) - timeScope), 0)) : (min(round((patternFeature(2) + timeScope)), size(data, 2)))); % feature time scope (integer)
        motifData = data(:, intervaltime);
        [~, motifColumn] = size(motifData);
        
        % insert same feature at different variate groups
        variateSize = size(myDepdScale, 1);
        starter = randi([pStep, max(pStep + Step - motifColumn, 0)],1,1);
        variateStartIndex = randi([1, size(depdScale, 1)], 1, 1);
        FeatPositions(i,:) = [i, patternFeature(2), starter, starter + motifColumn - 1];
        
        myDepdScale = zeros(size(depdScale, 1), 1);
        if(variateStartIndex + variateSize > size(myDepdScale, 1))
            myDepdScale(variateStartIndex : end) = 1;
            myDepdScale(1 : mod((variateStartIndex + variateSize), size(myDepdScale, 1))) = 1;
        else
            myDepdScale(variateStartIndex : variateStartIndex + variateSize) = 1;
        end
        rndWalks(myDepdScale(:) > 0, starter : starter + motifColumn - 1) = motifData(myDepdScale(:) > 0, :); % inject the features into random walk time series data
    else
        timeScope_1 = patternFeature(4, 1) * 3;
        timeScope_2 = patternFeature(4, 2) * 3;
        intervaltime_1 = (max(round((patternFeature(2, 1) - timeScope_1), 0)) : (min(round((patternFeature(2, 1) + timeScope_1)), size(data, 2)))); % feature time scope (integer)
        motifData_1 = data(:, intervaltime_1);
        [~, motifColumn_1] = size(motifData_1);
        
        
        intervaltime_2 = (max(round((patternFeature(2, 2) - timeScope_2), 0)) : (min(round((patternFeature(2, 2) + timeScope_2)), size(data, 2)))); % feature time scope (integer)
        motifData_2 = data(:, intervaltime_2);
        [~, motifColumn_2] = size(motifData_2);
        
        % insert different scale-features from different scales into same group of variates
        % size(patternFeature, 2) > 1, insert two at the same time
        starter_1 = randi([pStep, max(pStep + Step - motifColumn_1, 0)],1,1);
        starter_2 = randi([pStep, max(pStep + Step - motifColumn_2, 0)],1,1);
        while(starter_2 == starter_1)
            starter_2 = randi([pStep, max(pStep + Step - motifColumn_2, 0)],1,1);
        end
        
        FeatPositions(2 * (i - 1) + 1, :) = [2 * (i - 1) + 1, patternFeature(2, 1), starter_1, starter_1 + motifColumn_1 - 1];
        FeatPositions(2 * i, :) = [2 * i, patternFeature(2, 2), starter_2, starter_2 + motifColumn_2 - 1];
        
        rndWalks(myDepdScale, starter_1 : starter_1 + motifColumn_1 - 1) = motifData_1(myDepdScale, :); % inject the features into random walk time series data
        rndWalks(myDepdScale, starter_2 : starter_2 + motifColumn_2 - 1) = motifData_2(myDepdScale, :); % inject the features into random walk time series data
    end
    pStep = pStep + Step;
end




