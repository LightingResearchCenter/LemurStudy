function convertdime
%CONVERTDIME Summary of this function goes here
%   Detailed explanation goes here

initializedependencies;

Paths = initializepaths;

pattern = '*raw.txt';
[dimeNameArray,dimePathArray] = searchdir(Paths.originalData,pattern);

nDime = numel(dimeNameArray);
twoHrs_days = 2/24;
timeOffset = -6*60*60; % CST

snArray = [357;359];
subjectArray = {'Mimosa';'Green'};

for i1 = 1:nDime
    % Import data
    [ID,timeArray,Lux,CLA,CS,Activity,Rlux,Glux,Blux,cal] = CalibrateDimesimeterDownloadFile_21Feb2013(dimePathArray{i1});
    
    % Convert from EDT to CST (Troy to Costa Rica)
    timeArray = timeArray - twoHrs_days;
    
    % Find the subject
    idx = snArray == ID;
    subjectID = subjectArray{idx};
    
    switch ID
        case 357
            startTime = datenum(2014,07,10,18,00,00);
            stopTime = datenum(2014,07,23,06,00,00);
        case 359
            startTime = datenum(2014,07,11,18,00,00);
            stopTime = datenum(2014,07,19,06,00,00);
    end
    
    logicalArray = timeArray >= startTime & timeArray <= stopTime;
    
    % Import template CDF
    Data = ProcessCDF('template.cdf');
    
    % Assign data to CDF structure
    % Variables
    Data.Variables.time = timeArray(:);
    Data.Variables.timeOffset = timeOffset;
    Data.Variables.logicalArray = logicalArray(:);
    Data.Variables.red = Rlux(:);
    Data.Variables.green = Glux(:);
    Data.Variables.blue = Blux(:);
    Data.Variables.illuminance = Lux(:);
    Data.Variables.CLA = CLA(:);
    Data.Variables.CS = CS(:);
    Data.Variables.activity = Activity(:);
    Data.Variables.complianceArray = true(size(Data.Variables.time));
    Data.Variables.bedArray = true(size(Data.Variables.time));
    % Global Attributes
    Data.GlobalAttributes.creationDate{1,1} = datestr(now,'dd-mmm-yyyy HH:MM:SS.FFF');
    Data.GlobalAttributes.deviceModel{1,1} = 'dimesimeter';
    Data.GlobalAttributes.deviceSN{1,1} = num2str(ID);
    Data.GlobalAttributes.redCalibration{1,1} = cal(1);
    Data.GlobalAttributes.greenCalibration{1,1} = cal(2);
    Data.GlobalAttributes.blueCalibration{1,1} = cal(3);
    Data.GlobalAttributes.subjectID{1,1} = subjectID;
    Data.GlobalAttributes.subjectSex{1,1} = 'None';
    Data.GlobalAttributes.subjectDateOfBirth{1,1} = 'None';
    Data.GlobalAttributes.subjectMass{1,1} = 0;
    
    cdfFileName = ['0',num2str(ID),'-',datestr(now,'yyyy-mm-dd-HH-MM'),'.cdf'];
    cdfPath = fullfile(Paths.editedData,cdfFileName);
    RewriteCDF(Data,cdfPath);
end


end

