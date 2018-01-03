%% Plot ZCR results
% Run first cell of processDataTop first!!
close all
load('extractedFeaturesAll.mat','zcRate');
baseDir = 'C:\Users\Chris\';
saveDir = [baseDir,'Dropbox\Documents\Blog\Music Genre Classification\'];
saveFigs = 0; 
nbins = 10; 
plotIdx = 1:length(fileIdx);
color1 = [0 0 1]; % blue 
color2 = [0 .5 .5]; % dark green 
color3 = [1 0 0]; % red 
color4 = [.5 0 .5]; % cyan 
color5 = [0 0 0]; % black 
color6 = [1 0 1]; % magenta

C = [repmat(color1,[length(classicalIdx),1]);
     repmat(color2,length(electronicIdx),1);
     repmat(color3,length(jazzBluesIdx),1);
     repmat(color4,length(metalPunkIdx),1);
     repmat(color5,length(rockPopIdx),1);
     repmat(color6,length(worldIdx),1)];
 
f1 = newFigPos();
set(f1,'position', [55 212 1030 758]);

subplot(2,6,1:6);
scatter(plotIdx,zcRate,15,C,'filled');
% hold on
% line([classicalIdx(end) classicalIdx(end)],get(gca,'ylim'),'linestyle','-.','color','k')
% line([electronicIdx(end) electronicIdx(end)],get(gca,'ylim'),'linestyle','-.','color','k')
% line([jazzBluesIdx(end) jazzBluesIdx(end)],get(gca,'ylim'),'linestyle','-.','color','k')
% line([metalPunkIdx(end) metalPunkIdx(end)],get(gca,'ylim'),'linestyle','-.','color','k')
% line([rockPopIdx(end) rockPopIdx(end)],get(gca,'ylim'),'linestyle','-.','color','k')
box on
% title('Zero Crossing Rate'); 
ylabel('ZCR (crossings/unit time)','fontSize',18); 
xlabel([]);
set(gca,'xtick',[]); 
xlim([plotIdx(1) plotIdx(end)+5])
% legend(genreList);

% f1 = newFigPos();
subplot(2,6,7); 
histogram(zcRate(classicalIdx(1):classicalIdx(end)),nbins, ... 
          'normalization','probability','facecolor',color1); 
title(genreList{1}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,8); 
histogram(zcRate(electronicIdx(1):electronicIdx(end)),nbins, ...
          'normalization','probability','facecolor',color2); 
title(genreList{2}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,9); 
histogram(zcRate(jazzBluesIdx(1):jazzBluesIdx(end)),nbins, ...
          'normalization','probability','facecolor',color3); 
title(genreList{3}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,10); 
histogram(zcRate(metalPunkIdx(1):metalPunkIdx(end)),nbins, ...
          'normalization','probability','facecolor',color4); 
title(genreList{4}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,11); 
histogram(zcRate(rockPopIdx(1):rockPopIdx(end)),nbins, ...
          'normalization','probability','facecolor',color5); 
title(genreList{5}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,12); 
histogram(zcRate(worldIdx(1):worldIdx(end)),nbins, ...
          'normalization','probability','facecolor',color6); 
title(genreList{6}); 
axis square; set(gca,'xlim',[0 .5])

if saveFigs 
    saveas(f1,[saveDir,'zcr_scatterHistogram'],'tiff')
end