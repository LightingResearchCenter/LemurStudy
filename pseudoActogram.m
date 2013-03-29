function pseudoActogram(time,AI,CS,Title)
%PSEUDOACTOGRAM Creates actogram like plots that also have CS plotted

% Create time index relative to midnight before start of data
TI = time - floor(time(1));

runTime = ceil(TI(end));

% Divide data into days independent of sampling rate
idx = cell(runTime,1);
TI1 = cell(runTime,1);
AI1 = cell(runTime,1);
CS1 = cell(runTime,1);
subTitle = cell(runTime,1);
for i1 = 1:runTime
    idx{i1} = TI >= (i1 - 1) & TI < i1;
    TI1{i1} = (TI(idx{i1}) - (i1 - 1))*24; % New time index in hours
    AI1{i1} = AI(idx{i1});
    CS1{i1} = CS(idx{i1});
    subTitle{i1} = datestr(floor(min(time(idx{i1}))),'mm/dd/yy');
end

% Create plot
figure1 = figure;
set(figure1,'PaperUnits','inches',...
    'PaperType','usletter',...
    'PaperOrientation','portrait',...
    'PaperPositionMode','manual',...
    'PaperPosition',[0 0 8.5 11],...
    'Units','inches',...
    'Position',[0 0 8.5 11]);

title(Title);

for i2 = 1:runTime
    subplot(runTime,1,i2)
    plot(TI1{i2},[AI1{i2},CS1{i2}])
    xlim([0 24]);
    ylim([0 1]);
    set(gca,'XTick',0:6:24,'YTick',0:1)
    set(gca,'YTickLabel','');
    if i2 < runTime
        set(gca,'XTickLabel','');
    end
    
    if i2 == 1
        title(Title);
    end
    ylabel(subTitle{i2});
    set(get(gca,'YLabel'),'Rotation',0);
end

legend1 = legend('AI - Activity Index','CS - Circadian Stimulus');
set(legend1,'Orientation','horizontal','Location','Best');

end

