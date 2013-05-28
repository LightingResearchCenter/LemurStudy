function millerReport(stime,sCS,sAI,time,CS,AI,Title,dateRange)
%PHASORREPORT Generates graphical summary of CS and Activity

%% Process and analyze data
% Trim data to length of experiment
idxDate = stime >= dateRange(1) & stime <= dateRange(2)+1;
stime = stime(idxDate);
TI = stime - dateRange(1);
% days = floor(TI(end));
sAI = sAI(idxDate);
sCS = sCS(idxDate);

epoch = ((stime(2)-stime(1))*(24*3600)); % sample epoch in seconds
% Srate = 1/epoch; % sample rate in Hertz
% Calculate inter daily stability and variablity
% [IS,IV] = IS_IVcalc(sAI,epoch);

% Apply gaussian filter to data
win = floor(300/epoch); % number of samples in 5 minutes
sCS = gaussian(sCS, win);
sAI = gaussian(sAI, win);
% Calculate phasors
[sMagnitude, sAngle] = cos24(sCS, sAI, stime);
% [f24H,f24] = phasor24Harmonics(sCS,sAI,Srate); % f24H returns all the harmonics of the 24-hour rhythm (as complex numbers)
% MagH = sqrt(sum((abs(f24H).^2))); % the magnitude including all the harmonics
numSubjects = length(time);
phasorMagnitude = zeros(numSubjects,1);
phasorAngle = zeros(numSubjects,1);
for i1 = 1:numSubjects
    [phasorMagnitude(i1), phasorAngle(i1)] = cos24(CS{i1}, AI{i1}, time{i1});
end

% Calculate mean values
meanCS = mean(sCS);
meanAI = mean(sAI);

% Calculate light and dark related information
% load('sunrise_set.mat','sunRise','sunSet');
% % Find sunrise and sunset times that cover the date range
% idxRise = sunRise >= dateRange(1)-1 & sunRise <= dateRange(2)+1;
% idxSet = sunSet >= dateRange(1)-1 & sunSet <= dateRange(2)+1;
% idxRiseSet = idxRise | idxSet;
% sunRise = sunRise(idxRiseSet);
% sunSet = sunSet(idxRiseSet);
% 
% idxDay = zeros(length(stime),1);
% idxNight = zeros(length(stime),1);
% for i1 = 1:length(sunRise)-1
%     idxDayTemp = stime >= sunRise(i1) & stime < sunSet(i1);
%     idxDay = idxDay | idxDayTemp;
%     idxNightTemp = stime >= sunSet(i1) & stime < sunRise(i1+1);
%     idxNight = idxNight | idxNightTemp;
% end
% totalAI = sum(sAI);
% dayAI = sum(sAI(idxDay));
% nightAI = sum(sAI(idxNight));
% perDayAI = dayAI*100/totalAI;
% perNightAI = nightAI*100/totalAI;
% ratioDayNightAI = dayAI/nightAI;


%% Create graphics
% Create figure
figure1 = figure(1);
figureUnits = 'points';
scaleFactor = 2;
xMargin = 100/scaleFactor;
yMargin = 100/scaleFactor;
millerPosition = [xMargin,yMargin,848/scaleFactor,632/scaleFactor];
pDia = 165/scaleFactor; %Phasor Plot Diameter
phasorPosition = [xMargin+103/scaleFactor-.5*pDia,yMargin+580/scaleFactor-.5*pDia,pDia,pDia];
boxPosition    = [xMargin,yMargin,848/scaleFactor,680/scaleFactor];
figurePosition = [0,0,boxPosition(3)+2*xMargin,boxPosition(4)+2*yMargin];
color1 = [  0,  0,  0];
color2 = [ 77, 76,255]/255;
set(figure1,...
    'Units',figureUnits,...
    'Position',figurePosition,...
    'PaperUnits','points',...
    'PaperSize',[figurePosition(3),figurePosition(4)],...
    'PaperPosition',figurePosition,...
    'Renderer','painters');

%% Create date stamp
% dateStamp = ['Printed: ',datestr(now,'mmm. dd, yyyy HH:MM')];
% datePosition = [0.8,0.8,0.1,0.1];
% dateHandle = annotation(figure1,'textbox',datePosition,...
%     'String',dateStamp,...
%     'FitBoxToText','on',...
%     'HorizontalAlignment','right',...
%     'LineStyle','none');
% % Shift left and down
% datePosition = get(dateHandle,'Position');
% datePosition(1) = 1-datePosition(3)-xMargin/figurePosition(3);
% datePosition(2) = 1-datePosition(4); 
% set(dateHandle,'Position',datePosition);

%% Miller Plot of Activity and CS
scaleFactor = modifiedMillerPlot(TI,sAI,sCS,millerPosition,figureUnits,dateRange,color1,color2);

%% Annotate scaling factor
% scaleText = ['Scaling factor: ',num2str(scaleFactor)];
% scalePosition = [0,0.8,0.1,0.1];
% scaleHandle = annotation(figure1,'textbox',scalePosition,...
%     'String',scaleText,...
%     'FitBoxToText','on',...
%     'HorizontalAlignment','left',...
%     'LineStyle','none');
% % Shift left and down
% scalePosition = get(scaleHandle,'Position');
% scalePosition(1) = 0+xMargin/figurePosition(3);
% scalePosition(2) = 1-scalePosition(4); 
% set(scaleHandle,'Position',scalePosition);

%% Phasor Plot
modifiedPhasorPlot(sAngle,sMagnitude,phasorPosition,color1,figureUnits)

%% Box in the figure
box1 = annotation('rectangle',[0,0,1,1]);
set(box1,...
    'Units',figureUnits,...
    'Position',boxPosition,...
    'EdgeColor',color2,...
    'LineWidth',2,...
    'FaceColor','none');

%% Create title

Title = [Title;...
        'Mean CS: ',num2str(meanCS,3);...
        'Mean AI: ',num2str(meanAI,3);...
        'Phasor Magnitude: ',num2str(sMagnitude,4);...
        'Phasor Angle hrs: ',num2str(sAngle*12/pi,4)];
titleHandle = annotation(figure1,'textbox',[0.5,0.5,0.1,0.1]);
set(titleHandle,...
    'String',Title,...
    'FitBoxToText','on',...
    'HorizontalAlignment','center',...
    'LineStyle','none',...
    'FontSize',10,...
    'Units',figureUnits);
% Center the title and shift down
titlePosition = get(titleHandle,'Position');
titlePosition(1) = (figurePosition(3)-titlePosition(3))/2;
titlePosition(2) = boxPosition(4)+boxPosition(2)-titlePosition(4);
set(titleHandle,'Position',titlePosition);
end
