function PhasorReport(stime,sCS,sAI,time,CS,AI,Title,dateRange)
%PHASORREPORT Generates graphical summary of CS and Activity

%% Process and analyze data
% Trim data to length of experiment
idxDate = stime >= dateRange(1) & stime <= dateRange(2)+1;
stime = stime(idxDate);
TI = stime - dateRange(1);
days = floor(TI(end));
sAI = sAI(idxDate);
sCS = sCS(idxDate);

epoch = ((stime(2)-stime(1))*(24*3600)); % sample epoch in seconds
Srate = 1/epoch; % sample rate in Hertz
% Calculate inter daily stability and variablity
[IS,IV] = IS_IVcalc(sAI,epoch);

% Apply gaussian filter to data
win = floor(300/epoch); % number of samples in 5 minutes
sCS = gaussian(sCS, win);
sAI = gaussian(sAI, win);
% Calculate phasors
[sMagnitude, sAngle] = cos24(sCS, sAI, stime);
[f24H,f24] = phasor24Harmonics(sCS,sAI,Srate); % f24H returns all the harmonics of the 24-hour rhythm (as complex numbers)
MagH = sqrt(sum((abs(f24H).^2))); % the magnitude including all the harmonics
numSubjects = length(time);
phasorMagnitude = zeros(numSubjects,1);
phasorAngle = zeros(numSubjects,1);
for i1 = 1:numSubjects
    [phasorMagnitude(i1), phasorAngle(i1)] = cos24(CS{i1}, AI{i1}, time{i1});
end

% Calculate light and dark related information
load(fullfile('astronomicalData','sunrise_set.mat'),'sunRise','sunSet');
% Find sunrise and sunset times that cover the date range
idxRise = sunRise >= dateRange(1)-1 & sunRise <= dateRange(2)+1;
idxSet = sunSet >= dateRange(1)-1 & sunSet <= dateRange(2)+1;
idxRiseSet = idxRise | idxSet;
sunRise = sunRise(idxRiseSet);
sunSet = sunSet(idxRiseSet);

idxDay = zeros(length(stime),1);
idxNight = zeros(length(stime),1);
for i1 = 1:length(sunRise)-1
    idxDayTemp = stime >= sunRise(i1) & stime < sunSet(i1);
    idxDay = idxDay | idxDayTemp;
    idxNightTemp = stime >= sunSet(i1) & stime < sunRise(i1+1);
    idxNight = idxNight | idxNightTemp;
end
totalAI = sum(sAI);
dayAI = sum(sAI(idxDay));
nightAI = sum(sAI(idxNight));
perDayAI = dayAI*100/totalAI;
perNightAI = nightAI*100/totalAI;
ratioDayNightAI = dayAI/nightAI;


%% Create graphics
% Create figure
figure1 = figure;
paperPosition = [0 0 11 8.5];
set(figure1,'PaperUnits','inches',...
    'PaperSize',[11 8.5],...
    'PaperOrientation','portrait',...
    'PaperPositionMode','manual',...
    'PaperPosition',paperPosition,...
    'Units','inches',...
    'Position',paperPosition);

% Set spacing values
xMargin = 0.5/paperPosition(3);
xSpace = 0.125/paperPosition(3);
yMargin = 0.5/paperPosition(4);
ySpace = 0.125/paperPosition(4);

% Create title
titleHandle = annotation(figure1,'textbox',...
    [0.5,1-yMargin,0.1,0.1],...
    'String',Title,...
    'FitBoxToText','on',...
    'HorizontalAlignment','center',...
    'LineStyle','none',...
    'FontSize',14);
% Center the title and shift down
titlePosition = get(titleHandle,'Position');
titlePosition(1) = 0.5-titlePosition(3)/2;
titlePosition(2) = 1-yMargin-titlePosition(4);
set(titleHandle,'Position',titlePosition);

% Create date stamp
dateStamp = ['Printed: ',datestr(now,'mmm. dd, yyyy HH:MM')];
datePosition = [0.8,1-yMargin,0.1,0.1];
dateHandle = annotation(figure1,'textbox',datePosition,...
    'String',dateStamp,...
    'FitBoxToText','on',...
    'HorizontalAlignment','right',...
    'LineStyle','none');
