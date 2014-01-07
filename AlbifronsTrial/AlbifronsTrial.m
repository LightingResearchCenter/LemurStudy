function AlbifronsTrial
%ALBIFRONSTRIAL Summary of this function goes here
%   Detailed explanation goes here

close all;

addpath('IO');

projectDir = fullfile([filesep,filesep,'ROOT'],'projects',...
    'Lemur''s research','2014-01-06_AlbifronsTrial');

filePath = ...
    {fullfile(projectDir,'Dime336pendant_Subject336_06Jan2014.txt');...
     fullfile(projectDir,'Dime338pendant_Subject338_06Jan2014.txt')};
dimeSN = {336;338};
name = {'Matthan';'Kish'};

stage = {'habituation';...
         'dim1';...
         'dark1';...
         'dim2';...
         'dark2'};
nStages = numel(stage);

% Set start dates of experiments
Y = 2013;
M = 12;
sDateVec = [Y, M,  5, 0, 0, 0;...
            Y, M, 20, 0, 0, 0;...
            Y, M, 23, 0, 0, 0;...
            Y, M, 26, 0, 0, 0;...
            Y, M, 29, 0, 0, 0];
sDate = datenum(sDateVec);
% Set end dates of experiments
eDate = circshift(sDate,-1);
eDate(end) = datenum([2014,1,2,9,20,0]);

% Set lights on/off
lightsOn = 6.5;
lightsOff = 18.5;

buffer = 0;

for i1 = 1:2
    
    [time,Lux,~,~,AI] = importDime(filePath{i1},dimeSN{i1});
    
    % Set Lux values below 0.005 to 0.005
    idx1 = Lux < 0.005;
    Lux(idx1) = 0.005;
    
    for i2 = 1:nStages
        idx2 = time >= sDate(i2) & time < eDate(i2);
        days = ceil(eDate(i2)-sDate(i2));
        Title = [num2str(dimeSN{i1}),' - ',name{i1},' - ',stage{i2}];
        pseudoMillerPlot(time(idx2),AI(idx2),Lux(idx2),days,Title,lightsOn,lightsOff,buffer);
        fileName = [num2str(dimeSN{i1}),'_',datestr(sDate(i2),'yyyy-mm-dd'),'_',stage{i2}];
        print(gcf,'-dpdf',fullfile(projectDir,[fileName,'.pdf']));
        close;
    end
end


end

