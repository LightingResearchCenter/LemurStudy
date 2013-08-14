function august2013PhasorReport
%SPECIESPHASORREPORT Generate Phasor Report for each species
%   Requires PhasorReport package
addpath('PhasorReport');
load('2013AugustLemurData.mat');

n = length(dimeSN);
close all;
for i1 = 1:n
    Title = {['Name: ',name{i1},', Gender: ',gender{i1},', Age [years]: ',num2str(ageYears(i1))];...
        [datestr(time{i1}(1),'mm/dd/yyyy HH:MM'),' - ',datestr(time{i1}(end),'mm/dd/yyyy HH:MM')]};
    PhasorReport(time{i1},CS{i1},AI{i1},Title);
    % Save to disk
    fileName = fullfile('2013AugustPhasorReports',name{i1});
    print(gcf,'-dpdf',[fileName,'.pdf'],'-painters');
    close;
end


end

