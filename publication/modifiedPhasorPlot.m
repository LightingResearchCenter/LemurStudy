function modifiedPhasorPlot(theta,rho,plotPosition,color1,plotUnits)
%MODIFIEDPHASORPLOT Summary of this function goes here
%   Detailed explanation goes here

% Set parameters
rhoLim = .75; % radius limit
axesLS = '-'; % axes line style
axesLW = .25; % axes line width in points
plotLS = '-'; % axes line style
plotLW = 1; % axes line width in points
ah = .125; % size of arrow head

% Create axes
axesHandle = axes;
set(axesHandle,...
    'Units',plotUnits,...
    'Position',plotPosition,...
    'ActivePositionProperty','position',...
    'XLim',[-rhoLim,rhoLim],...
    'YLim',[-rhoLim,rhoLim],...
    'DataAspectRatio',[1,1,1],...
    'Visible','off');

% Plot axes lines
% X-axis
line([-rhoLim,rhoLim],[0,0],...
    'Color',color1,...
    'LineStyle',axesLS,...
    'LineWidth',axesLW);
% Y-axis
line([0,0],[-rhoLim,rhoLim],...
    'Color',color1,...
    'LineStyle',axesLS,...
    'LineWidth',axesLW);

% Plot data
% convert from polar to cartesian
x = (rho-.5*ah)*cos(theta);
y = (rho-.5*ah)*sin(theta);
% plot line
line([0,x],[0,y],...
    'Color',color1,...
    'LineStyle',plotLS,...
    'LineWidth',plotLW);
% create filled arrow head
x0 = rho*cos(theta);
y0 = rho*sin(theta);

x1 = x0-ah*cos(theta);
y1 = y0-ah*sin(theta);

x2 = x1-.5*ah*cos(pi/2-theta);
y2 = y1+.5*ah*sin(pi/2-theta);

x3 = x1+.5*ah*cos(pi/2-theta);
y3 = y1-.5*ah*sin(pi/2-theta);

patch([x0,x2,x3],[y0,y2,y3],color1);

end

