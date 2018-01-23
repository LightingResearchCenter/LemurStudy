function pseudoMillerPlot(timeArray,activity,lux,plotTitle,lightsOn,lightsOff,buffer)
%MILLERPLOT Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.
%   time is in MATLAB date time series format
%   AI is activity index from a Daysimeter or Dimesimeter
%   lux is illuminance
%   days is number of days experiment ran for

[millerTime_hours,mLux] = millerize(timeArray,lux);
[               ~,mAI]  = millerize(timeArray,activity);

buffer = buffer/60;
idxLight = millerTime_hours >= lightsOn + buffer & millerTime_hours <= lightsOff - buffer;
idxDark1 = millerTime_hours <= lightsOn - buffer;
idxDark2 = millerTime_hours >= lightsOff + buffer;
idxDark = idxDark1 | idxDark2;
activityLight = trapz(millerTime_hours(idxLight),mAI(idxLight));
activityDark = trapz(millerTime_hours(idxDark1),mAI(idxDark1)) + trapz(millerTime_hours(idxDark2),mAI(idxDark2));
activityTotal = trapz(millerTime_hours,mAI);
percentLight = activityLight*100/activityTotal;
percentDark = activityDark*100/activityTotal;
ldRatio = activityLight/activityDark;
luxLight = mean(mLux(idxLight));
luxDark = mean(mLux(idxDark));
ldLuxRatio = luxLight/luxDark;

% Create area plots
% Create figure
figure1 = figure(500);
set(figure1,'PaperUnits','inches',...
    'PaperType','usletter',...
    'PaperOrientation','landscape',...
    'PaperPositionMode','manual',...
    'PaperPosition',[0.5 0.5 10 7.5],...
    'Units','inches',...
    'Position',[0 0 11 8.5]);

% Create plots
[haxes,hline1,hline2] = plotyy(millerTime_hours,mAI,millerTime_hours,mLux,'area','semilogy');
set(hline2,...
    'Color',[0.6 0.6 0.6],...
    'DisplayName','lux - Illuminance','LineWidth',2);
set(hline1,...
    'FaceColor',[0.2 0.2 0.2],'EdgeColor','none',...
    'DisplayName','AI - Activity Index');
set(haxes,'Parent',figure1,'XTick',0:2:24,'YColor','k');
ylim(haxes(1),[0 0.35]);
ylim(haxes(2),[10^-4 10^2]);
xlim(haxes(1),[0 24]);
xlim(haxes(2),[0 24]);

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
title({plotTitle;DateRange});

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
hText = text(xLims(1)+.01*xLims(2),yLims(2)-.09*yLims(2),0,textBlock);

end

