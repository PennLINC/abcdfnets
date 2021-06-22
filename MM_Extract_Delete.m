function MM_Extract_Delete(subj)
%%% This function will take a single subject's NDAR name, download their fMRI data and motion masks, concatenate the fMRI data, mask according to Robert's instructions (.2mm FD, power outliers out), derive a single-subject parcellation based on Cui et al. 2020's group template, and delete the input fMRI data.

% print subject being ran
subj

% add matlab path for used functions
addpath(genpath('/cbica/projects/abcdfnets/scripts/code_nmf_cifti/tool_folder'));

% tell it where AWS tools are for downloads
system('export PATH=/cbica/projects/abcdfnets/aws/dist/:$PATH')

% echo subj name into a .txt
subjTxtCommand=['echo ' subj ' >> /cbica/projects/abcdfnets/nda-abcd-s3-downloader/tmp_subjtxt/' subj '.txt'];
system(subjTxtCommand)

% download that one subject's data
subjDlCommand=['python3 /cbica/projects/abcdfnets/nda-abcd-s3-downloader/download.py -i /cbica/projects/abcdfnets/nda-abcd-s3-downloader/datastructure_manifest_10_2.txt -o /scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/ -s /cbica/projects/abcdfnets/nda-abcd-s3-downloader/tmp_subjtxt/' subj '.txt -l /cbica/projects/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/dl_logs -d /cbica/projects/abcdfnets/nda-abcd-s3-downloader/data_subset_MM.txt &']

% note: downloader tool does not seem to communicate when it is done to matlab
% added '&' and 'pause' so that matlab waits 200 seconds to proceed rather than getting caught up indefinitely
system(subjDlCommand)
pause(200)

% filepath for this subject's parcellation
fp=['/gpfs/fs001/cbica/projects/abcdfnets/results/SingleParcel_1by1/' subj '/IndividualParcel_Final_sbj1_comp17_alphaS21_1_alphaL300_vxInfo1_ard0_eta0/final_UV.mat'];
% filepath for myelin map
mmfp=['/scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/derivatives/abcd-hcp-pipeline/' subj '/ses-baselineYear1Arm1/anat/' subj '_ses-baselineYear1Arm1_space-fsLR32k_myelinmap.dscalar.nii'];
% if ssp and myelin map exist, then execute
if isfile(fp) && isfile(mmfp)

% load ssp
ssp=load(fp);
% convert to HP
V=ssp.V;
V2=V{:};
% apply ZC code from step 6th - subject AtlasLabel will have parcels for viz
V_Max = max(V2);
trimInd = V2 ./ max(repmat(V_Max, size(V, 1), 1), eps) < 5e-2;
V2(trimInd) = 0;
sbj_AtlasLoading = V2;
[~, sbj_AtlasLabel] = max(sbj_AtlasLoading, [], 2);

% load the group parcellation
ProjectFolder = '/cbica/projects/abcdfnets/results'
initName = [ProjectFolder '/SingleParcellation/RobustInitialization_Cifti_Surf/initResamp.mat'];
Gro=load(initName);
GroV=Gro.initV;
V_Max = max(GroV);
trimInd = GroV ./ max(repmat(V_Max, size(V, 1), 1), eps) < 5e-2;
GroV(trimInd) = 0;
Gro_AtlasLoading = GroV;
[~, G_AtlasLabel] = max(Gro_AtlasLoading, [], 2);

%%% load this subject's myelin map
% for cifti_read
addpath(genpath('/cbica/projects/abcdfnets/scripts/cifti-matlab/'));
MM=cifti_read(mmfp);
MMd=MM.cdata;
% initialize array
df=cell(1,36);
df(1)=cellstr(subj);

% for each network
for n=1:17
        ssp_indices=find(sbj_AtlasLabel==n);
        gro_indices=find(G_AtlasLabel==n);
        n_mm_ssp=MMd(ssp_indices);
        n_mm_gro=MMd(gro_indices);
        df(n+1)=num2cell(sum(n_mm_ssp));
        df(n+18)=num2cell(sum(n_mm_gro));
end

% extract full-brain value
fbMM=sum(MMd);
df(36)=num2cell(fbMM);

% write the 35 values to the subject's output folder
fp=['/gpfs/fs001/cbica/projects/abcdfnets/results/SingleParcel_1by1/' subj '/IndividualParcel_Final_sbj1_comp17_alphaS21_1_alphaL300_vxInfo1_ard0_eta0/MM_vals.csv'];
writetable(cell2table(df),fp)
% delete input data
Delete_input_data(subj)
% if MM or ssp does not exist, delete anything downloaded and exiclient_loop: send disconnect: Broken pipe
else
% delete input data
Delete_input_data(subj)
end
