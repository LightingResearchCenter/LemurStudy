function speciesMillerPlot
%SPECIESMILLERPLOT Creates Miller Plots of data averaged across a species

load('cleanData.mat','species','subject','time','CS','AI');
load(fullfile('astronomicalData','sunrise_set.mat'),'sunRise','sunSet');

unqSpecies = unique(species);
n = length(unqSpecies);

spcIdx = cell(n,1); % indicies of subjects that belong to each species
timeIndex = cell(n,1);
CS1 = cell(n,1);
AI1 = cell(n,1);
close all;
for i1 = 1:n
    spcIdx{i1} = find(strcmp(unqSpecies{i1},species) == 1);
    % Process data
    [timeIndex{i1},CS1{i1},AI1{i1}] = averageSpecies(time(spcIdx{i1}),...
        CS(spcIdx{i1}),AI(spcIdx{i1}));
    % Generate figure
    MillerPlot(timeIndex{i1},AI1{i1},CS1{i1},floor(timeIndex{i1}(end)),...
        unqSpecies{i1});
    % Plot solar and lunar conditions
    yLims = ylim(gca);
    plotSun(time{i1},max(timeIndex{i1}),sunRise,sunSet,yLims);
    % Save to disk
    print(gcf,'-dpdf',fullfile('speciesMillerPlots',[unqSpecies{i1},...
        '.pdf']));
    close;
end

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
CS3 = cell2mat(CS2);
AI3 = cell2mat(AI2);
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

function plotSun(time,days,sunRise,sunSet,yLims)
rise1 = sunRise(find(sunRise >= time(1),1,'first'));
rise2 = sunRise(find(sunRise <= time(1)+days,1,'last'));
xRise1 = (rise1 - floor(rise1))*24;
xRise2 = (rise2 - floor(rise2))*24;
p1=patch([xRise1 xRise2 xRise2 xRise1],[yLims(1) yLims(1) yLims(2) yLims(2)],'r');;
set(p1,'FaceAlpha',0.5,'EdgeColor','none');
set1 = sunSet(find(sunSet >= time(1),1,'first'));
set2 = sunSet(find(sunSet <= time(1)+days,1,'last'));
xSet1 = (set1 - floor(set1))*24;
xSet2 = (set2 - floor(set2))*24;
p2=patch([xSet1 xSet2 xSet2 xSet1],[yLims(1) yLims(1) yLims(2) yLims(2)],'r');
set(p2,'FaceAlpha',0.5,'EdgeColor','none');
end

