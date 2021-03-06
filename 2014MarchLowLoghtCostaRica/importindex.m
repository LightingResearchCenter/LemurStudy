function [dimesimeter,subject,startTime,stopTime] = importindex(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE1 Import data from a spreadsheet
%   [dimesimeter,subject,startTime,stopTime] = IMPORTFILE1(FILE) reads data
%   from the first worksheet in the Microsoft Excel spreadsheet file named
%   FILE and returns the data as column vectors.
%
%   [dimesimeter,subject,startTime,stopTime] = IMPORTFILE1(FILE,SHEET)
%   reads from the specified worksheet.
%
%   [dimesimeter,subject,startTime,stopTime] =
%   IMPORTFILE1(FILE,SHEET,STARTROW,ENDROW) reads from the specified
%   worksheet for the specified row interval(s). Specify STARTROW and
%   ENDROW as a pair of scalars or vectors of matching size for
%   dis-contiguous row intervals. To read to the end of the file specify an
%   ENDROW of inf.
%
%	Date formatted cells are converted to MATLAB serial date number format
%	(datenum).
%
% Example:
%   [dimesimeter,subject,startTime,stopTime] =
%   importfile1('index.xlsx','Sheet1',2,4);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2014/03/25 16:24:43

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 4;
end

%% Import the data, extracting spreadsheet dates in MATLAB serial date number format (datenum)
[~, ~, raw, dateNums] = xlsread(workbookFile, sheetName, sprintf('A%d:D%d',startRow(1),endRow(1)),'' , @convertSpreadsheetDates);
for block=2:length(startRow)
    [~, ~, tmpRawBlock,tmpDateNumBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:D%d',startRow(block),endRow(block)),'' , @convertSpreadsheetDates);
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
    dateNums = [dateNums;tmpDateNumBlock]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,2);
raw = raw(:,[1,3,4]);
dateNums = dateNums(:,[1,3,4]);

%% Replace date strings by MATLAB serial date numbers (datenum)
R = ~cellfun(@isequalwithequalnans,dateNums,raw) & cellfun('isclass',raw,'char'); % Find spreadsheet dates
raw(R) = dateNums(R);

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
dimesimeter = data(:,1);
subject = cellVectors(:,1);
startTime = data(:,2);
stopTime = data(:,3);

