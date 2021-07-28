file_pattern='/gpfs/fs001/cbica/projects/abcdfnets/results/SingleParcel_1by1/sub-NDARINV*/IndividualParcel_Final_sbj1_comp17_alphaS21_1_alphaL300_vxInfo1_ard0_eta0/final_UV.mat'
data_dir=dir(file_pattern);
data_locations=fullfile({data_dir.folder}, {data_dir.name});
fp_pt1='/gpfs/fs001/cbica/projects/abcdfnets/results/SingleParcel_1by1/';
fp_pt2='/IndividualParcel_Final_sbj1_comp17_alphaS21_1_alphaL300_vxInfo1_ard0_eta0/final_UV.mat';

%%% run for group one
% read in group one list
Group1=fileread('~/ABCD_GRP1_extended_subject_list.txt');
Group1names=strsplit(Group1);

% initialize count of completed subjects
CompletedSubjs=0;

for i = 1:length(Group1names);
	subjFP=strcat(fp_pt1,Group1names(i),fp_pt2);
	if exist(subjFP,'file');
	        UV=load(subjFP));
	        V=UV.V;
        	V2=V{:};
        	% apply ZC code from step 6th - subject AtlasLabel will have parcels for viz
        	V_Max = max(V2);
        	trimInd = V2 ./ max(repmat(V_Max, size(V, 1), 1), eps) < 5e-2;
        	V2(trimInd) = 0;
        	sbj_AtlasLoading = V2;
        	[~, sbj_AtlasLabel] = max(sbj_AtlasLoading, [], 2);
        	subjDiscretes(i,:)=sbj_AtlasLabel;
		% add 1 to count of completed subjs
		CompletedSubjs=CompletedSubjs+1;
	end
end

% now calc probability any one grayord belongs to canonical net.
for i = 1:17
        for g = 1:59142
                instancesofI=find(subjDiscretes(:,g)==i);
                % instances of this network assignment divided by total number of subjs
                ProbAtlas(i,g)=length(instancesofI)/CompletedSubjs;
        end
end

save('~/results/ProbAtlas_Group1.mat','ProbAtlas')

%%% run for group two
% read in group one list
Group2=fileread('~/ABCD_GRP2_extended_subject_list.txt');
Group2names=strsplit(Group2);
	
% initialize count of completed subjects
CompletedSubjs=0;

for i = 1:length(Group2names);
        subjFP=strcat(fp_pt1,Group2names(i),fp_pt2);
        if exist(subjFP,'file');
                UV=load(subjFP));
                V=UV.V;
                V2=V{:};
                % apply ZC code from step 6th - subject AtlasLabel will have parcels for viz
                V_Max = max(V2);
                trimInd = V2 ./ max(repmat(V_Max, size(V, 1), 1), eps) < 5e-2;
                V2(trimInd) = 0;
                sbj_AtlasLoading = V2;
                [~, sbj_AtlasLabel] = max(sbj_AtlasLoading, [], 2);
                subjDiscretes(i,:)=sbj_AtlasLabel;
                % add 1 to count of completed subjs
                CompletedSubjs=CompletedSubjs+1;
        end
end

% now calc probability any one grayord belongs to canonical net.
for i = 1:17
        for g = 1:59142
                instancesofI=find(subjDiscretes(:,g)==i);
                % instances of this network assignment divided by total number of subjs
                ProbAtlas(i,g)=length(instancesofI)/CompletedSubjs;
        end
end

save('~/results/ProbAtlas_Group2.mat','ProbAtlas')


%%% for full group prob atlas
% initialize table
subjDiscretes=zeros(length(data_locations),59412);
ProbAtlas=zeros(17,59412);

for i = 1:length(data_locations)
	UV=load(char(data_locations(i)));
	V=UV.V;
	V2=V{:};
	% apply ZC code from step 6th - subject AtlasLabel will have parcels for viz
	V_Max = max(V2);
	trimInd = V2 ./ max(repmat(V_Max, size(V, 1), 1), eps) < 5e-2;
	V2(trimInd) = 0;
	sbj_AtlasLoading = V2;
	[~, sbj_AtlasLabel] = max(sbj_AtlasLoading, [], 2);
	subjDiscretes(i,:)=sbj_AtlasLabel;
end

% now calc probability any one grayord belongs to canonical net.
for i = 1:17
	for g = 1:59142
		instancesofI=find(subjDiscretes(:,g)==i);
		% instances of this network assignment divided by total number of subjs
		ProbAtlas(i,g)=length(instancesofI)/length(data_locations);
	end
end
save('~/results/ProbAtlas.mat','ProbAtlas')    	
