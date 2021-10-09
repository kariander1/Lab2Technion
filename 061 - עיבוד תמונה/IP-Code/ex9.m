% Image Processing experiment assignment 9 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Item 1

im = imread('objects.bmp');
figure(1); imshow(im); title('Objects');

%% Item 2

stats = regionprops(im,'all');
obj=stats(15)


%% Item 3

f1 = [stats.MajorAxisLength];
f2 = [stats.ConvexArea];
figure(2); plot(f1,f2,'o');
title('Features 1');
xlabel('Major Axis Length');
ylabel('Convex Area');

%% Item 4



f1 = [stats.Perimeter];
f2 = [stats.Solidity];
figure(3); plot(f1,f2,'o');
title('Features 2');
xlabel('Perimeter');
ylabel('Solidity');

figure();
f1 = [stats.MinorAxisLength];
f2 = [stats.Circularity];
figure(4); plot(f1,f2,'o');
title('Features 3');
xlabel('MinorAxisLength');
ylabel('Circularity');
