function [timeArray,illuminanceArray,claArray,csArray,activityArray] = importDime(filepath)


%process file
[timeArray,illuminanceArray,claArray,activityArray] = CalibrateDimesimeterDownloadFile_21Feb2013(filepath);

% Calculate CS
csArray = CSCalc_postBerlin_12Aug2011(claArray);

end