
% --RUN "algoSettingsTop.m" FIRST--
%-------------------------------------------------------------------------%
% Description: Generates feature matrices for training models
% Includes generation of G1C feature set from MA toolbox for reference 
% comparison. 
%-------------------------------------------------------------------------%
% Features + dimensionality contained in extractedFeaturesAll: 
%   - mfcc: Mel frequency cepstrum coefficients - 729x1 cell struct 
%           of 20xnumFrames 
%   - zcRate: zero crossing rate - 729x1 vector 
%   - fp: fluctuation pattern that defines modulation of loudness 
%         (loudness per frequency band) - 729x1 cell of 20x60 
%         (critical bands x time)
%   - sh: spectrum histogram - 729x1 cell struct of 20x25 
%         (critical bands x histogram freq.) 
%   - loudness: 729x1 cell of numFrames/2 x 1
%   - ph: periodicity histogram - 729x1 cell struct of 30x41
%   - sum(ph(:)) = total energy contained in periodic beats

%   - ls: k-means frame-based-clustering results, 729x1 cell struct of 1x1
%   - ap: GMM frame-based-clustering results, 729x1 cell struct of 1x1
%-------------------------------------------------------------------------%
% Reference Features (g1C_features): 
%   - data.feat.fp: median fluctuation pattern: 729 songs x 360 medians
%   - data.feat.fpg: 729x1
%   - data.feat.fp_bass: 729x1
%   - data.feat.g1.m: mean mfcc across time: 729x19
%   - data.feat.g1.co: cov(mfcc') 729 songs x 19x19 covariances
%   -  data.feat.g1.ico: inverse of g1.co: 729x19x19
%   - data.feat.g1c.max_ico: max(g1.ico): 729x1
%-------------------------------------------------------------------------%

fprintf('Load data...\n');
load('extractedFeaturesAll.mat'); 
load('G1C_features.mat');

saveRes = 0; % (logical): save feature matrices

numCoeffs = 20; % number of MFCC coefficients to include in feature set

% Pre-allocate feature cells 
mfccMat = zeros(numCoeffs,length(mfcc)); 
mfp = zeros(size(fp{1},1),length(fp));
vfp = zeros(size(fp{1},1),length(fp));
mld = zeros(length(loudness),1);
vld = zeros(length(loudness),1);
msh = zeros(size(sh{1},1),length(sh));
vsh = zeros(size(sh{1},1),length(sh));
mph = zeros(size(ph{1},2),length(ph));
vph = zeros(size(ph{1},2),length(ph));

% Compute total energy contained in periodic beats
tl = cellfun(@(A) sum(A(:)),ph);
tl = tl/norm(tl);

% Generate feature statistics 
fprintf('Feature stats...\n');
for k=1:length(mfcc)
    numFrames = size(mfcc{k},2);
    mfccMat(:,k) = median(mfcc{k}(1:numCoeffs,1:numFrames),2); 
    mfccMat(:,k) = mfccMat(:,k)/norm(mfccMat(:,k));

% Loudness median and variance
    mld(k)=median(loudness{k});
    vld(k)=var(loudness{k});

% Generate mean and variance down rows of fp
    mfp(:,k)=median(fp{k},2);
    mfp(:,k)=mfp(:,k)/norm(mfp(:,k)); 
    vfp(:,k)=var(fp{k},0,2);
    vfp(:,k)=vfp(:,k)/norm(vfp(:,k));

% Generate mean and variance down rows of sh
    msh(:,k)=median(sh{k},2);
    msh(:,k)=msh(:,k)/norm(msh(:,k));
    vsh(:,k)=var(sh{k},0,2);
    vsh(:,k)=vsh(:,k)/norm(vsh(:,k));

% Generate mean and variance across columns of ph
    mph(:,k)=mean(ph{k});
    mph(:,k)=mph(:,k)/norm(mph(:,k));
    vph(:,k)=var(ph{k});
    vph(:,k)=vph(:,k)/norm(vph(:,k));
end

% Define normalized custom feature matrix
fprintf('Feature Matrix:Custom set...\n');
featMat = [mfccMat; 
           zcRate'/norm(zcRate); 
           tl'/norm(tl);
           mld'/norm(mld);
           vld'/norm(vld);
           mfp; 
           vfp; 
           msh; 
           vsh; 
           mph; 
           vph];

% Reference from MA toolbox 
fprintf('Feature Matrix: G1C reference...\n');
featMat_g1C = [data.feat.fp'; 
               data.feat.fpg'; 
               data.feat.fp_bass'; 
               data.feat.g1.m'; 
               data.feat.g1c.max_ico'];

% Use only ls features: covariance and priors
fprintf('GMM Matrix...\n');
centresMat = zeros(size(ls{1}.centres,1)*size(ls{1}.centres,2),length(ls));
covarsMat = zeros(size(ls{1}.covars,1)*size(ls{1}.covars,2),length(ls));
priorsMat = zeros(size(ls{1}.priors,2),length(ls));

for k=1:length(ls)
    centresMat(:,k) = ls{k}.centres(:)/norm(ls{k}.centres(:));
    covarsMat(:,k) = ls{k}.covars(:)/norm(ls{k}.covars(:));
    priorsMat(:,k)=ls{k}.priors'/norm(ls{k}.priors');
end

featMatGmm = [centresMat;
              covarsMat;
              priorsMat]; 
fprintf('Done.\n'); 

% Save results to reference file 
if saveRes
    save([dataDir,'featMat'],'featMat');
    save([dataDir,'featMat_g1C'],'featMat_g1C');
    save([dataDir,'featMatGmm'],'featMatGmm'); 
    fprintf('Results saved to %s\n',dataDir);
end
