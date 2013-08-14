function MillerPlot(TI, AI, CS, days, Title, plotPosition, dateRange)
%MILLERPLOT Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.
%   time is in MATLAB date time series format
%   AI is activity index from a Daysimeter or Dimesimeter
%   CS is Circadian Stimulus from a Daysimeter or Dimesimeter
%   days is number of days experiment ran for

% Trim data to length of experiment
delta = find(TI <= days); % indices of data to keep
TI = TI(delta);
AI = AI(delta);
CS = CS(delta);

% Reshape data into columns of full days
% ASSUMES CONSTANT SAMPLING RATE
dayIdx = find(TI >= 1,1,'first') - 1;
extra = rem(length(TI),dayIdx)-1;
CS(end-extra:end) = [];
AI(end-extra:end) = [];
CS = reshape(CS,dayIdx,[]);
AI = reshape(AI,dayIdx,[]);

% Average data across days
mCS = mean(CS,2);
mAI = mean(AI,2);

% Trim time index
TI = TI(1:dayIdx);
% Convert time index into hours from start
hour = TI*24;

% Begin plotting
figure1 = gcf;

% Create axes
axes1 = axes('Parent',figure1,'XTick',0:2:24,...
    'TickDir','out',...
    'OuterPosition',plotPosition,...
    'ActivePositionProperty','outerposition');
xlim(axes1,[0 24]);
% Ymax = max([max(mAI),max(mCS)]);
% Ymax = ceil(Ymax/0.5)*0.5;
Ymax = 1;
ylim(axes1,[0 Ymax]);
box(axes1,'off');
hold(axes1,'all');

% Create custom grid
YgridPos = 0.25:0.25:(Ymax-.25);
XgridPos = 2:2:22;
GridColor = [0.8 0.8 0.8];
% Y grid lines
for i1 = 1:length(YgridPos)
    line([0 24],[YgridPos(i1),YgridPos(i1)],'Color',GridColor,'LineStyle',':');
end
% X grid lines
for i1 = 1:length(XgridPos)
    line([XgridPos(i1),XgridPos(i1)],[0 Ymax],'Color',GridColor,'LineStyle',':');
end

% Plot AI
area1 = area(axes1,hour,mAI,'LineStyle','none');
set(area1,...
    'FaceColor',[0.2 0.2 0.2],'EdgeColor','none',...
    'DisplayName','AI');

% Plot CS
plot1 = plot(axes1,hour,mCS);
set(plot1,...
    'Color',[0.6 0.6 0.6],'LineWidth',2,...
    'DisplayName','CS');

% Plot solar conditions
% load(fullfile('astronomicalData','sunrise_set.mat'),'sunRise','sunSet');
% yLims = ylim(gca);
% patch2 = plotSun(dateRange,sunRise,sunSet,yLims);

% Create legend
% legend1 = legend([area1, plot1, patch2],'Location','EastOutside');
legend1 = legend([area1, plot1],'Location','EastOutside');
set(legend1,'Orientation','vertical');


% Create x-axis label
% xlabel('hour');

% Create title
dateRangeStr = datestr(dateRange,'mm/dd/yyyy');
text2 = [dateRangeStr(1,:),' - ',dateRangeStr(2,:)];
% text3 = [num2str(days,'%.0f'),' days'];
% title([Title,'   ',text2,'   ',text3]);
title([Title,'   ',text2]);

% Close box around plot
line([0 24],[Ymax Ymax],'Color','k');
line([24 24],[0 Ymax],'Color','k');

end


function p2 = plotSun(dateRange,sunRise,sunSet,yLims)
rise1 = sunRise(find(sunRise >= dateRange(1),1,'first'));
rise2 = sunRise(find(sunRise <= dateRange(2),1,'last'));
xRise1 = (rise1 - floor(rise1))*24;
xRise2 = (rise2 - floor(rise2))*24;
p1=patch([xRise1 xRise2 xRise2 xRise1],[yLims(1) yLims(1) yLims(2) yLims(2)],'r');;
set(p1,'FaceAlpha',0.5,'EdgeColor','r',...
    'EdgeAlpha',0.5);
set1 = sunSet(find(sunSet >= dateRange(1),1,'first'));
set2 = sunSet(find(sunSet <= dateRange(2),1,'last'));
xSet1 = (set1 - floor(set1))*24;
xSet2 = (set2 - floor(set2))*24;
p2=patch([xSet1 xSet2 xSet2 xSet1],[yLims(1) yLims(1) yLims(2) yLims(2)],'r');
set(p2,'FaceAlpha',0.5,'EdgeColor','r',...
    'EdgeAlpha',0.5,'DisplayName','sun rise/set');
end

