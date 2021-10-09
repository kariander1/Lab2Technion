% Image Processing experiment assignment 3 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Item 1

im = imread('rice.png');
subplot(121); imshow(im,[]); title('Rice');
subplot(122); bar(imhist(im)); title('Rice Histogram');

%% Item 2

Thresh = 100;
bw = im>Thresh;
Percent = 100*nnz(bw)/numel(bw);
figure(2);subplot(221); imshow(bw,[]); title(['Threshold = ',num2str(Thresh),', Percent = ',num2str(round(Percent,2)),'%']);

Thresh = 60;
bw = im>Thresh;
Percent = 100*nnz(bw)/numel(bw);
subplot(222); imshow(bw,[]); title(['Threshold = ',num2str(Thresh),', Percent = ',num2str(round(Percent,2)),'%']);

Thresh = 120;
bw = im>Thresh;
Percent = 100*nnz(bw)/numel(bw);
subplot(223); imshow(bw,[]); title(['Threshold = ',num2str(Thresh),', Percent = ',num2str(round(Percent,2)),'%']);

Thresh = 150;
bw = im>Thresh;
Percent = 100*nnz(bw)/numel(bw);
subplot(224); imshow(bw,[]); title(['Threshold = ',num2str(Thresh),', Percent = ',num2str(round(Percent,2)),'%']);

%% Item 3


im = imread('pieces.png');
subplot(121); imshow(im,[]); title('pieces');
subplot(122); bar(imhist(im)); title('pieces Histogram');


Thresh = 200;
pbw = im>Thresh;
figure();
pbw = 1-pbw;
imshow(pbw,[]); title("Thresholded image");
%% Item 4

CC = bwconncomp(pbw);
labels = labelmatrix(CC);
cmap = rand(1000,3);
figure(100); set(gcf,'WindowState','maximized'); 
subplot(121); imshow(labels,[]); title('Before Coloring');
subplot(122); imshow(labels,cmap); title('After Coloring');