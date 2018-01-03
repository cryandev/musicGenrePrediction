% Simple, fast (vectorized) zero-crossing rate calculation

% Inputs: 
%   -ts: time series vector/matrix
% Outputs: 
%   zcRate: zero-crossing rate of ts

function zcRate = ZCR(ts)
zcRate = sum(abs(diff(ts>0)))/length(ts);


