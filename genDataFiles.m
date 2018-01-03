% Generate text file and structure of all (unsorted) tracks (for use with 
% featureExtraction)

outFile='\dataListFileContest.txt';
fileList=ls(dataDir);
tmp=repmat(dataDir,size(fileList,1),1);

fileList=[tmp,fileList];
fileList=fileList(3:end,:);

fileID=fopen([outPath,outFile],'w');

for k=1:size(fileList,1)
    fprintf(fileID,'%s',fileList(k,1:end-1));
    fprintf(fileID,'%s\r\n',fileList(k,end));
end
save('contestFileList','fileList');
fclose('all');

% Import properly sorted data with genres from ground_truth.csv
[~,~,fileList] = xlsread([outPath,'\ground_truth.csv'], ... 
    'ground_truth','A1:A729');
fileList(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),fileList)) = {''};

% Rename extension to .wav instead of .mp3
fileList=strrep(fileList,'mp3','wav');
fileList=char(fileList);

% Remove characters of incorrect path & delimiter ('/tracks')
fileList(:,1:7)=[];

% Append entire correct path to each entry
tmp=repmat(dataDir,size(fileList,1),1);
fileList=strcat(tmp,fileList);

% Import genres associated with each file
[~,~,genreList] = xlsread([outPath,'\ground_truth.csv'], ... 
    'ground_truth','B1:B729');
genreList=char(genreList);

% Assign to data struct and save
data.names=fileList;
data.genres=genreList;
save('dataListStruct','data');

% Generate file list for contest song data
clear d tmp* data

d = dir(dataDir);
d = char(d.name);
d = d(3:end,:);
rootdir = dataDir; 
dirs = {};

for i=1:size(d,1)
    dirs{i} = strcat(d(i,:));
end

tmp = {};
for i=1:length(dirs)
    d = dir([rootdir,dirs{i},'\*.wav']);
    d = strcat(char(rootdir),char(dirs{i}),'\',char(d.name));
    tmp{i}=char(d);
    
        for j=1:size(d,1)
            genres(j,:)=char(dirs{i});
            genres_num(j)=i;
        end
    contestdata.genres{i}=genres;
    data.genres_num{i} = genres_num; 
    clear genres* 
end

contestdata.names = char(tmp);
contestdata.genres = char(contestdata.genres);
contestdata.genres_num = cell2mat(data.genres_num)'; 
save('dataListStructContest','contestdata'); 