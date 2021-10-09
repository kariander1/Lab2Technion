%% 1.1

dataSetDir = fullfile(toolboxdir('vision'),'visiondata','triangleImages');
imageDir = fullfile(dataSetDir,'trainingImages');
labelDir = fullfile(dataSetDir,'trainingLabels');

%% 1.2
imds = imageDatastore(imageDir);

%% 1.3
I = readimage(imds,1);
imshow(I,[]);
title("Image 1")

%% 1.4

classNames = ["triangle","background"];
labelIDs = [255 0];
pxds = pixelLabelDatastore(labelDir,classNames,labelIDs);

%% 1.5

displayImageAndClassification(imds,pxds,1);

displayImageAndClassification(imds,pxds,20);
displayImageAndClassification(imds,pxds,50);
displayImageAndClassification(imds,pxds,150);

%% 1.6

layers = [
 imageInputLayer([32 32 1])
 convolution2dLayer(3,8,'Padding',1)
 reluLayer()
 convolution2dLayer(3,16,'Padding',1)
 reluLayer()
 convolution2dLayer(1,2);
 softmaxLayer()
 pixelClassificationLayer()];

%% 1.17
layers(end) = pixelClassificationLayer('ClassNames',tbl.Name,'ClassWeights',[19,1]);

%% 1.7
opts = trainingOptions('sgdm', ...
 'InitialLearnRate', 5e-5, ...
 'MaxEpochs', 150, ...
 'MiniBatchSize', 32, ...
 'ExecutionEnvironment', 'cpu','Plots', 'training-progress');

%% 1.8
trainingData = pixelLabelImageSource(imds,pxds);

%% 1.9
net = trainNetwork(trainingData,layers,opts);


%% 1.10
testImage = imread('triangleTest.jpg');
C = semanticseg(testImage,net);
B = labeloverlay(testImage,C);
figure; 
imshow(B)

%% 1.15
testImagesDir = fullfile(dataSetDir, 'testImages');
imdsTest = imageDatastore(testImagesDir);
testLabelsDir = fullfile(dataSetDir, 'testLabels');
pxdsTruthTest = pixelLabelDatastore(testLabelsDir, classNames, labelIDs);
pxdsResults = semanticseg(imdsTest, net, "WriteLocation", tempdir);

evaluationMetrics = ["accuracy"];
metrics = evaluateSemanticSegmentation(pxdsResults, pxdsTruthTest, "Metrics",evaluationMetrics);

%% 1.16

tbl = countEachLabel(trainingData);

%% 1.19

evaluationMetrics = ["accuracy" "iou"];
metrics = evaluateSemanticSegmentation(pxdsResults, pxdsTruthTest, "Metrics",evaluationMetrics);


%% 1.21


layers = [
 imageInputLayer([32 32 1])
 convolution2dLayer(7,8,'Padding',3)
 reluLayer()
 convolution2dLayer(7,16,'Padding',3)
 reluLayer()
 convolution2dLayer(7,32,'Padding',3)
 reluLayer()
 convolution2dLayer(7,64,'Padding',3)
 reluLayer()
 convolution2dLayer(1,2);
 softmaxLayer()
 pixelClassificationLayer()];

layers(end) = pixelClassificationLayer('ClassNames',tbl.Name,'ClassWeights',[19,1]);

opts = trainingOptions('adam', ...
 'InitialLearnRate', 3e-4, ...
 'MaxEpochs', 100, ...
 'MiniBatchSize', 32, ...
 'ExecutionEnvironment', 'cpu','Plots', 'training-progress');

trainingData = pixelLabelImageSource(imds,pxds);

net = trainNetwork(trainingData,layers,opts);
%%
testImage = imread('triangleTest.jpg');
C = semanticseg(testImage,net);
B = labeloverlay(testImage,C);
figure; 
imshow(B)

testImagesDir = fullfile(dataSetDir, 'testImages');
imdsTest = imageDatastore(testImagesDir);
testLabelsDir = fullfile(dataSetDir, 'testLabels');
pxdsTruthTest = pixelLabelDatastore(testLabelsDir, classNames, labelIDs);
pxdsResults = semanticseg(imdsTest, net, "WriteLocation", tempdir);

evaluationMetrics = ["accuracy" "iou"];
metrics = evaluateSemanticSegmentation(pxdsResults, pxdsTruthTest, "Metrics",evaluationMetrics);

%% Helper functions
function displayImageAndClassification(imds,pxds,index)

I = readimage(imds,index);
C = (uint8(readimage(pxds,index))-1)*255;

figure
subplot(1,2,1);
imshow(I,[]);
title("Original Image");

subplot(1,2,2);
imshow(C,[]);
title("Segmentation");


end

