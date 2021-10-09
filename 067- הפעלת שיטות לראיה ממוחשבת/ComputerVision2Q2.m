

%% 2.1
baseDir = 'C:\CV_exp';
addpath(fullfile(baseDir,'functions'));
pretrainedSegNet = fullfile(baseDir,'segnetVGG16CamVid.mat');
imDir = fullfile(baseDir,'Raw');
labelDir = fullfile(baseDir,'Labeled');
labelIDs = camvidPixelLabelIDs;
classes = SegNetClasses;
cmap = camvidColorMap;
imds = imageDatastore(imDir);
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);

%% 2.2
figure
displayImageAndClassificationOverlay(classes,cmap,imds,pxds,5);
title("Frame N.5")
figure
displayImageAndClassificationOverlay(classes,cmap,imds,pxds,10);
title("Frame N.10")

%% 2.3
lgraph = segnetLayers([360,480,3],11,'vgg16');
lgraph.Layers

%% 2.5

data = load(pretrainedSegNet);
net = data.net;

%% 2.6

displayFromTrainedSet(classes,cmap,net,imds,5,pxds);
title("Frame N.5 segemented")

displayFromTrainedSet(classes,cmap,net,imds,10,pxds);
title("Frame N.10 segemented")

displayFromTrainedSet(classes,cmap,net,imds,15,pxds);
title("Frame N.15 segemented")

%% 2.8

videoWriterOBJ = vision.VideoFileWriter('video.mp4','FileFormat','MPEG4','FrameRate',2);
for ii=150:200
 img = imresize(readimage(imds,ii),[360 480]);
 C = semanticseg(img, net);
 img_segmented = labeloverlay(img,C,'ColorMap',cmap);
 img_both = [img,zeros(360,5,3),img_segmented];
 step(videoWriterOBJ,img_both);
end
release(videoWriterOBJ);


%% Helper functions
function displayFromTrainedSet(classes,cmap,net,imds, imNum,pxds)

I1 = readimage(imds, imNum);
GT = readimage(pxds, imNum);
GT_B = labeloverlay(I1,GT,'ColorMap',cmap);

I1 = imresize(I1,[360,480]);
C1 = semanticseg(I1,net);
B1  = labeloverlay(I1,C1,'ColorMap',cmap);


figure
subplot(1,2,1)
imshow(GT_B)
title('Original Labeling')
pixelLabelColorbar(cmap,classes);
subplot(1,2,2)
imshow(B1)
title('Segmented')
pixelLabelColorbar(cmap,classes);

end

function displayImageAndClassificationOverlay(classes,cmap,imds,pxds,imNum)

I = readimage(imds, imNum);
imshow(I)
C = readimage(pxds, imNum);
B = labeloverlay(I,C,'ColorMap',cmap);
imshow(B)
pixelLabelColorbar(cmap,classes);

end