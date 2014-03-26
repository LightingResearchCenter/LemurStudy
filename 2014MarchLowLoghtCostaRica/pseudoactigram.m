function pseudoactigram(time,activity,lux,plotTitle)
%PSEUDOACTIGRAM Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.
%   time is in MATLAB date time series format
%   AI is activity index from a Daysimeter or Dimesimeter
%   lux is illuminance

dateArray = unique(floor(time));

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
[haxes,hline1,hline2] = plotyy(time,activity,time,lux,'area','semilogy');
set(hline2,...
    'Color',[0.6 0.6 0.6],...
    'DisplayName','Illuminance','LineWidth',2);
set(hline1,...
    'FaceColor',[0.2 0.2 0.2],'EdgeColor','none',...
    'DisplayName','Activity');
set(haxes,'Parent',figure1,'XTick',dateArray,'YColor','k');
xlim(haxes(1),[dateArray(1) dateArray(end)+1]);
xlim(haxes(2),[dateArray(1) dateArray(end)+1]);
datetick2(haxes(1),'keepticks','keeplimits');

% Create axes labels
ylabel(haxes(2),'Illuminance [lux]');
ylabel(haxes(1),'Activity');

% Create legend
legend1 = legend('Activity','Illuminance');
set(legend1,'Orientation','horizontal','Location','NorthOutside');

% Create x-axis label
xlabel('time');

% Create title
StartDate = datestr(time(1),'mmm dd, yyyy HH:MM');
EndDate = datestr(time(end),'mmm dd, yyyy HH:MM');
DateRange = [StartDate,' - ',EndDate];
title({plotTitle;DateRange});

% Create annotation
% xLims = xlim(gca);
% yLims = ylim(gca);
% p1 = '%.3f';
% p2 = '%.1f';
% text1 = ['Dark Activity Factor: ',num2str(activityDark,p1),'  ',num2str(percentDark,p2),'%'];
% text2 = ['Light Activity Factor: ',num2str(activityLight,p1),'  ',num2str(percentLight,p2),'%'];
% text3 = ['Total Activity Factor: ',num2str(activityTotal,p1)];
% text4 = ['Light/Dark Activity Ratio: ',num2str(ldRatio,p1)];
% text5 = ['Mean Light-time Lux: ',num2str(luxLight,p1)];
% text6 = ['Mean Dark-time Lux: ',num2str(luxDark,p1)];
% text7 = ['Light/Dark Lux Ratio: ',num2str(ldLuxRatio,p1)];
% textBlock = {text1;text2;text3;text4;text5;text6;text7};
% text(xLims(1)+.01*xLims(2),yLims(2)-.09*yLims(2),100,textBlock);

end

