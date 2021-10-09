% Image Processing experiment assignment 2 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Items 1-4

imadjdemo;

%% Item 5

lb = imread('liftingbody.png');
lb_eq = histeq(lb);
figure('WindowState','maximized'); 
subplot(221); imshow(lb,[]); title('Original Image');
subplot(223); bar(imhist(lb)); title('Original Histogram');

% Insert your code here
% Important note - display a histogram using the function 'bar' with the calculated histogram
subplot(222); imshow(lb_eq,[]); title('Equalized Image');
subplot(224); bar(imhist(lb_eq)); title('Equalized Histogram');