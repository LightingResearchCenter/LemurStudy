function March2013LowLight
%MARCH2013LOWLIGHT Summary of this function goes here
%   Detailed explanation goes here

close all;

[parentDir,~,~] = fileparts(pwd);
addpath(parentDir);

projectDir = fullfile([filesep,filesep,'ROOT'],'projects',...
    'Lemur''s research','March2013LowLightLemurExp');

filePath = ...
    {fullfile(projectDir,'Dime336pendant_01Apr2013Calibrated.mat');...
     fullfile(projectDir,'Dime338pendant_01Apr2013Calibrated.mat')};
dimeSN = {336;338};

stage = {'habituation';...
         'dim1';...
         'dark1';...
         'dim2';...
         'dark2'};
nStages = numel(stage);

% Set lights on/off
lightsOn = 5.25;
lightsOff = 17.25;

% Set start dates of experiments
Y = 2013;
M = 3;
sDateVec = [Y, M,  1, lightsOff, 0, 0;...
            Y, M, 14, lightsOff, 0, 0;...
            Y, M, 17, lightsOff, 0, 0;...
            Y, M, 20, lightsOff, 0, 0;...
            Y, M, 23, lightsOff, 0, 0];
sDate = datenum(sDateVec);
% Set end dates of experiments
eDateVec = [Y, M, 14, lightsOff, 0, 0;...
            Y, M, 17, lightsOff, 0, 0;...
            Y, M, 20, lightsOff, 0, 0;...
            Y, M, 23, lightsOff, 0, 0;...
            Y, M, 25, lightsOff, 0, 0];
eDate = datenum(eDateVec);

buffer = 0;

for i1 = 1:2
    
    load(filePath{i1},'time','Lux','Activity');
    
    % Set Lux values below 0.005 to 0.005
    Lux = choptothreshold(Lux,0.0001);
    
    for i2 = 1:nStages
        idx2 = time >= sDate(i2) & time < eDate(i2);
        days = ceil(eDate(i2)-sDate(i2));
        Title = [num2str(dimeSN{i1}),' - ',stage{i2}];
        pseudoMillerPlot(time(idx2),Activity(idx2),Lux(idx2),days,Title,lightsOn,lightsOff,buffer);
        fileName = [num2str(dimeSN{i1}),'_',datestr(sDate(i2),'yyyy-mm-dd'),'_',stage{i2}];
        print(gcf,'-dpdf',fullfile(projectDir,'testPlots',[fileName,'.pdf']));
        close;
    end
    clear('time','Lux','Activity');
end


end

