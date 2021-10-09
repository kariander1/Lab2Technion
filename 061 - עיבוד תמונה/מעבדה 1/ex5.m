% Image Processing experiment assignment 5 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Load image

br = imread('barbara.tif');

%% Item 1

figure(1); set(gcf,'WindowState','maximized');
subplot(121); imshow(br); title('Barbara');
subplot(122); imhist(br); title('Barbara Histogram');

err = zeros(1,3);
quan_vec = [4 8 16];


N = 16;
levels = linspace(0,256,N+1);
values = levels(1:end-1)+(128/N);
br_qu=uint8(imquantize(br,levels(2:end-1),values));
figure(2); set(gcf,'WindowState','maximized');
subplot(121); imshow(br_qu); title(['Barbara uniformly quantized to N=',num2str(N),' levels']);
subplot(122); histogram(br_qu(:)); title(['Histogram of Barbara uniformly quantized to N=',num2str(N),' levels']);
err(3) = immse(br,br_qu);

N = 4;
levels = linspace(0,256,N+1);
values = levels(1:end-1)+(128/N);
br_qu=uint8(imquantize(br,levels(2:end-1),values));
figure(3); set(gcf,'WindowState','maximized');
subplot(121); imshow(br_qu); title(['Barbara uniformly quantized to N=',num2str(N),' levels']);
subplot(122); histogram(br_qu(:)); title(['Histogram of Barbara uniformly quantized to N=',num2str(N),' levels']);
err(1) = immse(br,br_qu);
N = 8;
levels = linspace(0,256,N+1);
values = levels(1:end-1)+(128/N);
br_qu=uint8(imquantize(br,levels(2:end-1),values));
figure(4); set(gcf,'WindowState','maximized');
subplot(121); imshow(br_qu); title(['Barbara uniformly quantized to N=',num2str(N),' levels']);
subplot(122); histogram(br_qu(:)); title(['Histogram of Barbara uniformly quantized to N=',num2str(N),' levels']);
err(2) = immse(br,br_qu);

figure(); stem(quan_vec,err); xlabel("Q Levels"); ylabel("MSE");

%% Item 2

N = 16;
[levels,values] = lloyds(double(br(:)),N);
br_qo = uint8(imquantize(br,levels,values));
figure(20); set(gcf,'WindowState','maximized');
subplot(121); imshow(br_qo); title(['Barbara optimaly quantized to N=',num2str(N),' levels']);
subplot(122); histogram(br_qo(:)); title(['Histogram of Barbara optimaly quantized to N=',num2str(N),' levels']);
err(3) = immse(br,br_qo);


N = 8;
[levels,values] = lloyds(double(br(:)),N);
br_qo = uint8(imquantize(br,levels,values));
figure(21); set(gcf,'WindowState','maximized');
subplot(121); imshow(br_qo); title(['Barbara optimaly quantized to N=',num2str(N),' levels']);
subplot(122); histogram(br_qo(:)); title(['Histogram of Barbara optimaly quantized to N=',num2str(N),' levels']);
err(2) = immse(br,br_qo);

N =4;
[levels,values] = lloyds(double(br(:)),N);
br_qo = uint8(imquantize(br,levels,values));
figure(22); set(gcf,'WindowState','maximized');
subplot(121); imshow(br_qo); title(['Barbara optimaly quantized to N=',num2str(N),' levels']);
subplot(122); histogram(br_qo(:)); title(['Histogram of Barbara optimaly quantized to N=',num2str(N),' levels']);

err(1) = immse(br,br_qo);
figure(); stem(quan_vec,err); xlabel("Q Levels"); ylabel("MSE");
%% Item 3

% Show original blocks
figure(40); set(gcf,'WindowState','maximized');
coord1 = [179 6 15 15];
b1 = imcrop(br,coord1);
subplot(231); imshow(b1); title('Block 1');

coord2 = [184 384 15 15];
b2 = imcrop(br,coord2);
subplot(232); imshow(b2); title('Block 2');

coord3 = [420 466 15 15];
b3 = imcrop(br,coord3);
subplot(233); imshow(b3); title('Block 3');

% Show DCT blocks
b1_dct = dct2(b1);
b2_dct = dct2(b2);
b3_dct = dct2(b3);
subplot(234); imshow(sqrt(abs(b1_dct)),[0 50]); title('DCT of Block 1');
subplot(235); imshow(sqrt(abs(b2_dct)),[0 50]); title('DCT of Block 2');
subplot(236); imshow(sqrt(abs(b3_dct)),[0 50]); title('DCT of Block 3');


%% Item 4

br_dct_b = blockproc(br,[8 8],@(block_struct)dct2(block_struct.data));
br_abs_dct_b = abs(br_dct_b);
figure; imshow(sqrt(br_abs_dct_b),[]); title('DCT of all blocks'); impixelinfo;

br_less = br_abs_dct_b<10;
pix_ratio = sum(br_less,'all')*100/(512*512);
%% Item 5

br_dct_b(br_abs_dct_b<10) = 0;
br_r = uint8(blockproc(br_dct_b,[8 8],@(block_struct)idct2(block_struct.data)));
br_r_mse = immse(br,br_r);
figure(100); set(gcf,'WindowState','maximized');
subplot(121); imshow(br); ax1 = gca; title('Original Image');
subplot(122); imshow(br_r); ax2 = gca; title(['Restored Image, MSE = ',num2str(br_r_mse)]);
linkaxes([ax1,ax2],'xy');