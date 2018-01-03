% Confusion matrix plots
close all
load('confusionMatData.mat')
baseDir = 'C:\Users\Chris\';
saveDir = [baseDir,'Dropbox\Documents\Blog\Music Genre Classification\'];
addpath('plotUtils')
fileType = 'tiff';
saveFigs = 0; 

genreList = {'Classical','Electronic','Jazz/Blues', ... 
            'Metal/Punk','Rock/Pop','World'}; 

f1 = newFigPos();
set(f1,'position',[145 194 835 686])
imagesc(cf_pca_mean);
title('PCA');
set(gca,'xticklabel',genreList,'fontsize',14);
set(gca,'yticklabel',genreList);
colormap hot; axis square
colorbar

f2 = newFigPos();
set(f2,'position',[145 194 835 686])
imagesc(cf_lle_mean);
title('LLE');
set(gca,'xticklabel',genreList,'fontsize',14);
set(gca,'yticklabel',genreList);
colormap hot; axis square
colorbar

f3 = newFigPos();
set(f3,'position',[145 194 835 686])
imagesc(cf_sc_mean);
title('Spectral Clustering');
set(gca,'xticklabel',genreList,'fontsize',14);
set(gca,'yticklabel',genreList);
colormap hot; axis square
colorbar

if saveFigs 
    saveas(f1,[saveDir,'confMat_PCA_test'], fileType)
    saveas(f2,[saveDir,'confMat_LLE'], fileType)
    saveas(f3,[saveDir,'confMat_SC'], fileType)
end