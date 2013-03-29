function batchPseudoActo
load('lemurData.mat','AI','CS','ID','gender','species','subject','time');

close all;
for i1 = 1:length(ID)
    IDstr = num2str(ID(i1));
    Title = [IDstr,' ',subject{i1},' ',gender{i1},' ',species{i1}];
    pseudoActogram(time{i1},AI{i1},CS{i1},Title);
    print(gcf,'-dpdf',fullfile('pseudoActograms',[IDstr,'_',...
        subject{i1},'.pdf']));
    close;
end

end

