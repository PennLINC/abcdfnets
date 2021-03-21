function apply_SH_motion_mask(subj,half)
% load in subj
topleveldir='/scratch/abcdfnets/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/derivatives/abcd-hcp-pipeline/sub-*'
direc=dir(topleveldir);
% initialize empty vector for average length
TRvecNum=[];

% SH edition: just sampling resting-state data
task="rest";
sname=subj;
fpParent=['/scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/derivatives/abcd-hcp-pipeline/' sname '/ses-baselineYear1Arm1/func/'];
fp=strjoin([fpParent sname '_ses-baselineYear1Arm1_task-' task '_bold_desc-filtered_timeseries.dtseries.nii'],'');
% not flagging missing tasks for now, added this conditional to reflect that
if exist(fp,'file')
ts_cif=read_cifti(fp);
ts=ts_cif.cdata;
% load in mask
% SH edition: using Robert's 10-minute split masks, a and b
% printout half
half=half
masfp=strjoin(['/cbica/projects/abcdfnets/data/SplitHalf_Masks_March2021/' sname '_ses-baselineYear1Arm1_task-' task '_bold_mask.mat_0.2_cifti_censor_FD_vector_10_minutes_of_data_at_0.2_threshold' half '.txt'],'');
mask=load(masfp);
% 10 minute resting-state TR selection
TRwise_mask=logical(mask);
% length of mask corresponds to number of TRs should be 750
sum(TRwise_mask)
% remove TRs with corresp. flag
masked_trs=ts(:,TRwise_mask);
% reconfig cifti metadata to reflect new number of TRs
newciftiSize=size(masked_trs);
newTRnum=newciftiSize(2);
%s-2 because we start at 3
ts_cif.diminfo{2}.length=newTRnum;
% overwrite TRs for new file
ts_cif.cdata=masked_trs;
% set output filepath
ofp=strjoin([fpParent sname '_ses-baselineYear1Arm1_task-' task '_SH_' half '_masked.dtseries.nii'],'');
% There is no reason this should be a requried step
ofp=convertStringsToChars(ofp);
% write out motion masked cifti
write_cifti(ts_cif,ofp);
else
end
