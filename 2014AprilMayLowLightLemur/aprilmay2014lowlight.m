function aprilmay2014lowlight
%MARCH2013LOWLIGHT Summary of this function goes here
%   Detailed explanation goes here

%  
% Put on april 17 2014.
% 14 days of 12/12 with lights on at 0630 and off at 1830.
% (Stage 1) 14 days of 12/12 from 1830 on april 17 to 1830 on may 2.
% (Stage 2) Dim or moonlight on may 2, may 3 and may 4th;
% (Stage 3) dark on may 5, 6, & 8;
% (Stage 4) moonlight on may 9, 10 & 11;
% (Stage 5) and dark on may 12
% and off morning of may 13.
% Again, florescent lights were on at 0630 and off at 1830 each day.
% Light level during dim or moonlight nights was 0.146 lux. 
%  
% Daysimeter number 336 on male ringtail named Licinius and number 338 on 
% female named Tellus. They both did very well and maintained their weights 
% plus or minus 40 grams for the whole trial. They appeared relaxed, even 
% the technicians said how good they did.


close all;

[parentDir,~,~] = fileparts(pwd);
[parentParentDir,~,~] = fileparts(parentDir);
daysigramToolkit = fullfile(parentParentDir,'DaysigramReport');
addpath(parentDir,daysigramToolkit,'IO');

projectDir = fullfile([filesep,filesep,'ROOT'],'projects',...
    'Lemur''s-Research','2014AprilMayLowLightLemurCatta');

daysigramDir = fullfile(projectDir,'daysigrams');

dimeSN = {336;338};
animalName = {'Licinius';'Tellus'};
animalSex = {'male';'female'};

stage = {'stage1 12-12';...
         'stage2 moonlight';...
         'stage3 dark';...
         'stage4 moonlight';...
         'stage5 dark'};

nStages = numel(stage);

% Set lights on/off
lightsOn = 6.5;
lightsOff = 18.5;

filePath = ...
    {fullfile(projectDir,'Dime336pendant_SubjectLicinius_15May2014raw.txt');...
     fullfile(projectDir,'Dime338pendant_SubjectTellus_15May2014raw.txt')};

% Set start dates of experiments
Y = 2014;
M = 5;
sDateVec = [Y, 4, 17, lightsOff, 0, 0;...
            Y, M,  2, lightsOff, 0, 0;...
            Y, M,  5, lightsOff, 0, 0;...
            Y, M,  9, lightsOff, 0, 0;...
            Y, M, 12, lightsOff, 0, 0];
sDate = datenum(sDateVec);
% Set end dates of experiments
eDateVec = [Y, M,  2, lightsOff, 0, 0;...
            Y, M,  5, lightsOff, 0, 0;...
            Y, M,  9, lightsOff, 0, 0;...
            Y, M, 12, lightsOff, 0, 0;...
            Y, M, 13, lightsOff , 0, 0];
eDate = datenum(eDateVec);

buffer = 0;

for i1 = 1:2
    [timeArray,illuminanceArray,~,activityArray] = CalibrateDimesimeterDownloadFile_21Feb2013(filePath{i1});
    if dimeSN{i1} == 338 % Correct for resets
        timeArray = timeArray - 2.088498589349911;
    end
    
    % Set Lux values below 0.005 to 0.005
    illuminanceArray = choptothreshold(illuminanceArray,0.0001);
    
    idx1 = timeArray >= sDate(1) & timeArray <= eDate(end);
    nDaysPerSheet = 14;
    generatereport(animalName{i1},timeArray(idx1),activityArray(idx1),...
        illuminanceArray(idx1),'lux',[10^-4,10^3],nDaysPerSheet,daysigramDir,animalName{i1});
    
    for i2 = 1:nStages-1
        idx2 = timeArray >= sDate(i2) & timeArray < eDate(i2);
        days = ceil(eDate(i2)-sDate(i2));
        Title = [animalName{i1},' ',animalSex{i1},' - ',stage{i2}];
        pseudoMillerPlot(timeArray(idx2),activityArray(idx2),illuminanceArray(idx2),days,Title,lightsOn,lightsOff,buffer);
        fileName = [animalName{i1},'_',datestr(sDate(i2),'yyyy-mm-dd'),'_',stage{i2}];
        print(gcf,'-dpdf',fullfile(projectDir,'testPlots',[fileName,'.pdf']));
        close;
    end
    clear('timeArray','illuminanceArray','activityArray');
end


end

