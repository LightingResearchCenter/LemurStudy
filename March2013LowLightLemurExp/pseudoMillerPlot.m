function pseudoMillerPlot(datetime,AI,lux,days,Title,lightsOn,lightsOff,buffer)
%MILLERPLOT Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.
%   time is in MATLAB date time series format
%   AI is activity index from a Daysimeter or Dimesimeter
%   lux is illuminance
%   days is number of days experiment ran for

TI = datetime - datetime(1); % time index in days from start

% Trim data to length of experiment
delta = find(TI <= days); % indices of data to keep
datetime = datetime(delta);
TI = TI(delta);
AI = AI(delta);
lux = lux(delta);

% Reshape data into columns of full days
% ASSUMES CONSTANT SAMPLING RATE
dayIdx = find(TI >= 1,1,'first') - 1;
extra = rem(length(TI),dayIdx)-1;
lux(end-extra:end) = [];
AI(end-extra:end) = [];
lux = reshape(lux,dayIdx,[]);
AI = reshape(AI,dayIdx,[]);

% Average data across days
% mLux = mean(lux,2);
mLux = exp(mean(log(lux),2));
mAI = mean(AI,2);

% Trim time index
TI = TI(1:dayIdx);
% Convert time index into hours from start
hour = TI*24;

% Find start time offset from midnight
delta = -find(datetime >= ceil(datetime(1)),1,'first');
% Appropriately offset the data
mLux = circshift(mLux,delta);
mAI = circshift(mAI,delta);
% Smooth activity
sAI = smooth(mAI,5);

buffer = buffer/60;
idxLight = hour >= lightsOn + buffer & hour <= lightsOff - buffer;
idxDark1 = hour <= lightsOn - buffer;
idxDark2 = hour >= lightsOff + buffer;
idxDark = idxDark1 | idxDark2;
adjustedAI = mAI - 0.05;
activityLight = trapz(hour(idxLight),adjustedAI(idxLight));
activityDark = trapz(hour(idxDark1),adjustedAI(idxDark1)) + trapz(hour(idxDark2),adjustedAI(idxDark2));
activityTotal = trapz(hour,adjustedAI);
percentLight = activityLight*100/activityTotal;
percentDark = activityDark*100/activityTotal;
ldRatio = activityLight/activityDark;
luxLight = mean(mLux(idxLight));
luxDark = mean(mLux(idxDark));
ldLuxRatio = luxLight/luxDark;

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
ylabel(haxes(2),'Illuminance');
ylabel(haxes(1),'Activity');

% Create legend
legend1 = legend('AI - Activity Index','lux - Illuminance');
set(legend1,'Orientation','horizontal','Location','NorthOutside');

% Create x-axis label
xlabel('hour');

% Create title
StartDate = datestr(datetime(1),'mmm dd, yyyy HH:MM');
EndDate = datestr(datetime(end),'mmm dd, yyyy HH:MM');
DateRange = [StartDate,' - ',EndDate];
title({Title;DateRange});

% Create annotation
xLims = xlim(gca);
yLims = ylim(gca);
p1 = '%.3f';
p2 = '%.1f';
text1 = ['Dark Activity Factor: ',num2str(activityDark,p1),'  ',num2str(percentDark,p2),'%'];
text2 = ['Light Activity Factor: ',num2str(activityLight,p1),'  ',num2str(percentLight,p2),'%'];
text3 = ['Total Activity Factor: ',num2str(activityTotal,p1)];
text4 = ['Light/Dark Activity Ratio: ',num2str(ldRatio,p1)];
text5 = ['Mean Light-time Lux: ',num2str(luxLight,p1)];
text6 = ['Mean Dark-time Lux: ',num2str(luxDark,p1)];
text7 = ['Light/Dark Lux Ratio: ',num2str(ldLuxRatio,p1)];
textBlock = {text1;text2;text3;text4;text5;text6;text7};
text(xLims(1)+.01*xLims(2),yLims(2)-.09*yLims(2),100,textBlock);

end

