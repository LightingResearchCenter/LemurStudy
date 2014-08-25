function analysis
%ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

initializedependencies;

Paths = initializepaths;

pattern = '*.cdf';
[fileNameArray,filePathArray] = searchdir(Paths.editedData,pattern);

% Specify location data for Costa Rica
lat = 9.933333;
lon = -84.083333;
GMToff_days = -4/24;

nFiles = numel(fileNameArray);
% [hFigure,~,~,units] = initializefigure1(1,'on');

for i1 = 1:nFiles
    Data = ProcessCDF(filePathArray{i1});
    logicalArray = logical(Data.Variables.logicalArray);
    timeArray = Data.Variables.time(logicalArray);
    illuminanceArray = Data.Variables.illuminance(logicalArray);
    csArray = Data.Variables.CS(logicalArray);
    activityArray = Data.Variables.activity(logicalArray);
    subject = Data.GlobalAttributes.subjectID{1};
    
    illuminanceArray = choptothreshold(illuminanceArray,0.005);
    
    % Find average sunrise and sunset
    dateArray = unique(floor(timeArray));
    [sunriseArray,sunsetArray] = simpleSunCycle(lat,lon,dateArray);
    sunriseArray = sunriseArray + GMToff_days;
    sunsetArray = sunsetArray + GMToff_days;
    sunrise = mean(sunriseArray - floor(sunriseArray))*24;
    sunset = mean(sunsetArray - floor(sunsetArray))*24;
    
%     % Daysigram
%     sheetTitle = ['Costa Rica - July 2014 - Subject ',subject];
%     daysigramFileID = ['subject',subject];
%     generatedaysigram(sheetTitle,timeArray,activityArray,illuminanceArray,...
%         'lux',[10^-2,10^5],14,Paths.plots,daysigramFileID)
%     
%     % Light and Health Report/ Phasor Analysis
%     figTitle = 'Costa Rica - July 2014';
%     generatereport(Paths.plots,timeArray,csArray,activityArray,...
%     illuminanceArray,subject,hFigure,units,figTitle);
%     clf;
    
    % Plot Data
    plotTitle = subject;
    
    pseudoMillerPlot(timeArray,activityArray,illuminanceArray,plotTitle,sunrise,sunset,30);
    plotFileName = ['pseuodoMillerPlot_',datestr(now,'yyyy-mm-dd_HHMM'),'_subject',subject];
    print(gcf,'-dpdf',fullfile(Paths.plots,[plotFileName,'.pdf']));
    close;
end

close all;

end

