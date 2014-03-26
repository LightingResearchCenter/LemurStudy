function comparefiles
%COMPAREFILES Summary of this function goes here
%   Detailed explanation goes here

% Select files to compare
projectDir = '\\root\projects\Lemur''s research\2014MarchLowLightCostaRica\data';
[fileName1,dir1] = uigetfile([projectDir,filesep,'*.txt'],'First processed file');
filePath1 = fullfile(dir1,fileName1);
[fileName2,dir2] = uigetfile([projectDir,filesep,'*.txt'],'Second processed file');
filePath2 = fullfile(dir2,fileName2);

% Import the selected files
[time1,red1,green1,blue1,lux1,CLA1,activity1] = importfile(filePath1);
[time2,red2,green2,blue2,lux2,CLA2,activity2] = importfile(filePath2);

% Compare the imported data
if numel(time1) == numel(time2)
    display('Files are of equal length');
    timeErrors     = comparearrays(time1     , time2);
    redErrors      = comparearrays(red1      , red2);
    greenErrors    = comparearrays(green1    , green2);
    blueErrors     = comparearrays(blue1     , blue2);
    luxErrors      = comparearrays(lux1      , lux2);
    CLAErrors      = comparearrays(CLA1      , CLA2);
    activityErrors = comparearrays(activity1 , activity2);
    
    sumErrors = sum([timeErrors,redErrors,greenErrors,blueErrors,luxErrors,CLAErrors,activityErrors]);
    
    if sumErrors == 0
        display('No errors found');
    else
        display([num2str(sumErrors),' errors found']);
    end
else
    display('Files are not of equal length');
end


end


function numErrors = comparearrays(array1,array2)

idx = array1 ~= array2;
numErrors = sum(idx);

end