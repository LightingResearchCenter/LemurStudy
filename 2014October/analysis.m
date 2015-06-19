function analysis
%ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

initializedependencies;

Paths = initializepaths;

pattern = '*.cdf';
[fileNameArray,filePathArray] = searchdir(Paths.editedData,pattern);



nFiles = numel(fileNameArray);
[hFigure,~,~,units] = initializefigure1(1,'on');

for i1 = 1:nFiles
    Data = ProcessCDF(filePathArray{i1});
%     logicalArray = logical(Data.Variables.logicalArray);
    logicalArray = true(size(Data.Variables.logicalArray));
    timeArray = Data.Variables.time(logicalArray);
    illuminanceArray = Data.Variables.illuminance(logicalArray);
    csArray = Data.Variables.CS(logicalArray);
    activityArray = Data.Variables.activity(logicalArray);
    subject = Data.GlobalAttributes.subjectID{1};
    
    illuminanceArray = choptothreshold(illuminanceArray,0.005);
    
    % Daysigram
    sheetTitle = ['October 2014 - Subject ',subject];
    daysigramFileID = ['subject',subject];
    generatedaysigram(sheetTitle,timeArray,activityArray,illuminanceArray,...
        'lux',[10^-2,10^5],14,Paths.plots,daysigramFileID)
    
    % Light and Health Report/ Phasor Analysis
    figTitle = 'October 2014';
    generatereport(Paths.plots,timeArray,csArray,activityArray,...
    illuminanceArray,subject,hFigure,units,figTitle);
    clf;
    
    Plot Data
    plotTitle = subject;
    
    pseudoMillerPlot(timeArray,activityArray,illuminanceArray,plotTitle,sunrise,sunset,30);
    plotFileName = ['pseuodoMillerPlot_',datestr(now,'yyyy-mm-dd_HHMM'),'_subject',subject];
    print(gcf,'-dpdf',fullfile(Paths.plots,[plotFileName,'.pdf']));
    close;
end

close all;

end

