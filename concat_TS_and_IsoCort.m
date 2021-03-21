function concat_TS_and_IsoCort(subj)
% load in subjs
topleveldir='/scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/derivatives/abcd-hcp-pipeline/sub-*'
direc=dir(topleveldir);
% deep gmless cifti for template
sname=subj;
parentfp=['/scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/derivatives/abcd-hcp-pipeline/' sname '/ses-baselineYear1Arm1/func/'];
rsfp=[parentfp sname '_ses-baselineYear1Arm1_task-rest_p2mm_masked.dtseries.nii'];
sstfp=[parentfp sname '_ses-baselineYear1Arm1_task-SST_p2mm_masked.dtseries.nii'];
nbackfp=[parentfp sname '_ses-baselineYear1Arm1_task-nback_p2mm_masked.dtseries.nii'];
midfp=[parentfp sname '_ses-baselineYear1Arm1_task-MID_p2mm_masked.dtseries.nii'];
if ~exist(sstfp,'file')
disp('missing sst')
elseif ~exist(rsfp,'file')
disp('missing rs')
elseif ~exist(nbackfp,'file')
disp('missing nback')
elseif ~exist(midfp,'file')
disp('missing mid')
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
end

if exist(sstfp,'file')
sst=read_cifti(sstfp);
sstts=sst.cdata;
Oords=[Oords sstts];
% init on this in case no rs
concat=sst;
end

if exist(nbackfp,'file')
nback=read_cifti(nbackfp);
nbackts=nback.cdata;
Oords=[Oords nbackts];
% init on this in case no rs or sst
concat=nback;
end

if exist(midfp,'file')
mid=read_cifti(midfp);
midfpts=mid.cdata;
Oords=[Oords midfpts];
% init on this in case it is the only scan
concat=mid;
end

% remove initialization column of oords
Oords(:,1)=[];

concat.cdata=Oords;
% alter diminfo in cifit to align with new dims
csize=size(Oords);
concat.diminfo{2}.length=csize(2);
fp=[parentfp sname '_ses-baselineYear1Arm1_p2mm_masked_concat.dtseries.nii'];
write_cifti(concat,fp);
end
