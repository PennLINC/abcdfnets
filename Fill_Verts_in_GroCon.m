ProjectFolder = '/cbica/projects/abcdfnets/results'
initName = [ProjectFolder '/SingleParcellation/RobustInitialization_Cifti_Surf/initResamp.mat'];
init=load(initName);
V=init.initV;
% find vertices with no loadings
LoadingSum=sum(V,2);
zeroSum=find(LoadingSum==0);
% vector to populate blanks with
fillVector=[.1 .1 .1 .1 .1 .1 .1 .1 .1 .1 .1 .1 .1 .1 .1 .1 .1]; 
% populate through loop
for i=1:length(zeroSum);
V(zeroSum(i),:)=fillVector;
end
% save out as sep. initialization template
initV=V;
outfile=[ProjectFolder '/SingleParcellation/RobustInitialization_Cifti_Surf/initResamp_Full.mat'];
save(outfile,'initV')
