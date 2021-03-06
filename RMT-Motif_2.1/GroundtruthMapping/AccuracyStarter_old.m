clc; clear;
warning off;
path='D:\Motif_Results\Datasets\SynteticDataset\Features_RMT_new\ICMR\USED RESULTS\';%Motif1-3\';%'D:\Motif_Results\Datasets\SynteticDataset\';
dataLocation='data\';
pathGT = 'D:\Motif_Results\Datasets\SynteticDataset\data\ICMR2018\';
Num_SyntSeries=10; % num of instances of one motif
% PossibleMotifInjected = [1,2,3];
% for idmotInj =1: size(PossibleMotifInjected,2)
%    motifinjected = num2str(PossibleMotifInjected(idmotInj));
    Name_OriginalSeries = [85,35,127,24]; % name of the original  series from with we  got the  motif instances to inject
%     percent=[0; 0.1;0.5;0.75;1];
%     for percentid=1:size(percent,1)
%         percentagerandomwalk=percent(percentid);
        % percentagerandomwalk=0.75;%1;%0; %0.1;%0.5;%
        strategy=[1,2,3,4,5,6];
        DepO =2;
        DepT =2;
        for strID =6:size(strategy,2)
            StrategyClustering= strategy(strID);%3;%2;%
            
            for pip=1:size(Name_OriginalSeries,2)
                for NAME = 1:Num_SyntSeries
                    
%                     TEST=['Motif',motifinjected,'_',num2str(Name_OriginalSeries(pip)),'_instance_',num2str(NAME)];%,'_',num2str(percentagerandomwalk)];
                    TEST=['Motif_5_1_',num2str(Name_OriginalSeries(pip)),'_instance_',num2str(NAME)];
                    %            ['Motif1_',num2str(pippo(pip)),'_instance_',num2str(NAME)]  %['MoCap',num2str(NAME)]
                    
                    FeaturesRM ='RMT';%'RMT';%
                    kindOfClustring= 'AKmeans'; % the algorithm of clustering to use
                    if StrategyClustering >3
                        kindOfClustring= 'DBScan';%
                    end
                    distanceUsed='Descriptor';% use just descriptors to  cluster
                    ClusterAlg = ['ClusterStrategy_',num2str(StrategyClustering)];
                    subfolderClusterLabel='Clusterlabel\ClusterLabel_';
                    
                    AP_allfeatures_ICMR(path,dataLocation,TEST,FeaturesRM,kindOfClustring,distanceUsed,ClusterAlg,StrategyClustering,num2str(DepO),num2str(DepT),pathGT);
                    if (StrategyClustering==3 | StrategyClustering==6)
                        AP_allfeatures_subcluster_ICMR(path,dataLocation,TEST,FeaturesRM,kindOfClustring,distanceUsed,ClusterAlg,StrategyClustering,num2str(DepO),num2str(DepT),pathGT);
                    end
                    %         for AfterPruning =0:1
                    %             for subcluster=0:1
                    %                 Distortion_Clusters(path,kindofinj,TEST,FeaturesRM,kindofCluster,measure,ClusterAlg,subfolderClusterLabel,num2str(DepO),num2str(DepT),AfterPruning,subcluster);
                    %             end
                    %         end
                    
                    %             end
                    %         end
                end
            end
%         end
    end
% end