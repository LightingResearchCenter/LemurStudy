function [millerTime_hours,millerDataArray] = millerize(timeArray,dataArray)
%MILLERIZE Summary of this function goes here
%   Detailed explanation goes here


mod_days = mod(timeArray,1);
mod_minutes = mod_days*24*60;
roundedMod_minutes = round(mod_minutes/10)*10; % precise to 10 minutes

millerTimeArray_minutes = unique(roundedMod_minutes);

nPoints = numel(millerTimeArray_minutes);

millerDataArray = zeros(nPoints,1);

for i1 = 1:nPoints
    idx = roundedMod_minutes == millerTimeArray_minutes(i1);
    millerDataArray(i1) = mean(dataArray(idx));
end

millerTime_hours = millerTimeArray_minutes/60;

end

