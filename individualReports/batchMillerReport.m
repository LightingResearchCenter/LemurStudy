function batchMillerReport
%SPECIESPHASORREPORT Generate Phasor Report for each species
%   Requires PhasorReport package
load('cleanData.mat');

n = length(ID);
close all;
for i1 = 1:n
    Title = {[commonName{i1},' (',species{i1},') ID: ',num2str(ID(i1))];[datestr(sDate(i1),'mm/dd/yyyy'),' - ',datestr(eDate(i1),'mm/dd/yyyy')]};
    millerReport(time{i1},CS{i1},AI{i1},Title,[sDate(i1),eDate(i1)]);
    % Save to disk
    fileName = fullfile('reports',[species{i1},'_',num2str(ID(i1))]);
    saveas(gcf,[fileName,'.pdf']);
    clf;
end
close all;

end

