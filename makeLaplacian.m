% makeLaplacian: Fast vectorized spectral clustering matrix creation for 
% simple dimensionality reduction

% Inputs: 
%   -d: number of eigenvalues of graph Laplacian L to compute 
%   -s: Gaussian kernel width
%   -featMat: extracted feature matrix from song list  

% Outputs: 
%   -scMat: spectral clustering matrix: set of eigenvectors of L 
%   -W: Gaussian weight matrix 
%   -L: normalized graph Laplacian matrix 

function [scMat,W,L] = makeLaplacian(d,s,featMat)

% Compute matrix of distances
a = sum(featMat.^2,1); 
N = size(featMat,2);
distances = a'*ones(1,N)+ones(N,1)*a-2*(featMat'*featMat);
W = exp(-1/(2*s^2)*distances); 
D = sum(W);
Dm = diag(1./sqrt(D)); 

% Construct graph Laplacian
L = Dm-W; 
[scMat,~] = eigs(L,d);
scMat = scMat'; 
