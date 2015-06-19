function analysis
%ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

initializedependencies;

Paths = initializepaths;

pattern = '*.cdf';
[fileNameArray,filePathArray] = searchdir(Paths.editedData,pattern);

lightsOn  =  6.5;
lightsOff = 18.5;

nFiles = numel(fileNameArray);
[hFigure,~,~,units] = initializefigure1(1,'on');

for i1 = 1:nFiles
    Data = ProcessCDF(filePathArray{i1});
    logicalArray = logical(Data.Variables.logicalArray);
    timeArray = Data.Variables.time(logicalArray);
    illuminanceArray = Data.Variables.illuminance(logicalArray);
    csArray = Data.Variables.CS(logicalArray);
    activityArray = Data.Variables.activity(logicalArray);
    subject = Data.GlobalAttributes.subjectID{1};
    deviceSN = Data.GlobalAttributes.deviceSN{1};
    
%     illuminanceArray = choptothreshold(illuminanceArray,0.005);
illuminanceArray = choptothreshold(illuminanceArray,0);
    
    % Daysigram
    sheetTitle = ['Nov/Dec 2014, Subject: ',subject,', Dimesimeter: ',deviceSN];
    daysigramFileID = ['subject',subject];
    generatedaysigram(sheetTitle,timeArray,activityArray,illuminanceArray,...
        'lux',[10^-2,10^5],14,Paths.plots,daysigramFileID)
    
    % Light and Health Report/ Phasor Analysis
    figTitle = 'Nov/Dec 2014';
    generatereport(Paths.plots,timeArray,csArray,activityArray,...
    illuminanceArray,subject,hFigure,units,figTitle);
    clf;
    
    % Plot Data
    plotTitle = subject;
    
    pseudoMillerPlot(timeArray,activityArray,illuminanceArray,plotTitle,lightsOn,lightsOff,30);
    plotFileName = ['pseuodoMillerPlot_',datestr(now,'yyyy-mm-dd_HHMM'),'_subject',subject];
    print(gcf,'-dpdf',fullfile(Paths.plots,[plotFileName,'.pdf']));
    close;
end

close all;

end

