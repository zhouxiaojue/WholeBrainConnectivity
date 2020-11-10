function Main_WholeBrain_FC(SublistTxt)
addpath('/data1/2018_ActionDecoding/analysis_fc/Scripts/WholeBrainFC/')
addpath('/data1/2018_ActionDecoding/analysis_fc/Scripts/')
fileID = fopen (SublistTxt,'r');
file = textscan(fileID,'%q');
subList = file{1};
fclose(fileID);
%OutFileDir = '/data1/2018_ActionDecoding/analysis_fc/WholeBrainFC/'; %same
%as CorrPath so comment this one out
NumSubs = length(subList);
%ROIlist = {'pSTS_RH','IFG_RH','pSTS_LH','IFG_LH','aSTS_RH','aSTS_LH','hMT_RH','hMT_LH'};
ROIlist = {'BA47_RH','BA45A_RH','BA45B_RH','BA44_RH','IFS_RH','BA47_LH',...
    'BA45A_LH','BA45B_LH','BA44_LH','IFS_LH'};
CorrPath = '/data1/2018_ActionDecoding/analysis_fc/WholeBrainFC/';
niftiPath = '/data1/2018_ActionDecoding/analysis_fc/nifti/Orig_T1/';
for sub = 1:NumSubs
    subID = char(subList(sub));
    
%     for r = 1:length(ROIlist)
%         ROI = char(ROIlist(r));
%         
    WholeBrain_FC_update(subID,ROIlist,CorrPath);
        
%     end %ROI
    
end %sub

%CorrPath = '/data1/2018_ActionDecoding/analysis_fc/WholeBrainFC/';
OutFileDir = '/data1/2018_ActionDecoding/analysis_fc/WholeBrainFC/nifti/ROItask/';

for sub = 1:NumSubs
    subID = char(subList(sub));
    OutFilePrefix = subID;
%     for r = 1:length(ROIlist)
%         ROI = char(ROIlist(r));
%         
    TempFile = fullfile(niftiPath,(strcat(subID,'_T1_crop.nii')));
    saveWholeBrain(subID,ROIlist,CorrPath,'nifti','task',OutFilePrefix,OutFileDir,TempFile);
        
%     end %ROI
    
end %sub
end
% %for saving out vmp files
% OutFileDir = '/data1/2018_ActionDecoding/analysis_fc/WholeBrainFC/VMPfiles/';
% for sub = 1:NumSubs
%     subID = char(subList(sub));
%     OutFilePrefix = subID;
% %     for r = 1:length(ROIlist)
% %         ROI = char(ROIlist(r));
% %         
%     saveWholeBrain(subID,ROIlist,CorrPath,'BV',OutFilePrefix,OutFileDir);
%         
% %     end %ROI
%     
% end %sub