function specifictimes
%SPECIFICTIMES Summary of this function goes here
%   Detailed explanation goes here

initializedependencies;

Paths = initializepaths;

load('sampleTimes.mat');

pattern = '*.cdf';
[fileNameArray,filePathArray] = searchdir(Paths.editedData,pattern);

nFile = numel(fileNameArray);

for iFile = 1:nFile
    Data = ProcessCDF(filePathArray{iFile});
    timeArray = Data.Variables.time;
    illuminanceArray = Data.Variables.illuminance;
    activityArray = Data.Variables.activity;
    subject = Data.GlobalAttributes.subjectID{1};
    subject = lower(subject);
    
    switch subject
        case 'green'
            inputTimeArray = greenSampleTimeArray;
        case 'mimosa'
            inputTimeArray = mimosaSampleTimeArray;
        otherwise
            error('Subject name not recognized');
    end
    
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
    
    xlswrite('matchedSamples.xlsx',outputCell,subject);
    
end

end


function closestIdx = closest(value,dataArray)

diffArray = abs(dataArray - value);

[~,closestIdx] = min(diffArray);

if numel(closestIdx) > 1
    closestIdx = min(closestIdx);
end

end