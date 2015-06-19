function specifictimes
%SPECIFICTIMES Summary of this function goes here
%   Detailed explanation goes here

initializedependencies;

Paths = initializepaths;

sampleTimesFile = fullfile(Paths.project,'sampleTimes.mat');
load(sampleTimesFile);

fileNameArray = {...
    'Dime357pendant_SubjectJuniper_25Mar2014_download1rawCalibrated.txt';...
    'Dime358pendant_SubjectMimosa_25Mar2014_download1rawCalibrated.txt';...
    'Dime359pendant_SubjectTree_25Mar2014_download1rawCalibrated.txt'};

filePathArray = fullfile(Paths.originalData,fileNameArray);

indexPath = fullfile(Paths.project,'index.xlsx');

% Import the index
index = struct;
[index.dimesimeter,index.subject,index.startTime,index.stopTime] = ...
    importindex(indexPath);

% Extract subject info
subjectArray = regexprep(fileNameArray,'.*Subject([a-zA-Z0-9]*)_.*','$1');
dimesimeterArray = str2double(regexprep(fileNameArray,'Dime(\d*)pendant.*','$1'));

iFile = 2;

% Match index entry
indexEntry = index.dimesimeter == dimesimeterArray(iFile);
startTime = index.startTime(indexEntry);
stopTime = index.stopTime(indexEntry);

% Import Dimesimeter data and prepare for analysis
[data.time,~,~,~,data.lux,data.CLA,data.activity] = importfile(filePathArray{iFile});
data.time = data.time - 1/24; % Convert from EST to CST

timeArray = data.time;
illuminanceArray = data.lux;
activityArray = data.activity;
subject = 'mimosa';

inputTimeArray = mimosaSampleTimeArray;
inputTimeArray = inputTimeArray(~isnan(inputTimeArray));

nSample = numel(inputTimeArray);
outputTimeArray = zeros(size(inputTimeArray));
sampleIlluminanceArray = zeros(size(inputTimeArray));
sampleActivityArray = zeros(size(inputTimeArray));
for iSample = 1:nSample
    closestIdx = closest(inputTimeArray(iSample),timeArray);
    outputTimeArray(iSample) = timeArray(closestIdx);
    sampleIlluminanceArray(iSample) = illuminanceArray(closestIdx);
    sampleActivityArray(iSample) = activityArray(closestIdx);
end

try
inputTimeArray = cellfun(@datestr,num2cell(inputTimeArray),'UniformOutput',false);
catch err
    err
end
outputTimeArray = cellfun(@datestr,num2cell(outputTimeArray),'UniformOutput',false);
sampleIlluminanceArray = num2cell(sampleIlluminanceArray);
sampleActivityArray = num2cell(sampleActivityArray);

dataCell = [inputTimeArray,outputTimeArray,sampleIlluminanceArray,sampleActivityArray];
header = {'logger time','closest dimesimeter time','illuminance (lux)','activity (AI)'};
outputCell = [header;dataCell];

outputFile = fullfile(Paths.results,'march2014-MatchedSamples.xlsx');
xlswrite(outputFile,outputCell,subject);


end


function closestIdx = closest(value,dataArray)

diffArray = abs(dataArray - value);

[~,closestIdx] = min(diffArray);

if numel(closestIdx) > 1
    closestIdx = min(closestIdx);
end

end