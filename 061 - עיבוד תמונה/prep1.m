%% 1
[X Y]=meshgrid(1:1:127);
im=(128-X+Y);
imshow(im,[]);

%%
figure(1);imshow(im,[0 127]); impixelinfo;
figure(2);imshow(im,[50 150]);impixelinfo;
figure(3);imshow(im,[150 255]); impixelinfo;
figure(4);imshow(im,[]); impixelinfo;

%% 2

x=(0:255);
y=0.5.*x;
figure;
plot(y,x,'r');
title("Contrast stretch");
xlabel('Old pixel value');
ylabel('New pixel value');
xlim([0,255]);
%% 2.4


bright_rice = imread('IP-Images\flied_lice.png');
min_in = min(bright_rice,[],'all');
max_in = max(bright_rice,[],'all');
stretched_rice = imadjust(bright_rice);
figure();
subplot(2,2,1);
imshow(bright_rice);
subplot(2,2,2);
imhist(bright_rice);
subplot(2,2,3);
imshow(stretched_rice);
subplot(2,2,4);
imhist(stretched_rice);

%% 3.5


threshold = 168;
level = threshold/256;
x=(0:255);
y=(0.*(x<threshold))+(1.*(x>=threshold));

figure;
plot(x,y,'r');
title("Thresholding");
xlabel('Old pixel value');
ylabel('New pixel value');
xlim([0,255]);




bright_rice = imread('IP-Images\flied_lice.png');
stretched_rice = imadjust(bright_rice);
figure();
subplot(2,2,1);
imshow(bright_rice);
subplot(2,2,2);
imhist(bright_rice);

thresholded_rice = imbinarize(bright_rice,level);
subplot(2,2,3);
imshow(thresholded_rice);
subplot(2,2,4);
imhist(thresholded_rice);
xlim([-1 2]);


%% 4.7

h = fspecial('average',9);
blurred_rice = imfilter(bright_rice,h);
imshowpair(bright_rice,blurred_rice,'montage');
title("Original Rice                          Blurred Rice")


%% 5.4
err = immse(bright_rice,blurred_rice);
err_same = immse(bright_rice,bright_rice);
