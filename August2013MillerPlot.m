function August2013MillerPlot
%SPECIESMILLERPLOT Creates Miller Plots of data averaged across a species

load('2013AugustLemurData.mat');

% Create figure
close all;
figure1 = figure;
paperPosition = [0 0 8.5 11];
set(figure1,'PaperUnits','inches',...
    'PaperType','usletter',...
    'PaperOrientation','portrait',...
    'PaperPositionMode','manual',...
    'PaperPosition',paperPosition,...
    'Units','inches',...
    'Position',paperPosition);

% Set spacing values
xMargin = 0.5/paperPosition(3);
xSpace = 0.125/paperPosition(3);
yMargin = 0.5/paperPosition(4);
ySpace = 0.125/paperPosition(4);

% Create date stamp
dateStamp = ['Printed: ',datestr(now,'mmm. dd, yyyy HH:MM')];
datePosition = [0.8,1-yMargin,0.1,0.1];
dateHandle = annotation(figure1,'textbox',datePosition,...
    'String',dateStamp,...
    'FitBoxToText','on',...
    'HorizontalAlignment','right',...
    'LineStyle','none');
% Shift left and down
datePosition = get(dateHandle,'Position');
datePosition(1) = 1-xMargin-datePosition(3);
datePosition(2) = 1-yMargin-datePosition(4); 
set(dateHandle,'Position',datePosition);

n = 4;

groupIdx = cell(n,1); % indicies of subjects that belong to each group
groupName = cell(n,1);
timeIndex = cell(n,1);
CS1 = cell(n,1);
AI1 = cell(n,1);
dateRange = zeros(n,2);
% Set position values for plots
x = .5/8.5;
w = 8/8.5;
y0 = .5/8.5;
h = (7.5/n-.125)/8.5;
d = .125/8.5 + h;
% Young Males
groupIdx{1} = ageYears <= 2 & strcmpi('m',gender);
groupName{1} = 'Young Males (<= 2 years)';
% Young Females
groupIdx{2} = ageYears <= 2 & strcmpi('f',gender);
groupName{2} = 'Young Females (<= 2 years)';
% Old Males
groupIdx{3} = ageYears >= 20 & strcmpi('m',gender);
groupName{3} = 'Old Males (>= 20 years)';
% Old Females
groupIdx{4} = ageYears >= 20 & strcmpi('f',gender);
groupName{4} = 'Old Females (>= 20 years)';

for i1 = 1:n
    % Process data
    [timeIndex{i1},CS1{i1},AI1{i1}] = ...
        averageGroup(time(groupIdx{i1}),CS(groupIdx{i1}),AI(groupIdx{i1}));
    dateRange(i1,1) = min(cell2mat(time(groupIdx{i1})));
    dateRange(i1,2) = max(cell2mat(time(groupIdx{i1})));
    % Set figure position
    y = y0 + d*(i1-1);
    plotPosition = [x y w h];
    % Generate figure
    MillerPlot2013(timeIndex{i1},AI1{i1},CS1{i1},floor(timeIndex{i1}(end)),...
        groupName{i1},plotPosition,dateRange(i1,:));
end
% Save to disk
print(gcf,'-dpdf','August2013MillerPlots.pdf','-painters');
end

function [timeIndex,CS,AI] = averageGroup(time0,CS0,AI0)
%AVERAGESPECIES Average data from all subjects that belong to one group

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

