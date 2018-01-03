% Compute feature distances for all items in extracted feature list
% Assumption: all features have identical size

% Inputs: 
%   -sh: sone histogram
%   -fp: fluctuation pattern
%   -ph: Periodicity Histogram 
%   -ls: FBC k-means
%   -ap: ap GMM measure

% Outputs: 
%   -D_sh,D_fp,D_ph,D_ls,D_ap: Pairwise norm distance between each element 
%    for sone histogram....GMM measure 
function [D_sh,D_fp,D_ph,D_ls,D_ap] = compDistance(sh,fp,ph,ls,ap)
fprintf('Distance computations...\n'); 
N = length(ph); 

% Initialize
D_sh = zeros(N); 
D_fp = zeros(N); 
D_ph = zeros(N);  
D_ls = zeros(N);  
D_ap = zeros(N);  

% Compute distances between all elements
for i=1:N-1
    for j=i+1:N
        fprintf('(i,j)=(%d,%d)/(%d,%d) \n',i,j,N-1,N);
        D_sh(i,j) = norm(sh{i}(:)-sh{j}(:));
        D_fp(i,j) = norm(fp{i}(:)-fp{j}(:));
        D_ph(i,j) = norm(ph{i}(:)-ph{j}(:));
        D_ls(i,j) = ma_cms(ls{i},ls{j},p.ls);
        D_ap(i,j) = ma_cms(ap{i},ap{j},p.ap);
    end
end

% Make distance matrices symmetric
D_sh = D_sh + D_sh'; 
D_fp = D_fp + D_fp'; 
D_ph = D_ph + D_ph'; 
D_ls = D_ls + D_ls'; 
D_ap = D_ap + D_ap';    

save([localDir,'\gmmDistanceMat'],'D_ap');
fprintf('Done.\n'); 