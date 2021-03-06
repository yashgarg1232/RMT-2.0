function [D,bestVariate]= DistancesTS(TSSection,NumWindows,depd)
     alphabet_size=6;
% D=zeros(size(TSSection,3),size(TSSection,3),size(TSSection,1));
D= zeros(size(TSSection,3));
Kvariate = size(depd{1},1);
    for i= 1: size(TSSection,3)
        variate=[];
        for j= i: size(TSSection,3)
            if(i==j)
                D(i,j) = inf; 
            else
                dist2features=zeros(1,size(TSSection,1));
                for k =1:size(TSSection,1)
                    dist2features(k)= min_dist(TSSection(k,:,i), TSSection(k,:,j), alphabet_size,NumWindows);
%                 D(i,j) = D(i,j)+a;%sum(sum(abs(TSSection(:,:,i) - TSSection(:,:,j))));
                end 
%                 [values,sortIDX ]=sort (dist2features);
%                 sortIDX = sortIDX(1:Kvariate);
%                 D{i,j}= [values,sortIDX];%sum(dist2features)/size(TSSection,1);%D(i,j)/size(TSSection,1);
%                 D{j,i} = D{i,j};
                  D(i,j) = min(dist2features);
                  D(j,i)=D(i,j);
                  if(D(i,j)==0)
                      intersection = intersect(depd{i}(dist2features==0),depd{j}(dist2features==0));
                      variate = union(intersection,variate);%depd{i}(dist2features==0);
                  end
            end
        end
       bestVariate{i}=variate; 
    end
end