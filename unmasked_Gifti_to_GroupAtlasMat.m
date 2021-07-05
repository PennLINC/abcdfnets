% workbench path
wbp='/cbica/projects/abcdfnets/scripts/workbench-1.2.3/exe_rh_linux64/';
% add cifti tools for matlab
addpath(genpath('/cbica/projects/abcdfnets/scripts/cifti-matlab/'));
% add template for resampling
template='/cbica/projects/abcdfnets/data/subj_rs_p2mmMasked_giftis/sub-NDARINVA0D0J1PP_ses-baselineYear1Arm1_p2mm_masked.dtseries.nii'
% load in hcp-cifti-sized init.mat 
ProjectFolder = '/cbica/projects/abcdfnets/results';
initName = [ProjectFolder '/SingleParcellation/RobustInitialization_Cifti_Surf/init.mat'];
initMat=load(initName);
initSize=size(initMat.initV);
% retain dimension 1 (vertices), coerce dimension 2 (networks)
groVerts=initSize(1);
groNets=17;
% make into equivalent init.mat for resample to 32K and 17 networks
resampInitV=zeros(groVerts,groNets);
% substitute resampled soft networks
for i=1:17
	% load in values for this network
	networkFPL=strjoin(['/cbica/projects/abcdfnets/data/cui2019_unmaskedConsensus/resamp_32k_network' string(i) '_L.32k_fs_LR.func.gii'],'');
	%networkLeft=gifti(char(networkFPL));
	networkFPR=strjoin(['/cbica/projects/abcdfnets/data/cui2019_unmaskedConsensus/resamp_32k_network' string(i) '_R.32k_fs_LR.func.gii'],'');
	%networkRight=gifti(char(networkFPR));
	% combine hemispheres
	combinedFN=['/cbica/projects/abcdfnets/data/cui2019_unmaskedConsensus/Group_AtlasLoading_Network_' num2str(i) '.dscalar.nii'];
	cmd = strjoin([wbp 'wb_command -cifti-create-dense-scalar ' combinedFN ' -left-metric ' networkFPL ' -right-metric ' networkFPR],'');
	system(cmd);
	% resolve to 59K cortical vertices version
	outFN=strjoin(['/cbica/projects/abcdfnets/conversion_tests/Network' string(i) '_91282.dscalar.nii'],''); 
	cmd2 = strjoin([wbp 'wb_command -cifti-create-dense-from-template ' template ' ' outFN ' -cifti ' combinedFN],'');
	system(cmd2)
	% read it back in
	combined=cifti_read(outFN);
	combinedHemis=combined.cdata;
	resampInitV(:,i)=combinedHemis(1:59412,:);
end
% match initmat forma
initV=resampInitV;
% save out in matlab format
outFP=[ProjectFolder '/SingleParcellation/RobustInitialization_Cifti_Surf/initResamp_unmasked.mat'];
save(outFP,'initV');

