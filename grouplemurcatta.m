function grouplemurcatta

dataDir = '\\root\projects\Lemur''s-Research\Lemur Data';
dataFile = 'cleanData.mat';
dataPath = fullfile(dataDir,dataFile);
saveFile = 'combinedLemurCatta.mat';
savePath = fullfile(dataDir,saveFile);

load(dataPath,'species','commonName','subject','ID','time','CS','AI','sDate','eDate');

lemurCatta = 'Lemur catta';
indoorId = [248,251];
outdoorId = [204,250];
n = 2;

spcIdx = strcmp(lemurCatta,species);
selectedIdx = cell(n,1);
unqName = cell(n,1);
timeIndex = cell(n,1);
CS1 = cell(n,1);
AI1 = cell(n,1);
dateRange = zeros(n,2);

for i1 = 1:n
    switch i1
        case 1
            idIdx = (ID == indoorId(1)) | (ID == indoorId(2));
            housing = 'Restricted to Indoors';
        case 2
            idIdx = (ID == outdoorId(1)) | (ID == outdoorId(2));
            housing = 'Unrestricted Access to Outdoors';
    end
    selectedIdx{i1} = spcIdx & idIdx;
    unqName(i1) = strcat(unique(commonName(selectedIdx{i1})),' ',housing);
    % Process data
    [timeIndex{i1},CS1{i1},AI1{i1}] = ...
        averageSpecies(time(selectedIdx{i1}),CS(selectedIdx{i1}),AI(selectedIdx{i1}));
    dateRange(i1,1) = min(sDate(selectedIdx{i1}));
    dateRange(i1,2) = max(eDate(selectedIdx{i1}));
end
% Save to disk
save(savePath);
end

function [timeIndex,CS,AI] = averageSpecies(time0,CS0,AI0)
%AVERAGESPECIES Average data from all subjects that belong to one species

% Pre-process input data
[timeIndex1,CS1,AI1] = shortestTime(time0,CS0,AI0);
timeIndex2 = matchSampling(timeIndex1);
CS2 = matchSampling(CS1);
AI2 = matchSampling(AI1);

% Average data
timeIndex = timeIndex2{1};
CS3 = cell2mat(CS2');
AI3 = cell2mat(AI2');
CS = mean(CS3,2);
AI = mean(AI3,2);

end

function [timeIndex,CS2,AI2] = shortestTime(time,CS,AI)
%SHORTESTTIME Matches data time scale to shortest set
%   time is a cell array containing date arrays
%   returns time indexs relative to first midnight
%   function is independent of data sampling rates

n = length(time);
runTime = zeros(n,1);
timeIndex0 = cell(n,1);
timeIndex1 = cell(n,1);
CS1 = cell(n,1);
AI1 = cell(n,1);
% Find run time in whole days
for i2 = 1:n
    timeIndex0{i2} = time{i2} - ceil(time{i2}(1));
    idx1 = timeIndex0{i2} >= 0;
    timeIndex1{i2} = timeIndex0{i2}(idx1);
    runTime(i2) = floor(timeIndex1{i2}(end));
    
    % Trim CS and AI
    CS1{i2} = CS{i2}(idx1);
    AI1{i2} = AI{i2}(idx1);
end

leastDays = min(runTime);

% Trim time data to length of shortest
timeIndex = cell(n,1);
CS2 = cell(n,1);
AI2 = cell(n,1);
for i2 = 1:n
    idx2 = timeIndex1{i2} <= leastDays;
    timeIndex{i2} = timeIndex1{i2}(idx2);
    CS2{i2} = CS1{i2}(idx2);
    AI2{i2} = AI1{i2}(idx2);
end

end

function data = matchSampling(data0)
%MATCHSAMPLING Matches data sampling rates using decimation
%   assumes data sets have already been shortened to the same time scale
%   data0 must be cell array of double arrays

% Find the population size of each data set
n = length(data0);
population = zeros(n,1);
for i1 = 1:n
    population(i1) = length(data0{i1});
end

minPop = min(population);
maxPop = max(population);

maxR = max(floor(population/minPop));

% Match sampling data rate of all sets to least populated
data = cell(n,1);
if max(maxR) > 1
    minPop = maxPop/maxR;
end
r = population/minPop;
for i2 = 1:n
    if r(i2) == 1
        data{i2} = data0{i2};
    elseif 1 < r(i2) < 2
        data{i2} = data0{i2}(1:minPop);
    else
        data{i2} = decimate(data0{i2},r(i2));
    end
end

end

