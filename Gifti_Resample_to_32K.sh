# for each network i at k=17
for i in {1..17};
# resample soft parcel to hcp-surface
# left hemisphere
do /cbica/projects/abcdfnets/scripts/workbench-1.2.3/exe_rh_linux64/wb_command -metric-resample ~/conversion_tests/Group_lh_Network_${i}.func.gii ~/standard_mesh_atlases/resample_fsaverage/fsaverage5_std_sphere.L.10k_fsavg_L.surf.gii ~/standard_mesh_atlases/resample_fsaverage/fs_LR-deformed_to-fsaverage.L.sphere.32k_fs_LR.surf.gii ADAP_BARY_AREA ~/conversion_tests/resamp_32k_network${i}_L.32k_fs_LR.func.gii -area-metrics ~/standard_mesh_atlases/resample_fsaverage/fsaverage5.L.midthickness_va_avg.10k_fsavg_L.shape.gii ~/standard_mesh_atlases/resample_fsaverage/fs_LR.L.midthickness_va_avg.32k_fs_LR.shape.gii
# right hemisphere
/cbica/projects/abcdfnets/scripts/workbench-1.2.3/exe_rh_linux64/wb_command -metric-resample ~/conversion_tests/Group_rh_Network_${i}.func.gii ~/standard_mesh_atlases/resample_fsaverage/fsaverage5_std_sphere.R.10k_fsavg_R.surf.gii ~/standard_mesh_atlases/resample_fsaverage/fs_LR-deformed_to-fsaverage.R.sphere.32k_fs_LR.surf.gii ADAP_BARY_AREA ~/conversion_tests/resamp_32k_network${i}_R.32k_fs_LR.func.gii -area-metrics ~/standard_mesh_atlases/resample_fsaverage/fsaverage5.R.midthickness_va_avg.10k_fsavg_R.shape.gii ~/standard_mesh_atlases/resample_fsaverage/fs_LR.R.midthickness_va_avg.32k_fs_LR.shape.gii
# written out as resamp_32K_network${i}_L.32K_fs_LR.func.gii
done
