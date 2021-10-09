% Image Processing experiment assignment 4 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Items 1-4

nrfiltdemo;

%% Item 5


cam_im = imread('cameraman.tif');
cam_blur = imread('cam_blur.tif');
subplot(121); imshow(cam_im,[]); title('Cameraman');
subplot(122);  imshow(cam_blur,[]); title('Camera Blur');

h = fspecial('motion',7,0);
blurred = imfilter(cam_im,h);
figure();
subplot(221); imshow(blurred,[]); title('Filterd Cameraman');
subplot(222);  imshow(cam_blur,[]); title('Camera Blur');

subplot(223);  imshow(cam_blur-blurred,[]); title('Diff');

%% Item 6

deconv_image = deconvlucy(blurred,h);
figure(); imshow(deconv_image,[]); title('Deconvolved Cameraman');