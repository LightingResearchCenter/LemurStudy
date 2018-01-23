function initializedependencies
%INITIALIZEDEPENDENCIES Add necessary repos to working path
%   Detailed explanation goes here

% Find full path to github directory
[parentDir,~,~] = fileparts(pwd);
[githubDir,~,~] = fileparts(parentDir);

% Contruct repo paths
dimePath        = 'IO';
cdfPath         = fullfile(githubDir,'LRC-CDFtoolkit');
phasorPath      = fullfile(githubDir,'PhasorAnalysis');
daysigramPath   = fullfile(githubDir,'DaysigramReport');
lightHealthPath = fullfile(githubDir,'LHIReport');
croppingPath    = fullfile(githubDir,'DaysimeterCropToolkit');
dfaPath         = fullfile(githubDir,'DetrendedFluctuationAnalysis');

circadian       = fullfile(githubDir,'circadian');

% Enable repos
addpath(dimePath,cdfPath,phasorPath,daysigramPath,lightHealthPath,croppingPath,dfaPath,circadian);

end