% Shift left and down
datePosition = get(dateHandle,'Position');
datePosition(1) = 1-xMargin-datePosition(3);
datePosition(2) = 1-yMargin-datePosition(4); 
set(dateHandle,'Position',datePosition);
% Calculate usable space for plots
workHeight = titlePosition(2)-ySpace-yMargin;
workWidth = 1-2*xMargin;

%% Panel 1 Activity and CS
% Set position values
x1 = xMargin; % half an inch from the edge
w1 = 1-2*xMargin; % width fot half inch margins
h1 = workHeight/3-ySpace/2; % half of top half with spacing
y1 = workHeight+yMargin-h1;
% Create plot
axes1 = axes('Parent',figure1,'OuterPosition',[x1 y1 w1 h1]);
hold(axes1);
set(axes1,'Box','off','TickDir','out');
ymax = ceil(max([max(sAI),max(sCS)])/.5)*.5;
area2 = area(axes1,TI,idxNight*ymax);
set(area2,'FaceColor',[145 177 255]/255,'EdgeColor','none','DisplayName','Night');
area1 = area(axes1,TI,sAI);
set(area1,'FaceColor',[.2 .2 .2],'EdgeColor','none','DisplayName','Activity');
plot1 = plot(axes1,TI,sCS);
set(plot1,'Color',[.6 .6 .6],'LineWidth',1.5,'DisplayName','Circadian Stimulus');
xlim(axes1,[0 days]);
set(axes1,'xtick',0:1:days);
ylim(axes1,[0 ymax]);
legend([area1,plot1,area2],'Location','NorthOutside','Orientation','horizontal');

%% Panel 2 Phasors
h2 = 2*workHeight/3-ySpace/2;
y2 = yMargin;
w2 = h1*paperPosition(3)/paperPosition(4);
x2 = x1+w2/4;
%   Plot phasors
axes('Parent',figure1,'OuterPosition',[x2 y2 w2 h2]);
hc1 = phasorplot(phasorMagnitude,phasorAngle,.75,3,6,'top','left',.1);
axes2 = gca;
title(axes2,'CS/Activity Phasor');
hold(axes2);
hc2 = phasorplot(sMagnitude,sAngle,.75,3,6,'top','left',.1,0,0,'r');
group1 = hggroup;
group2 = hggroup;
set(hc1,'Parent',group1);
set(hc2,'Parent',group2);
legend2 = legend([group1,group2],'Individuals','Species');
set(legend2,'Location','SouthOutside','Orientation','horizontal');

%% Panel 3 Text annotations
h3 = h2;
y3 = y2;
w3 = workWidth/2+xSpace;
x3 = xMargin+w3;
notes = cell(14,1);
notes{1} = ['Phasor Magnitude: ', num2str(sMagnitude,'%.2f')];
notes{2} = ['Phasor Angle: ', num2str(sAngle,'%.2f'),' hours'];
notes{3} = ' ';
notes{4} = ['IS: ', num2str(IS,'%.2f')];
notes{5} = ['IV: ', num2str(IV,'%.2f')];
notes{6} = ' ';
notes{7} = ['Average CS: ', num2str(mean(sCS),'%.2f')];
notes{8} = ['Mag w/ harmonics: ' num2str(MagH,'%.3f')];
notes{9} = ['Mag 1st harmonic: ' num2str(abs(f24),'%.3f')];
notes{10} = ' ';
notes{11} = ['Total activity per day: ',num2str(totalAI/days,'%.2f')];
notes{12} = ['Daytime activity per day: ',num2str(dayAI/days,'%.2f'),'  ',num2str(perDayAI,'%.2f'),'%'];
notes{13} = ['Nighttime activity per day: ',num2str(nightAI/days,'%.2f'),'  ',num2str(perNightAI,'%.2f'),'%'];
notes{14} = ['Day/Night activity ratio: ',num2str(ratioDayNightAI,'%.3f')];
text3 = annotation(figure1,'textbox', [x3 y3 w3 h3], 'String',notes);
set(text3,'EdgeColor','none','HorizontalAlignment','left',...
    'VerticalAlignment','middle','FontSize',11);
end
