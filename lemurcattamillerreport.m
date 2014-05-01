function lemurcattamillerreport
%SPECIESPHASORREPORT Generate Phasor Report for each species
%   Requires PhasorReport package

addpath('publication');

dataDir = '\\root\projects\Lemur''s-Research\Lemur Data';
dataFile = 'combinedLemurCatta.mat';
dataPath = fullfile(dataDir,dataFile);

reportDir = fullfile(dataDir,'combinedLemurCatta');

load(dataPath);

n = 2;
close all;
for i1 = 1:n
    idx = selectedIdx{i1};
    Title = {[unqName{i1},' (',lemurCatta,')'];[datestr(dateRange(i1,1),'mm/dd/yyyy'),' - ',datestr(dateRange(i1,2),'mm/dd/yyyy')]};
    millerReport(timeIndex{i1}+dateRange(i1,1),CS1{i1},AI1{i1},time(idx),CS(idx),AI(idx),Title,dateRange(i1,:));
    % Save to disk
    reportPath = fullfile(reportDir,unqName{i1});
    saveas(gcf,[reportPath,'.pdf']);
    clf;
end
close all;

end

