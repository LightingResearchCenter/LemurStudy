function batchanalysis
%BATCHANALYSIS Summary of this function goes here
%   Detailed explanation goes here

% Prepare file paths
projectDir = fullfile([filesep,filesep],'root','projects',...
    'Lemur''s research','2014MarchLowLightCostaRica');

dataDir = fullfile(projectDir,'data');

fileNameArray = {...
    'Dime357pendant_SubjectJuniper_25Mar2014_download1rawCalibrated.txt';...
    'Dime358pendant_SubjectMimosa_25Mar2014_download1rawCalibrated.txt';...
    'Dime359pendant_SubjectTree_25Mar2014_download1rawCalibrated.txt'};

filePathArray = fullfile(dataDir,fileNameArray);

indexPath = fullfile(projectDir,'index.xlsx');

% Import the index
index = struct;
[index.dimesimeter,index.subject,index.startTime,index.stopTime] = ...
    importindex(indexPath);

% Extract subject info
subjectArray = regexprep(fileNameArray,'.*Subject([a-zA-Z0-9]*)_.*','$1');
dimesimeterArray = str2double(regexprep(fileNameArray,'Dime(\d*)pendant.*','$1'));

% Specify location data for Costa Rica
lat = 9.933333;
lon = -84.083333;
GMToff = -4;

% Preallocate variables
n = numel(filePathArray);
data = struct;

for i1 = 1:n
    % Match index entry
    indexEntry = index.dimesimeter == dimesimeterArray(i1);
    startTime = index.startTime(indexEntry);
    stopTime = index.stopTime(indexEntry);
    
    % Import Dimesimeter data and prepare for analysis
    [data.time,~,~,~,data.lux,data.CLA,data.activity] = ...
        importfile(filePathArray{i1});
    data.time = data.time - 1/24; % Convert from EST to CST
    data = trimdata(data,startTime,stopTime);
    data.lux = choptothreshold(data.lux,0.005);
    data.CLA = choptothreshold(data.CLA,0.005);
    
    % Find average sunrise and sunset
    dateArray = unique(floor(data.time));
    [sunriseArray,sunsetArray] = simpleSunCycle(lat,lon,dateArray);
    sunrise = mean(sunriseArray - floor(sunriseArray))*24;
    sunset = mean(sunsetArray - floor(sunsetArray))*24;
    sunrise = sunrise + GMToff;
    sunset = sunset + GMToff;
    
    % Plot Data
    plotTitle = subjectArray{i1};
    pseudoactigram(data.time,data.activity,data.lux,plotTitle);
    plotFileName = ['actigram_',subjectArray{i1},'_',datestr(startTime,'yyyy-mm-dd')];
    print(gcf,'-dpdf',fullfile(projectDir,[plotFileName,'.pdf']));
    close;
    
    pseudoMillerPlot(data.time,data.activity,data.lux,plotTitle,sunrise,sunset,30);
    plotFileName = [subjectArray{i1},'_',datestr(startTime,'yyyy-mm-dd')];
    print(gcf,'-dpdf',fullfile(projectDir,[plotFileName,'.pdf']));
    close;
end


end

