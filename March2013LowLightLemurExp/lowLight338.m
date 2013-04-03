load('Dime338pendant_01Apr2013Calibrated.mat','time','Lux','Activity');
% Set Lux values below 0.005 to 0.005
idx1 = Lux < 0.005;
Lux(idx1) = 0.005;
% Set start dates of experiments
Y = 2013;
M = 3;
sDateVec = [Y, M,  1, 0, 0, 0;...
            Y, M, 15, 0, 0, 0;...
            Y, M, 18, 0, 0, 0;...
            Y, M, 21, 0, 0, 0;...
            Y, M, 24, 0, 0, 0];
sDate = datenum(sDateVec);
% Set end dates of experiments
eDate = circshift(sDate,-1);
eDate(end) = datenum([Y,M,26,0,0,0]);
Title = 'SN338';
close all;
% Smooth activity for visual aesthetics
n = length(sDate);
for i1 = 1:n
    idx2 = time >= sDate(i1) & time < eDate(i1);
    days = ceil(eDate(i1)-sDate(i1));
    pseudoMillerPlot(time(idx2), Activity(idx2), Lux(idx2), days, Title)
    fileName = datestr(sDate(i1),'YYYY_MM_DD');
    print(gcf,'-dpdf',fullfile(Title,[fileName,'.pdf']));
    close;
end