function CorrBrain = WholeBrain_FC(subID,ROIlistin,OutFileDir)
%This function takes in subID, ROI and saved file directory and calcualte
%whole brain connectivity of Whole brain beta series with ROI beta series.
%Needs: 
%1. Whole Brain Beta.mat already calculated and saved.
%2. ROI beta series 
%3. txt file with Names of ROI beta series and matched order of column/ROI
%FUTURE: index out different behavioral task trials and correlate
%Example:WholeBrain_FC('sub-07','pSTS_RH','/data1/2018_ActionDecoding/analysis_fc/WholeBrainFC/')

addpath(pwd)
addpath('/usr/local/MATLAB/R2017a/toolbox/fMRItoolbox/')
addpath('/home/xiaojue/bin/nifti_tools/')
addpath('/data1/2018_ActionDecoding/pilot/analysis_class/')
%addpath('/data1/2018_ActionDecoding/pilot/analysis_fc/')
addpath('/data1/2018_ActionDecoding/analysis_fc')

DataDir = '/data1/2018_ActionDecoding/data/';
BetaPath = '/data1/2018_ActionDecoding/analysis_fc/WholeBrainBeta/';
ROIbetaPath = '/data1/2018_ActionDecoding/analysis_fc/Despike/GSRUpdate101519/';
niiPath = '/data1/2018_ActionDecoding/analysis_fc/nifti/';
%variables for future function use
% subID = 'sub-07';
% ROI ='pSTS_RH';
% OutFileDir = '/data1/2018_ActionDecoding/analysis_fc/WholeBrainFC/';

disp(['processing ',subID,' ',char(strjoin(string(ROIlistin),', ')),'\n']);
%ROI = {'pSTS_RH','IFG_RH'};
%ROI: cell array of all the ROIs
OutPrefix = strcat(subID,'_WholeBrain_');
tic;
%TempFilePath
%Place holder for saving nifti and BV files 

%loaded as OutBetaHat
BetaFileName = strcat(subID,'_WholeBrainBeta.mat');
load(fullfile(BetaPath,BetaFileName));

%load ROI single BetaHat 
%reads in BetaHat_allROI
ROIBetaFileName = strcat(subID,'_Despike_withGSR2Step_Beta_alllocalROI.mat');
load(fullfile(ROIbetaPath,ROIBetaFileName));

%get labels from txt header
ROIlistFileName = strcat(subID,'_Despike_withGSR2Step_beta_allTrailsROIwithGSR.txt');
fid = fopen(fullfile(ROIbetaPath,ROIlistFileName));
ROIlist = strsplit(fgetl(fid),';');
fclose(fid);
ROIlist = char(ROIlist);
ROIlist = split(ROIlist);
MatchROI = ROIlist(7:21);
%7:21 is the ROI


%shift Time series as the last dimension
OutBetaHatshift = shiftdim(OutBetaHat,1);
%get x y z size
sz = size(OutBetaHat); 
clear OutBetaHat

%change the shape to Voxels by Trials
OutBetaHat_flat = reshape(OutBetaHatshift,[],size(OutBetaHatshift,4));
clear OutBetahat_shift


for indROI =1:length(ROIlistin)
    
ROI = char(ROIlistin(indROI));
OutFileName = strcat(OutPrefix,ROI,'.mat');  
if exist(fullfile(OutFileDir,OutFileName),'file')
    fprintf(['already processed and save output ',OutFileName,'\n'])
    continue
end

%find out the ROI
indtemp = find(contains(MatchROI,ROI));

if ~ismember(ROI,MatchROI)
    disp(['input ROI is not correct ' ROI ' going to next ROI'])
    continue
    %exit
end
%index out corresponding beta 
ROITS = BetaHat_allROI(:,indtemp+6);


%apply correlation to each row of OutBetaHat_flat with target ROI TS
Corr_flat = cellfun(@(x) corr(ROITS,x,'rows','complete'),num2cell(OutBetaHat_flat',1));

%put it back to 3D shape and save this as final output
CorrBrain = reshape(Corr_flat,sz(2:4));
clear Corr_flat
save(fullfile(OutFileDir,OutFileName),'CorrBrain')

% %save as nifti and BV output for visualization
% %can't use this part because of orientation and finding template files
% %WholeBrainMatFile = fullfile(OutFileDir,OutFileName);
% 
% TempNiftiFile = fullfile(niiPath,[]);
% %TempBVFile = '';
% saveWholeBrain(WholeBrainMat,TempNiftiFile,'nifti');
% %saveWholeBrain(WholeBrainMatFile,TempBVFile,'BV');
end %for ROI in ROIlist
time=toc;
fprintf('%d minutes and %f seconds\n', floor(time/60), rem(time,60));
