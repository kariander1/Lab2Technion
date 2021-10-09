%% 3.1
datasetPath_train = 'C:\CV_exp\fashionMNIST\trainImages';
imds_train = imageDatastore(datasetPath_train, ...
 'IncludeSubfolders',true,'LabelSource','foldernames');
datasetPath_test = 'C:\CV_exp\fashionMNIST\testImages';
imds_test = imageDatastore(datasetPath_test, ...
 'IncludeSubfolders',true,'LabelSource','foldernames');

%% 3.2

figure
title("Random train images");
for i=1:30
    imNum = randi(60000);
    I = readimage(imds_train, imNum);
    subplot(3,10,i);
    imshow(I,[]);
end


figure
title("Random tests images")
for i=1:30
    imNum = randi(10000);
    I = readimage(imds_test, imNum);
    subplot(3,10,i);
    imshow(I,[]);
end
%% 3.3


opts = trainingOptions('adam', ...
 'InitialLearnRate', 1e-4, ...
 'MaxEpochs', 1, ...
 'MiniBatchSize', 256, ...
 'ExecutionEnvironment', 'cpu','Plots', 'training-progress');

layers = [
	imageInputLayer([28 28 1],'Name','input','Normalization', 'none')

	convolution2dLayer(5,4,'Padding',1, 'Name','Block1Start')
	batchNormalizationLayer('Name','BN1')
	reluLayer('Name','ReLU1')
	convolution2dLayer(5,8,'Name','Conv1')
	batchNormalizationLayer('Name','BN2')
	reluLayer('Name','Block1End')

    additionLayer(2, 'Name','Block2Start')
	convolution2dLayer(5,16,'Padding',1, 'Name','Conv2')
	batchNormalizationLayer('Name','BN3')
	reluLayer('Name','ReLU2')
	convolution2dLayer(5,32,'Name','Conv3')
	batchNormalizationLayer('Name','BN4')
	reluLayer('Name','Block2End')
	
    additionLayer(2, 'Name','Block3Start')
	convolution2dLayer(3,64,'Name','Conv4')
	batchNormalizationLayer('Name','BN5')
	reluLayer('Name','ReLU3')
	convolution2dLayer(3,128,'Padding',1, 'Name','Conv5')
	batchNormalizationLayer('Name','BN6')
	reluLayer('Name','Block3End')
	
    additionLayer(2, 'Name','EndStart')
	fullyConnectedLayer(10, 'Name','FC')
	softmaxLayer('Name','SoftMax')
	classificationLayer('Name','Clasification')
];

lgraph = layerGraph(layers);

skip1_layer = convolution2dLayer(7,8, 'Name','SkipConv1');

lgraph = addLayers(lgraph,skip1_layer);
skip2_layer = convolution2dLayer(7,32, 'Name','SkipConv2');
lgraph = addLayers(lgraph,skip2_layer);
skip3_layer = convolution2dLayer(3,128, 'Name','SkipConv3');
lgraph = addLayers(lgraph,skip3_layer);


lgraph = connectLayers(lgraph, 'input', 'SkipConv1');
lgraph = connectLayers(lgraph, 'SkipConv1', 'Block2Start/in2');
lgraph = connectLayers(lgraph, 'Block2Start', 'SkipConv2');
lgraph = connectLayers(lgraph, 'SkipConv2', 'Block3Start/in2');
lgraph = connectLayers(lgraph, 'Block3Start', 'SkipConv3');
lgraph = connectLayers(lgraph, 'SkipConv3', 'EndStart/in2');

figure
plot(lgraph);


%% 3.4
net = trainNetwork(imds_train,lgraph,opts);

%% 3.5
YPred = classify(net,imds_test);
%% 3.5.1
err_count = 0;
for i=1:10000
    if YPred(i) ~= imds_test.Labels(i)
        err_count = err_count +1;
    end
end
err_ratio = err_count/numel(YPred);

%% 3.6

opts = trainingOptions('adam', ...
 'InitialLearnRate', 1e-4, ...
 'MaxEpochs', 3, ...
 'MiniBatchSize', 256, ...
 'ExecutionEnvironment', 'cpu','Plots', 'training-progress');

layers = [
	imageInputLayer([28 28 1],'Name','input','Normalization', 'none')

	convolution2dLayer(5,4,'Padding',1, 'Name','Block1Start')
	batchNormalizationLayer('Name','BN1')
	reluLayer('Name','ReLU1')
	convolution2dLayer(5,8,'Name','Conv1')
	batchNormalizationLayer('Name','BN2')
	reluLayer('Name','Block1End')

    
	convolution2dLayer(5,16,'Padding',1, 'Name','Conv2')
	batchNormalizationLayer('Name','BN3')
	reluLayer('Name','ReLU2')
	convolution2dLayer(5,32,'Name','Conv3')
	batchNormalizationLayer('Name','BN4')
	reluLayer('Name','Block2End')
	
    
	convolution2dLayer(3,64,'Name','Conv4')
	batchNormalizationLayer('Name','BN5')
	reluLayer('Name','ReLU3')
	
    
	fullyConnectedLayer(10, 'Name','FC')
	softmaxLayer('Name','SoftMax')
	classificationLayer('Name','Clasification')
];

lgraph = layerGraph(layers);

figure
plot(lgraph);


%% 3.6.1
net = trainNetwork(imds_train,lgraph,opts);

%% 3.6.2
YPred = classify(net,imds_test);
err_count = 0;
for i=1:10000
    if YPred(i) ~= imds_test.Labels(i)
        err_count = err_count +1;
    end
end
err_ratio = err_count/numel(YPred);

%% 3.7

for i=1:30
    imNum = randi(10000);
    I = readimage(imds_test, imNum);
    subplot(3,10,i);
    imshow(I,[]);
    title(strcat("Image ",int2str(imNum),": ",char(YPred(imNum))));
end
