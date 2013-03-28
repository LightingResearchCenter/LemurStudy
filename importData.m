function importData()
% IMPORTDATA Import processed Dimesimeter data for Lemurs and save as .mat

load('dimesimeterLookup.mat','ID','folder','gender','processedFile',...
    'species','startTime','stopTime','subject');

% Construct file paths
textPath = fullfile('textData',folder,processedFile);

n = length(ID);
% Preallocate variables
time = cell(n,1);
lux = cell(n,1);
CS = cell(n,1);
AI = cell(n,1);

for i1 = 1:n
    [time{i1},lux{i1},CS{i1},AI{i1}] = readData(textPath{i1},...
        startTime(i1),stopTime(i1));
end

save('lemurData.mat','ID','gender','species','subject','time','lux',...
    'CS','AI');
end

function [time,lux,CS,AI] = readData(dataPath,startTime,stopTime)
% READDATA Read in text data and trim to specified range

% Read data from text file
fid = fopen(dataPath);
data = textscan(fid, '%f%f%f%f%f%f', 'HeaderLines', 1);

% Parse variables
time0 = data{1,2} + datenum('01-Jan-1900');
lux0 = data{1,3};
CS0 = data{1,5};
AI0 = data{1,6};

% Trim data to specified range
ind = find(time0 >= startTime & time0 <= stopTime);
time = time0(ind);
AI = AI0(ind); 
lux = lux0(ind); 
CS = CS0(ind); 
end
