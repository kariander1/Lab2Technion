% Image Processing experiment assignment 8 script file.
% Use existing code in this script, and add new code where needed.
% This script is made out of cells. to run a specific cell, click somewhere in it and press CTRL+ENTER.

clear;
close all;
clc;

%% Load and convert

peppers = imread('peppers.png');

% Convert from RGB model to HSV model
hsv = rgb2hsv(peppers); 

% Split to channels
red = peppers(:,:,1);
green = peppers(:,:,2);
blue = peppers(:,:,3);
hue = hsv(:,:,1);  
sat = hsv(:,:,2); 
val = hsv(:,:,3);

%% Item 1

figure(1); title('Recognition of Colors'); set(gcf,'WindowState','maximized');
subplot(3,4,1); imshow(peppers); title('Original RGB Image');
subplot(3,4,2); imshow(red); title('R (Red) of RGB Image');
subplot(3,4,3); imshow(green); title('G (Green) of RGB Image');
subplot(3,4,4); imshow(blue); title('B (Blue) of RGB Image');
subplot(3,4,5); imshow(hsv); title('Original in HSV coordinates');
subplot(3,4,6); imshow(hue); title('H (Hue) of Image');
subplot(3,4,7); imshow(sat); title('S (Saturation) of Image');
subplot(3,4,8); imshow(val); title('V (Value) of Image');
subplot(3,4,10); imshow((hue>0.95)|(hue<0.05)); title('0<Hue<0.05 or 0.95<Hue<1');
subplot(3,4,11); imshow(sat>0.5); title('Saturation > 0.5');
subplot(3,4,12); imshow(val>0.5); title('Value > 0.5');

%% Item 2

figure(2); set(gcf,'WindowState','maximized');
subplot(121); imshow(peppers); title('Original Image'); ax1 = gca; impixelinfo;

figure(3); set(gcf,'WindowState','maximized');
subplot(131); imshow(hue); impixelinfo; title('Hue');
subplot(132); imshow(sat); impixelinfo; title('Saturation');
subplot(133); imshow(val); impixelinfo; title('Value');
 
mask=((hue>=0.92) | (hue<=0.16));
hue(mask) = 0.17;

hsv(:,:,1) = hue;
newPeppers = hsv2rgb(hsv);

figure(2); 
subplot(122); imshow(newPeppers); title('Modified Image'); ax2 = gca; impixelinfo;
linkaxes([ax1,ax2],'xy');

%% Item 3

im = imread('frog.jpg');
figure();
imshow(im,[]); title("Original Frog"); impixelinfo;


% Convert from RGB model to HSV model
im_hsv = rgb2hsv(im); 
hue = im_hsv(:,:,1);  
sat = im_hsv(:,:,2); 
val = im_hsv(:,:,3);
mask_h=((hue>=0.055) & (hue<=0.14));
mask_sat = (sat>=0.5);
mask_val = (val>=0.6);
hue(mask_h & mask_sat & mask_val) = 0.6;



im_hsv(:,:,1) = hue;
newFrog = hsv2rgb(im_hsv);

figure(2); 
imshow(newFrog); title('Modified Image');



%% Item 4

colorchecker = imread('colorchecker.jpg');

lab = rgb2lab(colorchecker);
L = lab(:,:,1);
a = lab(:,:,2);
b = lab(:,:,3);

figure(4); set(gcf,'WindowState','maximized');
subplot(221); imshow(colorchecker); title('Macbeth chart ColorChecker'); ax1 = gca; impixelinfo;
subplot(222); imshow(L,[]); title('L* Channel'); ax2 = gca; impixelinfo;
subplot(223); imshow(a,[]); title('a* Channel'); ax3 = gca; impixelinfo;
subplot(224); imshow(b,[]); title('b* Channel'); ax4 = gca; impixelinfo;
linkaxes([ax1,ax2,ax3,ax4],'xy');

lab_ab=lab;
lab_ab(:,:,1)=0;

lab_lb=lab;
lab_lb(:,:,2)=0;

lab_la=lab;
lab_la(:,:,3)=0;
figure();

subplot(221); imshow(colorchecker); title('Macbeth chart ColorChecker'); ax1 = gca; impixelinfo;
subplot(222); imshow(lab2rgb(lab_ab),[]); title('No L* Channel'); ax2 = gca; impixelinfo;
subplot(223); imshow(lab2rgb(lab_lb),[]); title('No a* Channel'); ax3 = gca; impixelinfo;
subplot(224); imshow(lab2rgb(lab_la),[]); title('No b* Channel'); ax4 = gca; impixelinfo;

linkaxes([ax1,ax2,ax3,ax4],'xy');