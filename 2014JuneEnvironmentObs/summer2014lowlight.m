function summer2014lowlight
%SUMMER2014LOWLIGHT Summary of this function goes here
%   Detailed explanation goes here
% 


close all;
[parentDir,~,~] = fileparts(pwd);
addpath(parentDir,'IO');

projectDir = fullfile([filesep,filesep,'ROOT'],'projects',...
    'Lemur''s-Research','2014EnclosureObservation');

daysigramDir = fullfile(projectDir,'daysigrams');

dimeSN = {'336';'338'};

filePath = ...
    {fullfile(projectDir,'Dime336pendant_Subject336_25Jun2014raw.txt');...
     fullfile(projectDir,'Dime338pendant_Subject338_25Jun2014raw.txt')};
 
 workbookFile = 'kens_measurements.xlsx';
 KensMeasurements = importmeasurements(workbookFile);
 
 figure('Renderer','painters');

for i1 = 1:2
    [timeArray,illuminanceArray,~,~] = CalibrateDimesimeterDownloadFile_21Feb2013(filePath{i1});
    
    % Set Lux values below 0.005 to 0.005
    illuminanceArray = choptothreshold(illuminanceArray,0.0001);
    
    switch dimeSN{i1}
        case '336'
            meterArray = KensMeasurements.loc336;
        case '338'
            meterArray = KensMeasurements.loc338;
        otherwise
            error('unknown daysimeter');
    end
    meterTimeArray = KensMeasurements.datetime + 10/(60*24);
    daysimeterArray = matchmeasurements(timeArray,illuminanceArray,meterTimeArray);
    
    if i1 == 1
        loglog(meterArray,daysimeterArray,'o')
        hold(gca,'on');
    else
        loglog(meterArray,daysimeterArray,'x')
    end
    
end

set(gca,'YLim',[10^-2,1.1],'XLim',[10^-2,1.1]);
set(gca,'DataAspectRatio',[1 1 1])
set(gca,'PlotBoxAspectRatio',[1 1 1])
title({'Summer 2014 Lemur Environment Observation Method Comparison';...
       ['Generated: ',datestr(now,'yyyy/mm/dd HH:MM')]});
legend('Daysimeter 336','Daysimeter 338','Location','SouthOutside','Orientation','horizontal');
ylabel('Daysimeter Reading (lux)');
xlabel('Ken''s Reading (lux)');

end

function daysimeterArray = matchmeasurements(timeArray,illuminanceArray,meterTimeArray)

daysimeterArray = zeros(size(meterTimeArray));
for i1 = 1:numel(meterTimeArray)
    [~,idx] = min(abs(timeArray - meterTimeArray(i1)));
    daysimeterArray(i1) = illuminanceArray(idx(1));
end

end
