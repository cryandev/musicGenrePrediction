% Vectorized spectral clustering matrix creation
function scMat = specCluster(featMat,d,s)
% Compute matrix of distances
d = 100;
s = .5; 

a = sum(featMat.^2,1); 
N = size(featMat,2);
distances = a'*ones(1,N)+ones(N,1)*a-2*(featMat'*featMat);

W = exp(-1/(2*s^2)*distances); 
D = sum(W);
Dm = diag(1./sqrt(D)); 
% Construct graph Laplacian
L = Dm-W; 
[v,~] = eig(L);
scMat = v(:,d);

