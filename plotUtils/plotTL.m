% Plot total energy in periodic beats scatter plot and histograms
close all
baseDir = 'C:\Users\Chris\';
saveDir = [baseDir,'Dropbox\Documents\Blog\Music Genre Classification\'];

load('extractedFeaturesAll.mat','ph');
saveFigs = 0; 

tl = cellfun(@(A) sum(A(:)),ph);
tl = tl./max(tl(:));
plotIdx = 1:length(fileIdx);
grp = [1*ones(length(classicalIdx),1);
     2*ones(length(electronicIdx),1); 
     3*ones(length(jazzBluesIdx),1);
     4*ones(length(metalPunkIdx),1);
     5*ones(length(rockPopIdx),1);
     6*ones(length(worldIdx),1)];


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
set(f1,'position', [55 212 1030 758]); hold on
idx = classicalIdx(1):classicalIdx(end); 
scatter(plotIdx(idx), tl(idx),15,C(idx,:),'filled');

idx = electronicIdx(1):electronicIdx(end); 
scatter(plotIdx(idx), tl(idx),15,C(idx,:),'filled');

idx = jazzBluesIdx(1):jazzBluesIdx(end); 
scatter(plotIdx(idx), tl(idx),15,C(idx,:),'filled');

idx = metalPunkIdx(1):metalPunkIdx(end); 
scatter(plotIdx(idx), tl(idx),15,C(idx,:),'filled');

idx = rockPopIdx(1):rockPopIdx(end); 
scatter(plotIdx(idx), tl(idx),15,C(idx,:),'filled');

idx = worldIdx(1):worldIdx(end); 
scatter(plotIdx(idx), tl(idx),15,C(idx,:),'filled');
   
legend(genreList,'location','nw')
box on

ylabel('Total Energy In Periodic Beats (Normalized)','fontSize',18); 
xlabel([]);
set(gca,'xtick',[]); 
axis([plotIdx(1) plotIdx(end)+5 .1 1.1])
% axis([plotIdx(1) plotIdx(end)+5 min(tl)-5 max(tl)+5])

%
nbins = 10; 
f2 = newFigPos();
subplot(2,6,1:6);
set(f2,'position', [55 212 1030 758]);
scatter(plotIdx,tl,15,C,'filled');
box on
ylabel({['Total Energy In Periodic Beats'],['(Normalized)']},'fontSize',18); 
xlabel([]);
set(gca,'xtick',[]); 
axis([plotIdx(1) plotIdx(end)+5 .1 1.1])

subplot(2,6,7); 
histogram(tl(classicalIdx(1):classicalIdx(end)),nbins, ... 
          'normalization','probability','facecolor',color1); 
title(genreList{1}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,8); 
histogram(tl(electronicIdx(1):electronicIdx(end)),nbins, ...
          'normalization','probability','facecolor',color2); 
title(genreList{2}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,9); 
histogram(tl(jazzBluesIdx(1):jazzBluesIdx(end)),nbins, ...
          'normalization','probability','facecolor',color3); 
title(genreList{3}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,10); 
histogram(tl(metalPunkIdx(1):metalPunkIdx(end)),nbins, ...
          'normalization','probability','facecolor',color4); 
title(genreList{4}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,11); 
histogram(tl(rockPopIdx(1):rockPopIdx(end)),nbins, ...
          'normalization','probability','facecolor',color5); 
title(genreList{5}); 
axis square; set(gca,'xlim',[0 .5])

subplot(2,6,12); 
histogram(tl(worldIdx(1):worldIdx(end)),nbins, ...
          'normalization','probability','facecolor',color6); 
title(genreList{6}); 
axis square; set(gca,'xlim',[0 .5])

if saveFigs 
    saveas(f1,[saveDir,'totalEnergy_scatter'],'tiff')
    saveas(f2,[saveDir,'totalEnergy_scatterHistogram'],'tiff')
end
