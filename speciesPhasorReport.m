function speciesPhasorReport
%SPECIESPHASORREPORT Generate Phasor Report for each species
load('speciesData.mat');
addpath('C:\Users\jonesg5\Documents\GitHub\DaysimeterReport');

DaysimeterReport(unqSpecies{1},timeIndex{1},CS1{1},CS1{1},AI1{1},floor(max(timeIndex{1})))
end

