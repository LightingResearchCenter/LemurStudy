function summer2014lowlight
%MARCH2013LOWLIGHT Summary of this function goes here
%   Detailed explanation goes here

%  Environment observation


close all;

[parentDir,~,~] = fileparts(pwd);
[parentParentDir,~,~] = fileparts(parentDir);
daysigramToolkit = fullfile(parentParentDir,'DaysigramReport');
addpath(parentDir,daysigramToolkit,'IO');

projectDir = fullfile([filesep,filesep,'ROOT'],'projects',...
    'Lemur''s-Research','2014EnclosureObservation');

daysigramDir = fullfile(projectDir,'daysigrams');

dimeSN = {'336';'338'};

filePath = ...
    {fullfile(projectDir,'Dime336pendant_Subject336_25Jun2014raw.txt');...
     fullfile(projectDir,'Dime338pendant_Subject338_25Jun2014raw.txt')};

for i1 = 1:2
    [timeArray,illuminanceArray,~,activityArray] = CalibrateDimesimeterDownloadFile_21Feb2013(filePath{i1});
    
    % Set Lux values below 0.005 to 0.005
    illuminanceArray = choptothreshold(illuminanceArray,0.0001);
    
    idx = timeArray >= datenum(2014,6,5) & timeArray <= datenum(2014,6,19);
    
    nDaysPerSheet = 14;
    
    generatereport(dimeSN{i1},timeArray(idx),activityArray(idx),illuminanceArray(idx),...
        'lux',[10^-2,10^3],nDaysPerSheet,daysigramDir,dimeSN{i1});
    
    clear('timeArray','illuminanceArray','activityArray');
end


end

