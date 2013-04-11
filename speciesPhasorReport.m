function speciesPhasorReport
%SPECIESPHASORREPORT Generate Phasor Report for each species
%   Requires PhasorReport package
load('speciesData.mat');
addpath('C:\Users\jonesg5\Documents\GitHub\PhasorReport');

n = length(unqSpecies);
close all;
for i1 = 1:n
    PhasorReport(timeIndex{i1},CS1{i1},AI1{i1},unqSpecies{i1})
    % Save to disk
    fileName = fullfile('phasorReports',unqSpecies{i1});
    print(gcf,'-dpdf',[fileName,'.pdf'],'-r200');
    print(gcf,'-dpng',[fileName,'.png'],'-r200');
    print(gcf,'-dtiffn',[fileName,'.tif'],'-r200');
    close;
end


end

