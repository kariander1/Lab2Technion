% Image Processing experiment assignment 7 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Item 1

p1 = zeros(5); p1(2:4,3) = ones(3,1); 
SE1 = strel('arbitrary',[1 1 1]);
SE2 = strel('arbitrary',[1 1 1]');

dilate1 = imdilate(p1,SE1);
dilate2 = imdilate(p1,SE2);

% Print table to screen
T7a = PrintTable('Question 7a Results');
T7a.HasHeader = true;
T7a.addRow('Original Patch','Dilation with SE1','Dilation with SE2');
T7a.addRows(num2str(p1),[num2str(dilate1) repmat(' ',5,2)],num2str(dilate2));
disp(T7a);

%% Item 2

p2 = zeros(6); p2(2:5,2:5) = ones(4);
SE3 = strel('square',3);
SE4 = strel('pair', [2 2]);

erode1 = imerode(p2,SE3);
erode2 = imerode(p2,SE4);

% Print table to screen
T7b = PrintTable('Question 7b Results');
T7b.HasHeader = true;
T7b.addRow('Original Patch  ','Erosion with SE3','Erosion with SE4');
T7b.addRows(num2str(p2),num2str(erode1),num2str(erode2));
disp(T7b);

%% Item 3

im1 = imread('shapes.jpg');
SE5 = strel('disk',30,8);                % Change disk size here (the first number)
eroded = imerode(im1,SE5); 
final = imdilate(eroded,SE5);

figure(1); set(gcf,'WindowState','maximized');
subplot(221); imshow(im1,[]); title('Original Image');
subplot(223); imshow(eroded,[]); title('Eroded Image');
subplot(224); imshow(final,[]); title('Circles');
impixelinfo;
%% Item 4


im = imread('pieces.png');
Thresh = 200;
pbw = im>Thresh;
figure();
pbw = 1-pbw;


SE6 = strel('disk',7,8);                % Change disk size here (the first number)
eroded = imerode(pbw,SE6); 
%eroded = imerode(eroded,SE6); 
final_pieces = imdilate(eroded,SE6);
%final_pieces = imdilate(final_pieces,SE6);
figure();
subplot(221); imshow(pbw,[]); title('Original Image');
subplot(223); imshow(eroded,[]); title('Eroded Image');
subplot(224); imshow(final_pieces,[]); title('Pieces with no bolts');
title("")
%% Item 5

im2 = imread('rice.png');
SE7 = strel('disk',7,8);      

eroded = imerode(im2,SE7); 
diff_image = im2-eroded;

figure();
subplot(221); imshow(im2,[]); title('Original Image');
subplot(223); imshow(eroded,[]); title('Eroded Image');
subplot(224); imshow(diff_image,[]); title('Diff Image');
%% Item 6
figure();
subplot(121); imshow(diff_image,[]); title('rice');
subplot(122); bar(imhist(diff_image)); title('rice Histogram');
impixelinfo();

threshold=50;
bw = diff_image>threshold;
figure();
imshow(bw);
title("Binary Rice");
impixelinfo();


Lower = 150;                          % Change code here
Upper = 300;                          
bw_modified=bwpropfilt(bw,'Area',[Lower Upper]);
CC = bwconncomp(bw_modified);
fprintf('\nThe number of rice grains in the image is %d.\n',CC.NumObjects);
riceArea = nnz(bw_modified)/CC.NumObjects;
fprintf('The average area of a rice grain in the image is %5g pixels.\n',riceArea);
figure();
imshow(bw_modified,[]);
title("Modified Rice");