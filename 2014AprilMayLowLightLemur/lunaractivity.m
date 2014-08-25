function lunaractivity
%LUNARACTIVITY Summary of this function goes here
%   Detailed explanation goes here

%  
% Put on april 17 2014.
% 14 days of 12/12 with lights on at 0630 and off at 1830.
% (Stage 1) 14 days of 12/12 from 1830 on april 17 to 1830 on may 2.
% (Stage 2) Dim or moonlight on may 2, may 3 and may 4th;
% (Stage 3) dark on may 5, 6, & 8;
% (Stage 4) moonlight on may 9, 10 & 11;
% (Stage 5) and dark on may 12
% and off morning of may 13.
% Again, florescent lights were on at 0630 and off at 1830 each day.
% Light level during dim or moonlight nights was 0.146 lux. 
%  
% Daysimeter number 336 on male ringtail named Licinius and number 338 on 
% female named Tellus. They both did very well and maintained their weights 
% plus or minus 40 grams for the whole trial. They appeared relaxed, even 
% the technicians said how good they did.


close all;

[parentDir,~,~] = fileparts(pwd);
addpath(parentDir,'IO');

projectDir = fullfile([filesep,filesep,'ROOT'],'projects',...
    'Lemur''s-Research','2014AprilMayLowLightLemurCatta');

dimeSN = {336;338};
animalName = {'Licinius';'Tellus'};
animalSex = {'male';'female'};

stage = {'habituation';...
         'lights on';...
         'lights off';...
         'lights on';...
         'lights off'};

nStages = numel(stage);

% Set start dates of experiments
Y = 2014;
M = 5;
sDateVec = [Y, 4, 17;...
            Y, M,  2;...
            Y, M,  5;...
            Y, M,  9;...
            Y, M, 12];
sDate = datenum(sDateVec);
% Set end dates of experiments
eDateVec = [Y, M,  2;...
            Y, M,  5;...
            Y, M,  9;...
            Y, M, 12;...
            Y, M, 13];
eDate = datenum(eDateVec);

% Set lights on/off
lightsOn_days = 6.5/24;
lightsOff_days = 18.5/24;

filePath = ...
    {fullfile(projectDir,'Dime336pendant_SubjectLicinius_15May2014raw.txt');...
     fullfile(projectDir,'Dime338pendant_SubjectTellus_15May2014raw.txt')};

% Set start date of experiment
startDate = datenum(2014,04,17) + lightsOn_days;
% Set end date of experiment
endDate = datenum(2014,05,13) + lightsOff_days;

dayArray = (datenum(2014,04,17):datenum(2014,05,12))';
lunarIllumination = [0.93;0.87;0.78;0.68;0.57;0.46;0.34;0.24;0.15;0.08;0.03;0;0;0.02;0.07;0.12;0.2;0.28;0.37;0.46;0.56;0.65;0.74;0.82;0.89;0.95];

averageActivity = cell(2,1);
averageActivity{1} = zeros(size(dayArray));
averageActivity{2} = zeros(size(dayArray));

buffer_days = 30/(60*24);

for i1 = 1:2
    [timeArray,illuminanceArray,~,activityArray] = CalibrateDimesimeterDownloadFile_21Feb2013(filePath{i1});
    if dimeSN{i1} == 338 % Correct for resets
        timeArray = timeArray - 2.088498589349911;
    end
    
    % Set Lux values below 0.005 to 0.005
    illuminanceArray = choptothreshold(illuminanceArray,0.0001);
    
    idx1 = timeArray >= startDate & timeArray <= endDate;
    
    timeArray = timeArray(idx1);
    illuminanceArray = illuminanceArray(idx1);
    activityArray = activityArray(idx1);
    
    for i2 = 1:numel(dayArray)
        idx2 = (timeArray >= dayArray(i2)+lightsOff_days+buffer_days) & (timeArray <= dayArray(i2)+1+lightsOn_days-buffer_days);
        averageActivity{i1}(i2) = mean(activityArray(idx2));
    end
    
end

datetimeArray = datetime(dayArray,'ConvertFrom','datenum');

blue   = [0.000, 0.447, 0.741];
orange = [0.850, 0.325, 0.098];

initializefigure1(1,'on');
for j1 = 1:nStages
    switch stage{j1}
        case 'habituation'
            color = 'k';
        case 'lights on'
            color = orange;
        case 'lights off'
            color = blue;
        otherwise
            color = 'r';
    end
    idx = dayArray >= sDate(j1) & dayArray < eDate(j1);
    h1(j1) = plot(datetimeArray(idx),averageActivity{1}(idx),'x','Color',color);
    h1(j1).DisplayName = [animalName{1},' - ',stage{j1}];
    if j1 == 1
        hold on
    end
    h2(j1) = plot(datetimeArray(idx),averageActivity{2}(idx),'o','Color',color);
    h2(j1).DisplayName = [animalName{2},' - ',stage{j1}];
end

fullMoon1 = [datetime(2014,04,15);datetime(2014,04,15)];
newMoon = [datetime(2014,04,29);datetime(2014,04,29)];
fullMoon2 = [datetime(2014,05,14);datetime(2014,05,14)];
peak = max(cellfun(@max,averageActivity));
h3 = plot(fullMoon1,[0;peak],'r','DisplayName','full moon');
h4 = plot(newMoon,[0;peak],'k','DisplayName','new moon');
plot(fullMoon2,[0;peak],'r','DisplayName','full moon');

title('May 2014 Nighttime Lemur Activity');
xlabel('Date');
ylabel('Average Nighttime Activity');
legend([h1(1:3),h2(1:3),h3,h4],'Location','northeastoutside');
hold off
filePath = 'fig1';
print(gcf,'-dpdf',filePath,'-painters');

initializefigure1(2,'on');
for k1 = 1:nStages
    switch stage{k1}
        case 'habituation'
            color = 'k';
        case 'lights on'
            color = orange;
        case 'lights off'
            color = blue;
        otherwise
            color = 'r';
    end
    idx = dayArray >= sDate(k1) & dayArray < eDate(k1);
    h1(k1) = plot(lunarIllumination(idx)*100,averageActivity{1}(idx),'x','Color',color);
    h1(k1).DisplayName = [animalName{1},' - ',stage{k1}];
    if k1 == 1
        hold on
    end
    h2(k1) = plot(lunarIllumination(idx)*100,averageActivity{2}(idx),'o','Color',color);
    h2(k1).DisplayName = [animalName{2},' - ',stage{k1}];
end

title('May 2014 Nighttime Lemur Activity');
xlabel('Lunar Illuminantion (%)');
ylabel('Average Nighttime Activity');
legend([h1(1:3),h2(1:3)],'Location','northeastoutside');
hold off

filePath = 'fig2';
print(gcf,'-dpdf',filePath,'-painters');

end