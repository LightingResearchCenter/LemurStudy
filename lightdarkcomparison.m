function [activity,lux] = lightdarkcomparison(timeArray,activityArray,luxArray,lightStart,lightStop,buffer)
%LIGHTDARKCOMPARISON average values for light and dark periods
%   time is in MATLAB date time series format
%   activity from a Daysimeter or Dimesimeter
%   lux is illuminance
%   lightStart and lightStop are in hour of day
%   buffer is in minutes

% Convert time to hours
hour = datenum2hour(timeArray);

% Convert buffer from minutes to hours
buffer = buffer/60;

% Chop low value illuminance to threshold of sensor
% threshold = 0.001;
% luxArray = choptothreshold(luxArray,threshold);

% Find indicies of time during light period
idxLight = hour >= lightStart + buffer & hour <= lightStop - buffer;

% Find indicies of time during dark/dim period
idxMorning = hour <= lightStart - buffer;
idxEvening = hour >= lightStop + buffer;
idxDark = idxMorning | idxEvening;

% Preallocate activity output struct
activity = struct(...
    'light',            {[]},...
    'percentLight',     {[]},...
    'morning',          {[]},...
    'percentMorning',	{[]},...
    'evening',          {[]},...
    'percentEvening',	{[]},...
    'dark',             {[]},...
    'percentDark',      {[]},...
    'total',            {[]},...
    'ldRatio',          {[]});

% Analyze activity
activity.light      = mean(activityArray(idxLight));
activity.morning	= mean(activityArray(idxMorning));
activity.evening	= mean(activityArray(idxEvening));
activity.dark       = mean(activityArray(idxDark));
activity.total      = activity.light + activity.dark;

activity.percentLight	= activity.light	* 100 / activity.total;
activity.percentMorning	= activity.morning  * 100 / activity.total;
activity.percentEvening	= activity.evening  * 100 / activity.total;
activity.percentDark	= activity.dark     * 100 / activity.total;

activity.ldRatio = activity.light/activity.dark;

% Preallocate activity output struct
lux = struct(...
    'light',            {[]},...
    'morning',          {[]},...
    'evening',          {[]},...
    'dark',             {[]},...
    'ldRatio',          {[]});

% Analyze illuminance
lux.light	= mean(luxArray(idxLight));
lux.morning = mean(luxArray(idxMorning));
lux.evening = mean(luxArray(idxEvening));
lux.dark	= mean(luxArray(idxDark));
lux.ldRatio = lux.light / lux.dark;


end

