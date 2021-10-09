function finalMask = detectPlate(plateImage)
%DETECTPLATE Detects license plate(s) in an image and returns a binary mask of the location(s)
%
% plateImage - The input image for plate detection
% finalMask  - The resulting binary mask for the plate(s)
%
%%%%%% Write your code here:

hsv = rgb2hsv(plateImage); 
hue = hsv(:,:,1);  
sat = hsv(:,:,2); 
val = hsv(:,:,3);
mask_h=((hue>=0.09) & (hue<=0.18));
mask_sat = (sat>=0.3);
mask_val = (val>=0.3);

mask = mask_h & mask_sat & mask_val;
SE_er = strel('rectangle',[4 4])  ;
SE_di = strel('rectangle',[4 4])  ;
eroded = imerode(mask,SE_er); 
corrected_mask = imdilate(eroded,SE_di);


mask_modified=bwpropfilt(corrected_mask,'Area',5);
mask_modified=bwpropfilt(mask_modified,'Orientation',[-20 20]);
mask_modified=bwpropfilt(mask_modified,'Eccentricity',[0.8 1]);
mask_modified=bwpropfilt(mask_modified,'Area',1);
%stats = regionprops(mask_modified,'all')


mask_modified = bwconvhull(mask_modified);
%
%figure();
%subplot(141);
%imshow(plateImage,[]);
%subplot(142);
%imshow(mask,[]);
%subplot(143);
%imshow(corrected_mask,[]);
%subplot(144);
%imshow(mask_modified,[]);

finalMask=mask_modified;

%%%%%%
end