function [depdScale1] = computeDepdScale(feature1, gss1, idm1)
%% compute match score using matlab
% feature1, feature2, descr1, descr2 -- same size for column
depdSize = size(idm1{1}, 1);
featureSize = size(feature1, 2);
depdScale1 = zeros(depdSize, featureSize);

for i = 1 : size(feature1, 2)
    frame1 = feature1(1:7, i);
    depdin1 = depdscale(gss1, frame1(:,1), idm1);
    depdScale1(1:size(depdin1,2), i) =depdin1(1,:)';
end




% function depdin = depdscale(gss1, feature1, idm1)
% ttScale1 = gss1.ds{feature1(6,1),feature1(5,1)};
% tScale1 = ttScale1(1);
% dScale1 = ttScale1(2);
% 
% tScale = gss1.octave{tScale1, dScale1};
% si = min(size(tScale,4),floor(feature1(5,1)+0.5) +1);
% si = max(si,1);
% S1 = gss1.smoothmatrix{feature1(6,1),feature1(5,1)}(:,:,si);
% temp(1,:) = find(S1(max(1,floor(feature1(1,1))),:)>0.01);
% temp(2,:) = max(1,floor(feature1(2,1)));
% depdin = temp;



function depdin = depdscale(gss1, frame, idm1)
% [x(:)' ; y(:)' ; sigmad(:)' ;sigmat(:)' ; octave_Depd--oframes(4,:); octave_Time--oframes(5,:); pricurRatio
% gss.ds{toctave, doctave}
% gss.octave{toctave, doctave}
DOctave = frame(3, 1);
TOctave = frame(3, 1);

S1 = gss1.smoothmatrix{DOctave}(:,:, end, end);
% ignore small number
tempDepdIndex = frame(1, 1);

% if DOctave > 1
%     tempDepdIndex = floor (tempDepdIndex * (1/2)^DOctave);
% end
tempVector = S1(max(1, tempDepdIndex),:);
tempOnes = ones(1, size(tempVector, 2));
tempCombine = tempVector + tempOnes;
if(DOctave == 1)
    temp(1,1) = frame(1, 1);
    % temp(2,1) = frame(2, 1); % mark the feature center tmie 
else
    temp(1,:) = find(tempCombine ~= 1.000);
    % temp(2,:) = max(1,floor(frame(2,1))); % mark the feature center time
end
depdin = temp;
