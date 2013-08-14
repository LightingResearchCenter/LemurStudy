function August2013ImportData
%IMPORTDATA Import processed Dimesimeter data for Lemurs and save as .mat

load('2013AugustLookUp.mat','ageYears','dimeSN','gender','name');
startPath = '\\root\projects\Lemur''s research\2013AugustAging';
folderName = uigetdir(startPath,'Select folder of data');

n = length(dimeSN);
% Preallocate variables
time = cell(n,1);
lux = cell(n,1);
CS = cell(n,1);
AI = cell(n,1);

startTime = datenum(2013,8,6,6,0,0);
stopTime = datenum(2013,8,13,6,0,0);

for i1 = 1:n
    % Construct file paths
    textPath = fullfile(folderName,...
        ['Dime',num2str(dimeSN(i1)),'_14Aug2013processed.txt']);
    [time{i1},lux{i1},CS{i1},AI{i1}] = readData(textPath,startTime,stopTime);
end

save('2013AugustLemurData.mat','ageYears','dimeSN','gender','name',...
    'time','lux','CS','AI');
end

function [time,lux,CS,AI] = readData(dataPath,startTime,stopTime)
%READDATA Read in text data and trim to specified range

% Read data from text file
fid = fopen(dataPath);
data = textscan(fid, '%f%f%f%f%f%f', 'HeaderLines', 1);

% Parse variables
time0 = data{1,2} + 693960;
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
