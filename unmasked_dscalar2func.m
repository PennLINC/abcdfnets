unmasked_GC_folder=['/gpfs/fs001/cbica/projects/abcdfnets/data/cui2019_unmaskedConsensus/'];
addpath(genpath('/cbica/projects/abcdfnets/scripts/cifti-matlab/'));
for i = 1:17;
% load file
fp=[unmasked_GC_folder 'Group_AtlasLoading_Network_' num2str(i) '.dscalar.nii'];
NetLoads=cifti_read(fp);
% extract LH
lhLoad=NetLoads.cdata(1:10242);
% initialize gifti
LH_gif=gifti;
LH_gif.cdata=lhLoad;
V_lh_File = [unmasked_GC_folder 'Group_lh_Network_' num2str(i) '.func.gii'];
% save
save(LH_gif, V_lh_File);
% extract RH
rhLoad=NetLoads.cdata(10243:20484);
% initialize gifti
RH_gif=gifti;
RH_gif.cdata=rhLoad;
V_rh_File = [unmasked_GC_folder 'Group_rh_Network_' num2str(i) '.func.gii'];
% save
save(RH_gif, V_rh_File);
i
end
