function Paths = initializepaths
%INITIALIZEPATHS Prepare GSA folder and file paths
%   Detailed explanation goes here

% Preallocate output structure
Paths = struct(...
    'project'       ,'',...
    'originalData'  ,'',...
    'editedData'    ,'',...
    'results'       ,'',...
    'plots'         ,'',...
    'logs'          ,'');

% Set project directory
Paths.project = fullfile([filesep,filesep],'root','projects','Lemur''s-Research','2014JulyCostaRica');
% Check that it exists
if exist(Paths.project,'dir') ~= 7 % 7 = folder
    error(['Cannot locate the folder: ',Paths.project]);
end

% Specify session specific directories
Paths.originalData = fullfile(Paths.project,'originalData');
Paths.editedData   = fullfile(Paths.project,'editedData');
Paths.results      = fullfile(Paths.project,'results');
Paths.plots        = fullfile(Paths.project,'plots');
Paths.logs         = fullfile(Paths.project,'logs');

end

