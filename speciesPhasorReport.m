function speciesPhasorReport
%SPECIESPHASORREPORT Generate Phasor Report for each species
%   Requires PhasorReport package
load('speciesData.mat');
addpath('PhasorReport');

n = length(unqSpecies);
close all;
for i1 = 1:n
    idx = spcIdx{i1};
    Title = {[unqName{i1},' (',unqSpecies{i1},')'];[datestr(dateRange(i1,1),'mm/dd/yyyy'),' - ',datestr(dateRange(i1,2),'mm/dd/yyyy')]};
    PhasorReport(timeIndex{i1}+dateRange(i1,1),CS1{i1},AI1{i1},time(idx),CS(idx),AI(idx),Title,dateRange(i1,:));
    % Save to disk
    fileName = fullfile('phasorReports',unqSpecies{i1});
    print(gcf,'-dpdf',[fileName,'.pdf'],'-painters');
    close;
end


end

