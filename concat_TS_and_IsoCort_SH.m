function concat_TS_and_IsoCort_SH(subj,half)
% no real concatenation in resting-state only iteration, function name maintained for parallelism with main pipeline

% load in subjs
topleveldir='/scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/derivatives/abcd-hcp-pipeline/sub-*'
direc=dir(topleveldir);

% deep gmless cifti for template
sname=subj;
fpParent=['/scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/derivatives/abcd-hcp-pipeline/' sname '/ses-baselineYear1Arm1/func/'];

% name of this masked half
rsfp=[fpParent sname '_ses-baselineYear1Arm1_task-rest_SH_' half '_masked.dtseries.nii'];

if ~exist(rsfp,'file')
disp('missing rs')
end

% isolate the masked grayordinatewise time series
% and stack them onto an init oordinate-wise value
Oords=zeros(91282,1);

if exist(rsfp,'file')
rs=read_cifti(rsfp);
rsts=rs.cdata;
Oords=[Oords rsts];
% initialize output cifti format on this too
concat=rs;

% remove initialization column of oords
Oords(:,1)=[];

concat.cdata=Oords;
% alter diminfo in cifit to align with new dims
csize=size(Oords);
concat.diminfo{2}.length=csize(2);

% save it out
parentfp=['/scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/derivatives/abcd-hcp-pipeline/' sname '/ses-baselineYear1Arm1/func/'];
fp=[parentfp sname half '_ses-baselineYear1Arm1_surfOnly.dtseries.nii'];
write_cifti(concat,fp);
end
