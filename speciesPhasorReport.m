function speciesPhasorReport
%SPECIESPHASORREPORT Generate Phasor Report for each species
%   Requires PhasorReport package

dataDir = '\\root\projects\Lemur''s-Research\Lemur Data';
dataFile = 'speciesData.mat';
dataPath = fullfile(dataDir,dataFile);

reportDir = fullfile(dataDir,'phasorReports');

load(dataPath);
addpath('PhasorReport');

n = length(unqSpecies);
close all;
for i1 = 1:n
    idx = spcIdx{i1};
    Title = {[unqName{i1},' (',unqSpecies{i1},')'];[datestr(dateRange(i1,1),'mm/dd/yyyy'),' - ',datestr(dateRange(i1,2),'mm/dd/yyyy')]};
    PhasorReport(timeIndex{i1}+dateRange(i1,1),CS1{i1},AI1{i1},time(idx),CS(idx),AI(idx),Title,dateRange(i1,:));
    % Save to disk
    reportPath = fullfile(reportDir,unqSpecies{i1});
    print(gcf,'-dpdf',[reportPath,'.pdf'],'-painters');
    close;
end


end

