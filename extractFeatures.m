% extractFeatures: Main feature extraction function using MA toolbox

% Inputs: 
%   -fileList: structure containing fileList.names and fileList.genres 
%   -fileIdx: list of file indices, 1...#songs 
%   -compFeat: 8x1 binary vector to toggle feature extractions zcRate...ap
%              features
%   -p: MA toolbox settings structure 

% Outputs: 
%   -zcRate: zero crossing rate for each song in library 
%   -loudness: cell array of length #songs, each one containing #segments
%              of loudness statistics
%   -mfcc: cell array of length #songs, each one containing #segments
%              of p.mfcc.num_ceps_coeffs coefficients 
%   -sh: cell array of length #songs, each one containing array of sone 
%        histogram data
%   -fp: cell array of length #songs, each one containing array of 
%        fluctuation pattern data
%   -ph: cell array of length #songs, each one containing array of 
%        periodicity histogram data
%   -ls: cell array of length #songs, each one containing a structure of
%        priors/centers/covars for FBC clustering 
%   -ap: cell array of length #songs, each one containing a structure of
%        priors/centers/covars for GMM clustering 

function [zcRate,loudness,mfcc,sh,fp,ph,ls,ap] = extractFeatures(fileList,fileIdx,compFeat,p)

% Initialize and obtain index sizes
numFiles = length(fileIdx);
loudness = cell(numFiles,1);
mfcc = cell(numFiles,1);
zcRate = zeros(numFiles,1); 
sh = cell(numFiles,1);
fp = cell(numFiles,1);
ph = cell(numFiles,1);
ls = cell(numFiles,1);
ap = cell(numFiles,1);
data = fileList; 

for k=1:numFiles
    % Read file k
    fprintf('Processing file (%d/%d) %s \n',k,numFiles,data.names(fileIdx(k),:));
    disp('Wavread...'); 
    wavSize = audioread(strtrim(data.names(fileIdx(k),:)),'size');
    
    switch p.cropFile
        case 0
            x0 = 1; 
            x1 = wavSize(1); 
        case 1 % Extract middle length of song if cropping is enabled
            if wavSize(1)> p.fs*2*p.cropLength 
                x0 = round(wavSize(1)/2 - p.fs*p.croplength);
                x1 = round(wavSize(1)/2 + p.fs*p.croplength);
            else
                x0 = 1; 
                x1 = wavSize(1); 
            end

    end    
    wav = audioread(strtrim(data.names(fileIdx(k),:)),[x0 x1]);
    fprintf('Extracted/File Length %.2f/%.2f s.\n',  ... 
             abs(x1-x0)/p.fs, wavSize(1)/p.fs);
    fprintf('Downsampling..\n');
    wav = wav(1:2:end); % simple 2x downsampling 
if compFeat(1)
%        Extract ZCR
    disp('ZCR...'); 
    zcRate(k) = ZCR(wav); 
end
if compFeat(2)
    %    MFCC extraction
    disp('MFCC...');
    mfcc{k}=ma_mfcc(wav,p);
%     [mfcc{k},DCT{k}]=ma_mfcc(wav,p);
end

if compFeat(3)
    % Extract sone 
    disp('Sone...');
    [sone,loudness{k},~] = ma_sone(wav,p.sone);
%     [sone,loudness{k},~,fftSpec] = ma_sone(wav,p.sone);
end
if compFeat(4)
%   Sone histogram
    disp('Sone Histogram...')
    sh{k} = ma_sh(sone,p.sh.hist_res);
end
if compFeat(5)
%   Fluctuation pattern
    disp('Fluctuation Pattern...');
    fp{k} = ma_fp(sone,p.fp);
end
if compFeat(6)
%   Periodicity histogram
    disp('Periodicity Histogram...');
    ph{k} = ma_ph(sone,p.ph);
end
if compFeat(7)
%   compute Frame-based Clustering w kmeans method
    disp('Frame-based Clustering (kmeans)...');
    ls{k} = ma_fc(mfcc{k},p.ls);
end
if compFeat(8)
%   compute Frame-based Clustering w GMM method
    disp('Frame-based Clustering (GMM)...');
    ap{k} = ma_fc(mfcc{k},p.ap);
end
    fprintf('Done. \n');
end