function may2015lowlight
%MAY2015LOWLIGHT Summary of this function goes here
%   Detailed explanation goes here

%  
% Lights were set at 12/12 (0630-1830) with the moonlit night light coming 
% on at 1830 and going off at 0630 when the daylight came on. Moonlit 
% nights were May 19, 20, 21 and 25, 26, 27. The 28th was dark and they 
% were taken out morning of 29th


close all;

initializedependencies;

projectDir = fullfile([filesep,filesep,'ROOT'],'projects',...
    'Lemur''s-Research','2015MayLowLight');

dataDir = fullfile(projectDir,'originalData');

plotDir = fullfile(projectDir,'plots');

dimeSN = {357;359};
animalName = {'357';'359'};
animalSex = {'';''};

stage = {'moonlit-1';...
         'dark-1';...
         'moonlit-2';...
         'dark-2'};

nStages = numel(stage);

% Set main lights on/off
lightsOn = 6.5;
lightsOff = 18.5;

filePath = ...
    {fullfile(dataDir,'Lemurs_Dime357pendant_SubjectLemur2_02Jun2015raw.txt');...
     fullfile(dataDir,'Lemurs_Dime359pendant_SubjectLemur1_02Jun2015raw.txt')};

% Set start dates of experiments
Y = 2015;
M = 5;
sDateVec = [Y, M, 19, lightsOn, 0, 0;...
            Y, M, 22, lightsOff, 0, 0;...
            Y, M, 25, lightsOff, 0, 0;...
            Y, M, 28, lightsOff, 0, 0];
sDate = datenum(sDateVec);
% Set end dates of experiments
eDateVec = [Y, M, 22, lightsOff, 0, 0;...
            Y, M, 25, lightsOff, 0, 0;...
            Y, M, 28, lightsOff, 0, 0;...
            Y, M, 29, lightsOn, 0, 0;];
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
    
    for i2 = 1:nStages-1
        idx2 = timeArray >= sDate(i2) & timeArray < eDate(i2);
        
        % Light and Health Report/ Phasor Analysis
        figTitle = 'May 2015 ';
        
        observation = idx2;
        bed = false(size(timeArray));
        compliance = true(size(timeArray));
        masks = eventmasks('observation',observation,'bed',bed,'compliance',compliance);
        
        light = lightmetrics('cla',CLA,'cs',csArray,'illuminance',illuminanceArray);
        
        epoch = samplingrate(180,'seconds');
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

