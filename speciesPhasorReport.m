function speciesPhasorReport
%SPECIESPHASORREPORT Generate Phasor Report for each species
%   Requires PhasorReport package
load('speciesData.mat');
addpath('C:\Users\jonesg5\Documents\GitHub\PhasorReport');

PhasorReport(timeIndex{1},CS1{1},AI1{1},unqSpecies{1},floor(max(timeIndex{1})))
end

