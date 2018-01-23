function september2015lowlight
%SEPTEMBER2015LOWLIGHT Summary of this function goes here
%   Detailed explanation goes here

% Mongoz trial from aug 24-sep 17. (Eulemur mongoz)
%  
% 209 on Flor (f) 1815 g and 29 years old
%  
% 221 on Julio (m) 1665 g and 25 years old
%  
% aug 24-sep 7 – 12/12
% sep 8, 9, and 10 – moonlight (0.015 lux)
% sep 11, 12, and 13 – dark
% sep 14, 15, and 16 – moonlight
% sep 17 out at 0900.
%  
% Room lights were set to go off at 1830 and come on at 0630 next morning.
% 


close all;

initializedependencies;

projectDir = fullfile([filesep,filesep,'ROOT'],'projects',...
    'Lemur''s-Research','2015_09_21_Lemurs');

dataDir = fullfile(projectDir,'originalData');

plotDir = fullfile(projectDir,'plots');

dimeSN = {209;221};
animalName = {'Flor';'Julio'};
animalSex = {'f';'m'};

stage = {'habituation';...
         'moonlit-1';...
         'dark-1';...
         'moonlit-2'...
         };

nStages = numel(stage);

% Set main lights on/off
lightsOn = 6.5;
lightsOff = 18.5;

filePath = ...
    {fullfile(dataDir,'Dime209_SubjectFlor_21Sep2015raw.txt');...
     fullfile(dataDir,'Dime222_SubjectJulio_21Sep2015raw.txt')};

% Set start dates of experiments
Y = 2015;
M = 9;
sDateVec = [Y, 8, 24, 9, 0, 0;...
            Y, M, 8, lightsOff, 0, 0;...
            Y, M, 11, lightsOff, 0, 0;...
            Y, M, 14, lightsOff, 0, 0];
sDate = datenum(sDateVec);
% Set end dates of experiments
eDateVec = [Y, M, 8, lightsOff, 0, 0;...
            Y, M, 11, lightsOff, 0, 0;...
            Y, M, 14, lightsOff, 0, 0;...
            Y, M, 17, 9, 0, 0;];
eDate = datenum(eDateVec);

buffer = 30;
% [hFigure,~,~,units] = initializefigure1(3,'on');

for i1 = 1:2
    [timeArray,illuminanceArray,CLA,activityArray] = CalibrateDimesimeterDownloadFile_21Feb2013(filePath{i1});
    timeArray = timeArray(:);
    illuminanceArray = illuminanceArray(:);
    CLA = CLA(:);
    activityArray = activityArray(:);
    
    CLA = choptothreshold(CLA,0);
    csArray = CSCalc_postBerlin_12Aug2011(CLA);
    
    % Set Lux values below 0.005 to 0.005
    illuminanceArray = choptothreshold(illuminanceArray,0.005);
%     illuminanceArray = choptothreshold(illuminanceArray,0);
    
    idx1 = timeArray >= sDate(1) & timeArray <= eDate(end);
    % Daysigram
    sheetTitle = ['May 2015, Subject: ',animalName{i1},', Dimesimeter: ',num2str(dimeSN{i1})];
    daysigramFileID = ['subject',animalName{i1}];
    observation = idx1;
    bed = false(size(timeArray));
    compliance = true(size(timeArray));
    masks = eventmasks('observation',observation,'bed',bed,'compliance',compliance);
    reports.daysigram.daysigram(1,sheetTitle,timeArray,masks,activityArray,illuminanceArray,'lux',[10^-2,10^5],17,plotDir,daysigramFileID);
    
    for i2 = 1:nStages
        idx2 = timeArray >= sDate(i2) & timeArray < eDate(i2);
        
        % Light and Health Report/ Phasor Analysis
        figTitle = 'August-September 2015 ';
        
        observation = idx2;
        bed = false(size(timeArray));
        compliance = true(size(timeArray));
        masks = eventmasks('observation',observation,'bed',bed,'compliance',compliance);
        
        light = lightmetrics('cla',CLA,'cs',csArray,'illuminance',illuminanceArray);
        
        epoch = samplingrate(10,'minutes');
        absTime = absolutetime(timeArray,'datenum',false,-4,'hours');
        relTime = relativetime(absTime);
        
        Phasor = phasor.prep(absTime,epoch,light,activityArray,masks);
        Actigraphy = isiv.prep(absTime,epoch,activityArray,masks);
        Average = reports.composite.daysimeteraverages(light,activityArray,masks);
        
        Miller = struct('time',[],'cs',[],'activity',[]);
        [         ~,Miller.cs] = millerize.millerize(relTime,light.cs,masks);
        [Miller.time,Miller.activity] = millerize.millerize(relTime,activityArray,masks);
        
        clf;
        reports.composite.compositeReport(plotDir,Phasor,Actigraphy,Average,Miller,[animalName{i1},' ',stage{i2}],num2str(dimeSN{i1}),figTitle)
        
        clf;
        days = ceil(eDate(i2)-sDate(i2));
        Title = [animalName{i1},' ',animalSex{i1},' - ',stage{i2}];
        pseudoMillerPlot(timeArray(idx2),activityArray(idx2),illuminanceArray(idx2),Title,lightsOn,lightsOff,buffer);
        fileName = [animalName{i1},'_',datestr(sDate(i2),'yyyy-mm-dd'),'_',stage{i2}];
        print(gcf,'-dpdf',fullfile(plotDir,[fileName,'.pdf']));
        close;
    end
    clear('timeArray','illuminanceArray','activityArray');
end

close all;

end

