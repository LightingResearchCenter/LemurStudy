function cleanData
load('lemurData.mat')
% Remove last 3 subjects since they were always indoors
AI(21:23) = [];
CS(21:23) = [];
ID(21:23) = [];
gender(21:23) = [];
lux(21:23) = [];
species(21:23) = [];
subject(21:23) = [];
time(21:23) = [];

% Create start and end dates
Y = 2012*ones(20,1);
M  = [9, 9, 9, 9, 9,  9,  9,  9,  9,  9,  9,  9,  9,  9,  9,  9,  7,  7,  7,  7]';
sD = [1, 1, 1, 1, 6,  6,  6,  6,  13, 13, 13, 13, 21, 21, 21, 21, 6,  6,  6,  6]';
% eD = [5, 5, 5, 5, 12, 12, 12, 12, 19, 19, 19, 19, 26, 26, 26, 26, 23, 23, 23, 23]';
eD = [5, 5, 5, 5, 12, 12, 12, 12, 19, 19, 19, 19, 26, 26, 26, 26, 12, 12, 12, 12]';
sDate = datenum(Y,M,sD);
eDate = datenum(Y,M,eD);

% Trim the data
for i1 = 1:20
    sIdx = find(time{i1, 1} <= sDate(i1),1,'last') - 1;
    eIdx = find(time{i1, 1} < eDate(i1),1,'last') + 1;
    AI{i1, 1} = AI{i1, 1}(sIdx:eIdx);
    CS{i1, 1} = CS{i1, 1}(sIdx:eIdx);
    lux{i1, 1} = lux{i1, 1}(sIdx:eIdx);
    time{i1, 1} = time{i1, 1}(sIdx:eIdx);
end

save('cleanData.mat','AI','CS','ID','gender','lux','species','subject',...
    'time','sDate','eDate');

end

    