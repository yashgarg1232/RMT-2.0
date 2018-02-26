function  TimeComputationDepdScale = Crete_saveDepdScale(savepath1,savepath2,savepath3,USER_OT_targhet,USER_OD_targhet)
load(savepath1);
            load(savepath2);
            load(savepath3);
            %% filter the features to get the ones just from the desired octave
            indexfeatureGroup = (frame1(6,:)==USER_OT_targhet & frame1(5,:)==USER_OD_targhet);
            X=frame1(:,indexfeatureGroup);
            tic;
            [depdScale1] = computeDepdScale(X, gss1, idm1);
            TimeComputationDepdScale=toc;
            %% save dependency of each feature
            DepdScopeVector= zeros(size(data,1),size(depdScale1,2));
            for i=1:size(depdScale1,2)
                actVector= depdScale1(depdScale1(:,i)>0,i);
                DepdScopeVector(actVector,i)=1;
            end
            
            if(exist(strcat(saveFeaturesPath,'Distances',distanceUsed,'\'),'dir')==0)
                mkdir(strcat(saveFeaturesPath,'Distances',distanceUsed,'\'));
            end
            csvwrite(strcat(saveFeaturesPath,'Distances',distanceUsed,'\DepdScale_IM_',TS_name,'_DepO_',num2str(USER_OD_targhet),'_TimeO_',num2str(USER_OT_targhet),'.csv'),depdScale1);
            csvwrite(strcat(saveFeaturesPath,'Distances',distanceUsed,'\DepdScopeVector_IM_',TS_name,'_DepO_',num2str(USER_OD_targhet),'_TimeO_',num2str(USER_OT_targhet),'.csv'),DepdScopeVector);
end