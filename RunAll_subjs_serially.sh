subjs=$(cat /cbica/projects/abcdfnets/nda-abcd-s3-downloader/March_2021_DL/rest+task_all_Surf_only_infomap.txt)
for i in $subjs;do
matlab -nodisplay -r "preProc_SSP_Delete('${i}')"
done
