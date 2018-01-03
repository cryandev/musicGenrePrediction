% Establishes settings for feature extraction, training algorithms, and
% results 
% Run this first to establish all settings for subsequent scripts and
% functions

clear 
close all
baseDir = 'C:\Users\Chris\';
codePath = [baseDir,'Dropbox\Documents\codeRepo\musicGenrePrediction\']; 
localDir = [baseDir,'Documents\Misc Docs\Math\High Dimensional Datasets\Project\'];
toolPath = [baseDir,'Dropbox\Documents\Math\High Dimensional Datasets\Project\software_toolbox\netlab\'];
dataDir = [codePath,'dataFiles\'];
addpath(localDir,toolPath,dataDir); 

% Set compFeat components to 0 or 1 to toggle extraction of following features: 
% 1.) zcRate: Zero crossing rate
% 2.) mfcc: mfccs for each frame (required for ls/ap)
% 3.) sone/loudness: sone and loudness for each frame (required for sh/fp)
% 4.) sh: sone histogram
% 5.) fp: fluctuation pattern
% 6.) ph: periodicity histogram
% 7.) ls: k-means frame-based-clustering (FBC)
% 8.) ap: GMM FBC
compFeat = [1 1 1 1 1 1 1 1]; 

% Structure s: top-level settings for feature extraction
p.cropFile = 1;  % 0 or 1 to extract from middle of file
ps.cropLength = 60; % (units: seconds); evaluate file from middle +/- this value

% Structure p: Feature extraction settings for MA toolbox 

p.fs = 11025; % sampling frequency
p.visu = 0;   % generate figures
p.fft_size = 256; % (units: samples); 256 samples = ~23ms @ 11kHz 
p.hopsize = 128;  % (units: samples); window overlap
p.num_ceps_coeffs = 20;  % number of MFCCs to keep in each time frame
p.use_first_coeff = 1; % (logical); keep 0th coefficient (contains information on average loudness)

p.mel_filt_bank = 'auditory-toolbox'; 

% Sone filter parameters
p.sone.fs = p.fs;
p.sone.outerear = 'modified_terhardt';
p.sone.fft_size = 512;
p.sone.hopsize = 256;
p.sh.hist_res = 25;

% Fluctuation pattern parameters
p.fp.sequence.length = 512;
p.fp.sequence.hopsize = 256;
p.fp.sequence.windowfunction = 'boxcar';
p.fp.fs = p.fs;                    
p.fp.fft_hopsize = p.sone.hopsize; 
p.fp.visu = 0;

% Periodicity histogram parameters
p.ph.sequence.length = 1024;
p.ph.sequence.hopsize = 512; 
p.ph.sequence.windowfunction = 'hann';
p.ph.fft_hopsize = p.sone.hopsize; 
p.ph.acc = 5;      
p.ph.minbpm = 40;  
p.ph.maxbpm = 240; 
p.ph.hist_res = 30;
p.ph.maxval = 0.4;
p.ph.minval = 0; 
p.ph.visu = 0;
p.ph.preferred_tempo = 'moleants';
p.ph.fs = p.fs;

% MFCC parameters
p.mfcc.visu = 0;
p.mfcc.fs = p.fs;    
p.mfcc.fft_size = 512;
p.mfcc.hopsize = 256;   
p.mfcc.num_ceps_coeffs = 20;
p.mfcc.use_first_coeff = 0;

% k-means FBC parameters
p.ls.cluster_type = 'kmeans';
p.ls.num_clusters = 30;
p.ls.covar_type = 'diag';  
p.ls.cm_similarity = 'KL_EMD';

% GMM FBC parameters 
p.ap.cluster_type = 'gmm';   
p.ap.num_clusters = 30;
p.ap.covar_type = 'diag';  
p.ap.cm_similarity = 'monte_carlo';
p.ap.mc_samples = 2000;

% Scaled frequency domain used throughout 
fftFreq = (0:p.fft_size/2)/p.fft_size*2*p.fs/2;

% -Create known training set indices- 
% dataListStruct is a structure containing: 
%   -data.names: full path filenames
%   -data.genres: associated genres

load('dataListStruct.mat');
genreList = {'Classical','Electronic','Jazz/Blues', ... 
            'Metal/Punk','Rock/Pop','World'}; 


% Reference indices for genre listing 
classicalIdx = 1:320; 
electronicIdx = 321:434; 
jazzBluesIdx = 435:460; 
metalPunkIdx = 461:505; 
rockPopIdx = 506:607; 
worldIdx = 608:729; 

% Full file index set
fileIdx = [classicalIdx,electronicIdx, ...
           jazzBluesIdx, metalPunkIdx, ...
           rockPopIdx,worldIdx]; 
       
% Save structures and variables for algorithm use
save([dataDir,'algoSettings'],'p','classicalIdx','electronicIdx', ...
     'jazzBluesIdx','metalPunkIdx','rockPopIdx', ...
      'worldIdx','fileIdx'); 
