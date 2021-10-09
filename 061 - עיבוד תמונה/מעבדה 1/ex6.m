% Image Processing experiment assignment 6 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Load Image

im = imread('church.tif');
figure();
imshow(im,[]);
%% Item 1

imedge = edge(im,'SOBEL',0,'both');
figure(2); imshow(imedge,[]); title('SOBEL, Thresh=0'); set(gcf,'WindowState','maximized');
imedge = edge(im,'SOBEL',0.09,'both');
figure(3); imshow(imedge,[]); title('SOBEL, Thresh=0.09'); set(gcf,'WindowState','maximized');
imedge = edge(im,'SOBEL',0.2,'both');
figure(4); imshow(imedge,[]); title('SOBEL, Thresh=0.2'); set(gcf,'WindowState','maximized');

%% Item 2

imedge = edge(im,'CANNY',0.35,0.1);
figure(5); imshow(imedge,[]); title('CANNY, Thresh=0.35, Sigma=0.1'); set(gcf,'WindowState','maximized');
imedge = edge(im,'CANNY',0.35,1);
figure(6); imshow(imedge,[]); title('CANNY, Thresh=0.35, Sigma=1'); set(gcf,'WindowState','maximized');
imedge = edge(im,'CANNY',0.35,5);
figure(7); imshow(imedge,[]); title('CANNY, Thresh=0.35, Sigma=5'); set(gcf,'WindowState','maximized');
imedge = edge(im,'CANNY',0.5,1.5);
figure(8); imshow(imedge,[]); title('CANNY, Thresh=0.5, Sigma=1.5'); set(gcf,'WindowState','maximized');


%% Item 3

imedge = edge(im,'SOBEL',0.1,'both');
figure(8); imshow(imedge,[]); title('SOBEL'); set(gcf,'WindowState','maximized');
imedge = edge(im,'LOG',0.017,1.5);
figure(9); imshow(imedge,[]); title('LoG'); set(gcf,'WindowState','maximized');
imedge = edge(im,'CANNY',0.25,1);
figure(10); imshow(imedge,[]); title('CANNY'); set(gcf,'WindowState','maximized');

%% Item 4

std_n = 40;
noise = std_n*randn(size(im));	
im_n = uint8(double(im)+noise);
imedge = edge(im_n,'CANNY',0.25,1);
figure(11); imshow(imedge,[]); title('CANNY'); set(gcf,'WindowState','maximized');

imedge = edge(im_n,'CANNY',0.4,1.5);
figure(12); imshow(imedge,[]); title('CANNY'); set(gcf,'WindowState','maximized');