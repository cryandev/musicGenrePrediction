% Main training algorithm:  
% 1.) Load feature set 
% 2.) Reduce dimensionality of feature space by PCA/LLE/SC 
% 3.) Run k-nearest neighbors on reduced set

% Feature type: 
%     -'custom' feature set
%     -G1C reference from MA toolbox
%     -GMM reference from MA toolbox

featType = 'custom';
% featType = 'featMat_g1C';
% featType = 'featMatGmm';

switch featType 
    case 'custom'
        load([dataDir,'featMat']);
    case 'g1c'
        load([dataDir,'featMat_g1C']);
        featMat = featMat_g1C;
    case 'gmm'
        load([dataDir,'featMatGmm']);
        featMat = featMatGmm; 
end

saveRes = 0; % toggle save results 

testClassIdx{1} = classicalIdx;
testClassIdx{2} = electronicIdx; 
testClassIdx{3} = jazzBluesIdx; 
testClassIdx{4} = metalPunkIdx; 
testClassIdx{5} = rockPopIdx; 
testClassIdx{6} = worldIdx; 

% Set parameters for training model
numParts = 5; % Number of cross-validation partitions

d = 72; % reduced dimension size (vector)
s = .5; % Graph Laplacian sigma
kn_lle = 5; % Number of neighbors to use on full feature set
knc = 4; % Number of neighbors to use on reduced dim. feature set

% Preallocate reduced dimensionality matrices 
pcaAll = zeros(length(d),1);
lleAll = zeros(length(d),1);
scAll = zeros(length(d),1);

% Run validation on entire (un-reduced) feature set 
[cf_full,meanRates_full,fullAll,ps] = scoreValidateAlgo(numParts,featMat, ...
                                      fileIdx,data.genres,testClassIdx,knc);

% Evaluate classification performance of each method for each reduced
% dimension size d
for k=1:length(d)
    fprintf('LLE...\n');
    lleMat = lle(featMat,kn_lle,d(k));
    
    % PCA 
    fprintf('PCA...\n');
    % Center shift by removing mean
    mrMat = featMat-repmat(mean(featMat),size(featMat,1),1);
    [pcaCoeff,pcaMat] = pca(mrMat,d(k)); 
    pcaMat = pcaMat';
    disp('Done.');

    % Graph Laplacian/Spectral clustering
    fprintf('Graph Laplacian...\n');
    [scMat,W,L] = makeLaplacian(d(k),s,featMat);
        
    % Evaluate Classification Rate
    [cf_pca,meanRates_pca,pcaAll(k),~] = scoreValidateAlgo(numParts,pcaMat,fileIdx,data.genres,testClassIdx,knc);
    [cf_lle,meanRates_lle,lleAll(k),~] = scoreValidateAlgo(numParts,lleMat,fileIdx,data.genres,testClassIdx,knc);
    [cf_sc,meanRates_sc,scAll(k),~] = scoreValidateAlgo(numParts,scMat,fileIdx,data.genres,testClassIdx,knc);

    fprintf('Full Feature Set: %f \n',fullAll);
    disp(meanRates_full);

    fprintf('PCA: %f \n',pcaAll(k)); 
    disp(meanRates_pca);

    fprintf('LLE: %f \n',lleAll(k)); 
    disp(meanRates_lle);

    fprintf('SC: %f \n',scAll(k)); 
    disp(meanRates_sc);
end
% Compute mean statistics for confusion matrix 
cf_pca_mean = [mean(cf_pca{1}(1,:,:),3)./ps;
               mean(cf_pca{2}(2,:,:),3)./ps;  
               mean(cf_pca{3}(3,:,:),3)./ps;
               mean(cf_pca{4}(4,:,:),3)./ps;  
               mean(cf_pca{5}(5,:,:),3)./ps;  
               mean(cf_pca{6}(6,:,:),3)./ps]; 

cf_lle_mean = [mean(cf_lle{1}(1,:,:),3)./ps;
               mean(cf_lle{2}(2,:,:),3)./ps;  
               mean(cf_lle{3}(3,:,:),3)./ps;
               mean(cf_lle{4}(4,:,:),3)./ps;  
               mean(cf_lle{5}(5,:,:),3)./ps;  
               mean(cf_lle{6}(6,:,:),3)./ps]; 

cf_sc_mean =  [mean(cf_sc{1}(1,:,:),3)./ps;
               mean(cf_sc{2}(2,:,:),3)./ps;  
               mean(cf_sc{3}(3,:,:),3)./ps;
               mean(cf_sc{4}(4,:,:),3)./ps;  
               mean(cf_sc{5}(5,:,:),3)./ps;  
               mean(cf_sc{6}(6,:,:),3)./ps]; 

% figure
% plot(d,pcaAll,'-ok',d,lleAll,'-or',d,scAll,'-ob');
% xlabel('Dimension'); ylabel('Accuracy');
% legend('PCA','LLE','SC');
% axis tight

if saveRes 
    save([dataDir,'dimRedPlots_',datestr(now,30),'.mat'],'d','pcaAll','lleAll','scAll');
end
