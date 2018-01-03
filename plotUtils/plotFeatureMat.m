% Plot full extracted feature matrix 
close all
load('featMat.mat')
baseDir = 'C:\Users\Chris\';
saveDir = [baseDir,'Dropbox\Documents\Blog\Music Genre Classification\'];
fileType = 'tiff';
saveFigs = 1;

f1 = newFigPos();
imagesc(featMat); 
colormap hot
xlabel('Song Index','fontSize',18); 
ylabel('Feature','rotation',90,'fontSize',18);
set(gca,'xtick',[],'ytick',[])
% set(gca,'XAxisLocation','top')

if saveFigs 
    saveas(f1,[saveDir,'featureMat_Normalized'],'jpg')
end