% Image Processing experiment assignment 10 script file.
% This script is a wrapper for plate detection.
% Image file name must be "plate<N>.jpg", N>0. for example: plate7.jpg
% Only edit parameters workMode and N.

clear;
close all;
clc;

%%%%%%% Insert image file number here (N>0):
N = 14;
%%%%%%%

%%%%%%% workMode - 'mask' shows masks, 'color' shows color images.
%%%%%%% Do NOT change to 'color' until ALL your masks are final.
workMode = 'mask';
%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rest of code is automatic. Please do not change. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Build file name and load image
fid = num2str(uint8(N));
filename = ['plate',fid,'.jpg'];
plateImage = imread(filename);

%%%%%%% Detect the plate(s) in the image
finalMask = detectPlate(plateImage);

%%%%%%% Select what to display
if strcmp(workMode,'color')
    mask3D = uint8(repmat(finalMask,[1 1 3]));
    result = plateImage.*mask3D;
else
    if strcmp(workMode,'mask')
        result = finalMask;
    else
        error('The selected work mode is incorrect.');
    end
end

%%%%%%% Display results
figure('WindowState','maximized');
subplot(121); imshow(plateImage); ax1 = gca; title(['Original Image number ',num2str(N)]);
set(gca, 'Position', [0, 0.23, 0.53, 0.53]);
subplot(122); imshow(result); ax2 = gca; title('Detected Plate(s)');
set(gca, 'Position', [0.47, 0.23, 0.53, 0.53]);
linkaxes([ax1,ax2],'xy');