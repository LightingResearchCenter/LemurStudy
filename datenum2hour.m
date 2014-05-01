function hourArray = datenum2hour(timeArray)
%DATENUM2HOUR Summary of this function goes here
%   Detailed explanation goes here

hourArray = (timeArray - floor(timeArray))*24;

end

