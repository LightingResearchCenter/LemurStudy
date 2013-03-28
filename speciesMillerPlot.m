function speciesMillerPlot
%SPECIESMILLERPLOT Creates Miller Plots of data averaged across a species

load('lemurData.mat','ID','gender','species','subject','time','CS','AI');

unqSpecies = unique(species);
n = length(unqSpecies);

% Preallocate variables
spcIdx = cell(n,1); % indicies of subjects that belong to each species
for i1 = 1:n
    spcIdx{i1} = find(strcmp(unqSpecies{i1},species) == 1);
    averageSpecies(time(spcIdx{i1}),CS(spcIdx{i1}),AI(spcIdx{i1}));
end

end

function averageSpecies(time0,CS0,AI0)
%AVERAGESPECIES Average data from all subjects that belong to one species

[leastDays,timeIndex] = shortestTime(time0);

end

function [leastDays,timeIndex] = shortestTime(times)
%SHORTESTTIME Finds the least number of days in multiple arrays of dates
%   times is a cell array containing date arrays
%   returns time

n = length(times);
runTime = zeros(n,1);
timeIndex0 = cell(n,1);
% Find run time in whole days
for i1 = 1:n
    timeIndex0{i1} = times{i1} - times{i1}(1);
    runTime(i1) = floor(timeIndex0{i1}(end));
end

leastDays = min(runTime);

timeIndex = cell(n,1);
for i1 = 1:n
    idx = timeIndex0{i1} <= leastDays;
    timeIndex{i1} = timeIndex0{i1}(idx);
end

end

