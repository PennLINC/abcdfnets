function preProc_SSP_Delete_SplitHalf(subj)
%%% This function will take a single subject's NDAR name, download their fMRI data and motion masks, concatenate the fMRI data, mask according to Robert's instructions (.2mm FD, power outliers out), derive a single-subject parcellation based on Cui et al. 2020's group template, and delete the input fMRI data.

% print subject being ran
subj

% add matlab path for used functions
addpath(genpath('/cbica/projects/abcdfnets/scripts/code_nmf_cifti/tool_folder'));

% tell it where AWS tools are for downloads
system('export PATH=/cbica/projects/abcdfnets/aws/dist/:$PATH')

% echo subj name into a .txt
subjTxtCommand=['echo ' subj ' >> /cbica/projects/abcdfnets/nda-abcd-s3-downloader/' subj '.txt'];
system(subjTxtCommand)

% download that one subject's data
subjDlCommand=['python3 /cbica/projects/abcdfnets/nda-abcd-s3-downloader/download.py -i /cbica/projects/abcdfnets/nda-abcd-s3-downloader/datastructure_manifest_10_2.txt -o /scratch/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/ -s /cbica/projects/abcdfnets/nda-abcd-s3-downloader/' subj '.txt -l /cbica/projects/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/dl_logs -d /cbica/projects/abcdfnets/nda-abcd-s3-downloader/data_subsets_3_9_21_from9620.txt &']

% note: downloader tool does not seem to communicate when it is done to matlab
% added '&' and 'pause' so that matlab waits 5 minutes to proceed rather than getting caught up indefinitely
system(subjDlCommand)
pause(300)

% might need to pass in "a" or "b" manually at this point/below

% for each half, a or b
halves=['a','b'];
for h=1:2
	% unfortunately, write_cifti is sensitive to having the correct path added in the correct steps here. For half b, we need the initial
	addpath(genpath('/cbica/projects/abcdfnets/scripts/code_nmf_cifti/tool_folder'));
	% extract which half
	thishalf=halves(h);
	% reset subj name to refer to the half of interest
	subjH=[subj,thishalf];
	% now the matlab portions. Apply the motion mask to the downloaded data
	apply_SH_motion_mask(subj,thishalf)
	% concatenate masked time series and isolate the cortex (for cortical surface only SSP)
	concat_TS_and_IsoCort_SH(subj,thishalf)
	% derive an indivudalized parcellation
	Individualize_ciftiSurf_resampledGroCon_SH(subjH)
	% for "cifti_read", interferes if added earlier
	addpath(genpath('/cbica/projects/abcdfnets/scripts/cifti-matlab/'));
	% convert to dscalar hard parcel
	mat_to_dlabel_SH(subjH)
	% not deleting data for split-half subjs yet
end
