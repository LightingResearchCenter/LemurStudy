function scaleFactor = modifiedMillerPlot(TI,AI,CS,plotPosition,plotUnits,dateRange,color1,color2)
%MILLERPLOT Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.
%   time is in MATLAB date time series format
%   AI is activity index from a Daysimeter or Dimesimeter
%   CS is Circadian Stimulus from a Daysimeter or Dimesimeter
%   days is number of days experiment ran for

% Reshape data into columns of full days
% ASSUMES CONSTANT SAMPLING RATE
dayIdx = find(TI >= 1,1,'first') - 1;
extra = rem(length(TI),dayIdx)-1;
CS(end-extra:end) = [];
AI(end-extra:end) = [];
CS = reshape(CS,dayIdx,[]);
AI = reshape(AI,dayIdx,[]);

% Average data across days and smooth
smoothFactor = 7;
mCS = movMedian(mean(CS,2),smoothFactor);
mAI = movMedian(mean(AI,2),smoothFactor);
% scale activity
scaleFactor = 1;
mAI = mAI*scaleFactor;

% Trim time index
TI = TI(1:dayIdx);
% Convert time index into hours from start
hour = TI*24;

% Begin plotting
figure1 = gcf;

% Create axes
axes1 = axes('Parent',figure1);
ylabel('CS');
xlabel('clock time')
xlim(axes1,[0 24]);
ylim(axes1,[0 .7]);
box(axes1,'off');
set(axes1,...
    'XTick',0:6:24,...
    'XTickLabel',{'00:00';'06:00';'12:00';'18:00';'00:00'},...
    'YTick',0:.1:.7,...
    'TickDir','out',...
    'Units',plotUnits,...
    'Position',plotPosition,...
    'ActivePositionProperty','position');
hold(axes1,'all');

% Plot AI
area1 = area(hour,mAI,'LineStyle','none');
set(area1,...
    'FaceColor',color1,'EdgeColor','none',...
    'DisplayName','AI');

% Plot CS
area2 = area(hour,mCS,'LineStyle','none');
set(area2,...
    'FaceColor',color2,'LineWidth',2,...
    'DisplayName','CS');

% Plot solar conditions
load('sunrise_set.mat','sunRise','sunSet');
yLims = ylim(gca);
plotSun(dateRange,sunRise,sunSet,yLims);

end


function p2 = plotSun(dateRange,sunRise,sunSet,yLims)
rise1 = sunRise(find(sunRise >= dateRange(1),1,'first'));
rise2 = sunRise(find(sunRise <= dateRange(2),1,'last'));
xRise1 = (rise1 - floor(rise1))*24;
xRise2 = (rise2 - floor(rise2))*24;
p1=patch([xRise1 xRise2 xRise2 xRise1],[yLims(1) yLims(1) yLims(2) yLims(2)],'r');
set(p1,'EdgeColor','r');
set1 = sunSet(find(sunSet >= dateRange(1),1,'first'));
set2 = sunSet(find(sunSet <= dateRange(2),1,'last'));
xSet1 = (set1 - floor(set1))*24;
xSet2 = (set2 - floor(set2))*24;
p2=patch([xSet1 xSet2 xSet2 xSet1],[yLims(1) yLims(1) yLims(2) yLims(2)],'r');
set(p2,'EdgeColor','r','DisplayName','sun rise/set');
end

