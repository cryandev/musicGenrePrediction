% Plot correct categorization rate as a function of reduced dimensionality
close all
load('dimRedPlots_12212017');
baseDir = 'C:\Users\Chris\';
saveDir = [baseDir,'Dropbox\Documents\Blog\Music Genre Classification\'];
saveFigs = 1; 

f1 = newFigPos();
plot(d,pcaAll,'-ok',d,lleAll,'-or',d,scAll,'-ob');
xlabel('Reduced Dimension'); ylabel('Classification Accuracy');
legend('PCA','LLE','SC','location','best');
grid on
axis tight

if saveFigs 
    saveas(f1,[saveDir,'classAccuracy_subDimension'],'tiff')
end