% Evaluate length of each file in fileIdx
fileLength = zeros(length(fileIdx),1); 
for k=1:length(fileIdx)
wavSize = wavread(strtrim(data.names(fileIdx(k),:)),'size');
fileLength(k,1) = wavSize(1)/p.fs; 
end

figure
stem(fileLength); 
axis tight
hold on
plot(get(gca,'xlim'),[p.cropLength p.cropLength],'--r'); 
xlabel('File Index'); ylabel('Length (s)'); 
title({['Number below ',num2str(p.cropLength),'sec: ', ... 
      num2str(sum(fileLength<p.cropLength))], ... 
      ['Minimum Length: ',num2str(min(fileLength)),'s']});