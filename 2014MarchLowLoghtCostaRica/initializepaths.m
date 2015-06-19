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
Paths.project = fullfile([filesep,filesep],'root','projects','Lemur''s-Research','2014MarchLowLightCostaRica');
% Check that it exists
if exist(Paths.project,'dir') ~= 7 % 7 = folder
    error(['Cannot locate the folder: ',Paths.project]);
end

% Specify session specific directories
Paths.originalData = fullfile(Paths.project,'data');
Paths.editedData   = fullfile(Paths.project,'data');
Paths.results      = Paths.project;
Paths.plots        = Paths.project;
Paths.logs         = Paths.project;

end

