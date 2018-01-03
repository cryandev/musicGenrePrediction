% scoreValidateAlgo: Performs N-fold cross validation on data testMat, 
% partitioning data into numParts and training the model using a knn 
% classifier. Generates confusion matrix for each partition, as well as 
% average classification rates over all partitions. 
%-------------------------------------------------------------------------%
% inputs: 
%     -numParts: number of partitions to perform validation against
%     -featMat: feature matrix under test
%     -fileIdx: full index vector of all files in testMat (1...size(testMat,2))
%     -genreRef: char array, reference genre list for each item in featMat 
%     -testClassIdx: cell array of indices of each genre in genreRef
%     -kn: number of nearest neighbors to use in classifier

% outputs: 
%     -cf: confusion matrix for each partition
%     -meanRates: individual mean rates of classifier over full validation
%     -allMean: total average classification rate
%     -partSize: computed partition sizes used in cross-validation

function [cf,meanRates,allMean,partSize] = scoreValidateAlgo(numParts,featMat,fileIdx,genreRef,testClassIdx,kn)
% Perform knnclassify training and create confusion matrices
partSize = zeros(1,length(testClassIdx)); 
classList = {'classical','electronic','jazz_blues', ... 
             'metal_punk','rock_pop','world'};

for n=1:length(testClassIdx)
        clear testIdx
        partSize(n) = round(length(testClassIdx{n})/numParts);

        for k=1:numParts
            testIdx(k,:) = ceil(testClassIdx{n}(1)+(k-1)*partSize(n): ...
                              testClassIdx{n}(1)+k*partSize(n)); 
        end

    fprintf('Classification on indices %d:%d.\n',testIdx(1),testIdx(end));
    for i=1:numParts
        trainIdx = setdiff(fileIdx,testIdx(i,:)); 
        testData = featMat(:,testIdx(i,:))';
        trainingData = featMat(:,trainIdx)';
        testGenres = genreRef(fileIdx(trainIdx),:);
        class = knnclassify(testData,trainingData,testGenres,kn);
        [cf{n}(:,:,i),~] = confusionmat(strtrim(genreRef(testIdx(i,:),:)), ... 
                                         strtrim(class),'order',strtrim(classList));
    end
end

    clRate = mean(cf{1}(1,1,:))/partSize(1);
    elRate = mean(cf{2}(2,2,:))/partSize(2);
    jbRate = mean(cf{3}(3,3,:))/partSize(3);
    mpRate = mean(cf{4}(4,4,:))/partSize(4);
    rpRate = mean(cf{5}(5,5,:))/partSize(5);
    wRate = mean(cf{6}(6,6,:))/partSize(6);
    meanRates = [clRate,elRate,jbRate,mpRate,rpRate,wRate]; 
    allMean = mean(meanRates);