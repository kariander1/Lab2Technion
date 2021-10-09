% Image Processing experiment assignment 1 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Item 1

im = imread('toucan.tif');
figure(1); imshow(im); title('Toucan');
imfinfo('toucan.tif')

%% Item 2

min_value = min(im,[],'all')
max_value = max(im,[],'all')
mean_value = mean(im,'all')

%% Item 3

N=18;
num_of_pix = sum(sum(im==N));

%% Item 4

N=170;
L=im(N,:);
figure(2);
plot(L);
title("Row N.170")

%% Item 5

figure(3); set(gcf,'WindowState','maximized');
subplot(121); imhist(im); title('Toucan Histogram');
std_n = 15;							      
noise = std_n*randn(size(im));  
im_n = uint8(double(im)+noise);
figure(2); imshow(im_n); title('Noisy Toucan');
figure(3); 
subplot(122); imhist(im_n); title('Noisy Toucan Histogram');

%% Item 6

wh = imread('whitehouse.tif');
figure(5); imshow(wh); title('White House');
impixelinfo;
threshold = 228;
wh(wh>threshold)=0;
figure(6); imshow(wh); title('Blacked House');
impixelinfo;