function pseudoMillerPlot(timeArray,activityArray,luxArray,days,Title,lightStart,lightStop,buffer)
%MILLERPLOT Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.
%   time is in MATLAB date time series format
%   AI is activity index from a Daysimeter or Dimesimeter
%   lux is illuminance
%   days is number of days experiment ran for

[activity,lux] = lightdarkcomparison(timeArray,activityArray,luxArray,lightStart,lightStop,buffer);

TI = timeArray - timeArray(1); % time index in days from start

% Trim data to length of experiment
delta = find(TI <= days); % indices of data to keep
timeArray = timeArray(delta);
TI = TI(delta);
activityArray = activityArray(delta);
luxArray = luxArray(delta);

% Reshape data into columns of full days
% ASSUMES CONSTANT SAMPLING RATE
dayIdx = find(TI >= 1,1,'first') - 1;
extra = rem(length(TI),dayIdx)-1;
luxArray(end-extra:end) = [];
activityArray(end-extra:end) = [];
luxArray = reshape(luxArray,dayIdx,[]);
activityArray = reshape(activityArray,dayIdx,[]);

% Average data across days
% mLux = mean(lux,2);
mLux = exp(mean(log(luxArray),2));
mAI = mean(activityArray,2);

% Trim time index
TI = TI(1:dayIdx);
% Convert time index into hours from start
hour = TI*24;

% Find start time offset from midnight
delta = -find(timeArray >= ceil(timeArray(1)),1,'first');
% Appropriately offset the data
mLux = circshift(mLux,delta);
mAI = circshift(mAI,delta);
% Smooth activity
sAI = smooth(mAI,5);

% Create area plots
% Create figure
figure1 = figure;
set(figure1,'PaperUnits','inches',...
    'PaperType','usletter',...
    'PaperOrientation','landscape',...
    'PaperPositionMode','manual',...
    'PaperPosition',[0.5 0.5 10 7.5],...
    'Units','inches',...
    'Position',[0 0 11 8.5]);

% Create plots
[haxes,hline1,hline2] = plotyy(hour,sAI,hour,mLux,'area','semilogy');
set(hline2,...
    'Color',[0.6 0.6 0.6],...
    'DisplayName','lux - Illuminance','LineWidth',2);
set(hline1,...
    'FaceColor',[0.2 0.2 0.2],'EdgeColor','none',...
    'DisplayName','AI - Activity Index');
set(haxes,'Parent',figure1,'XTick',0:2:24,'YColor','k');
xlim(haxes(1),[0 24]);
xlim(haxes(2),[0 24]);

% Plot lights on/off
% yLims = ylim(gca);
% line([5.25 5.25],yLims);
% line([17.25 17.25],yLims);

% Create axes labels
ylabel(haxes(2),'Illuminance [lux]');
ylabel(haxes(1),'Activity');

% Create legend
legend1 = legend('Activity','Illuminance');
set(legend1,'Orientation','horizontal','Location','NorthOutside');

% Create x-axis label
xlabel('hour');

% Create title
StartDate = datestr(timeArray(1),'mmm dd, yyyy HH:MM');
EndDate = datestr(timeArray(end),'mmm dd, yyyy HH:MM');
DateRange = [StartDate,' - ',EndDate];
title({Title;DateRange});

% Create annotation
xLims = xlim(gca);
yLims = ylim(gca);
p1 = '%.3f';
p2 = '%.1f';
textBlock = cell(9,1);

textBlock{1} = ['Dark(Dim) Activity:   ',num2str(activity.dark,p1),'  ',num2str(activity.percentDark,p2),'%'];
textBlock{2} = ['    Morning Activity: ',num2str(activity.morning,p1),'  ',num2str(activity.percentMorning,p2),'%'];
textBlock{3} = ['    Evening Activity: ',num2str(activity.evening,p1),'  ',num2str(activity.percentEvening,p2),'%'];
textBlock{4} = ['Light Activity:       ',num2str(activity.light,p1),'  ',num2str(activity.percentLight,p2),'%'];
textBlock{5} = ['Total Activity:       ',num2str(activity.total,p1)];
textBlock{6} = ['L/D Activity Ratio:   ',num2str(activity.ldRatio,p1)];
textBlock{7} = ['Light-time Lux:       ',num2str(lux.light,p1)];
textBlock{8} = ['Dark-time Lux:        ',num2str(lux.dark,p1)];
textBlock{9} = ['L/D Lux Ratio:        ',num2str(lux.ldRatio,p1)];

text(xLims(1)+.01*xLims(2),yLims(2)-.12*yLims(2),100,textBlock);

end

