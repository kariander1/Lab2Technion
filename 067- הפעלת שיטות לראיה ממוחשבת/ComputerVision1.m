%% 1.1
figure(1);
boxImage = imread('stapleRemover.jpg');
imshow(boxImage);
title("Staple Remover Reference");

%% 1.2
figure(2)
sceneImage = imread('clutteredDesk.jpg');

imshow(sceneImage);
title("Cluttered Desk");

%% 1.3


scene_points = detectSURFFeatures(sceneImage);
[scene_features,scene_valid_points]  = extractFeatures(sceneImage,scene_points);

stapler_points = detectSURFFeatures(boxImage);
[stapler_features,stapler_valid_points]  = extractFeatures(boxImage,stapler_points);

index_pairs = matchFeatures(scene_features,stapler_features);

scene_matched_points = scene_valid_points(index_pairs(:,1));
stapler_matched_points = stapler_valid_points(index_pairs(:,2));
figure(3);
showMatchedFeatures(sceneImage,boxImage,scene_matched_points,stapler_matched_points);
title("Matched Points")

[tForm,stapler_inlier_points,scene_inlier_points] = estimateGeometricTransform(stapler_matched_points,scene_matched_points,'similarity');
%% 1.4
boxPolygon = [1, 1;... % top-left
size(boxImage, 2), 1;... % top-right
size(boxImage, 2), size(boxImage, 1);... % bottom-right
1, size(boxImage, 1);... % bottom-left
1, 1]; % top-left again to close the polygon

%% 1.5
trans_polygon = transformPointsForward(tForm,boxPolygon);

%% 1.6

imshow(sceneImage);
drawpolygon('Position',trans_polygon);
title("Polygon on Scene")
%hold on
%imshow(trans_image);   % specify your locations here

%% 2.1

view_1_rgb =imread('view1.png');
view_1 = rgb2gray(view_1_rgb);
view_2_rgb =imread('view2.png');
view_2 = rgb2gray(view_2_rgb);


%% 2.10
affine_panorama = createPanorama(view_1,view_2,'affine');
figure
imshow(imcrop(affine_panorama,[0 20 920 415 ]));
title("Panorama Affine");


%% 2.11
[projective_panorama,tForm] = createPanorama(view_1,view_2,'projective');
figure
imshow(imcrop(projective_panorama,[0 160 1167 407]));
title("Panorama Projective");

%% 2.12
panorama_red=createPanorama(view_1_rgb(:,:,1),view_2_rgb(:,:,1),'projective',tForm);
panorama_green=createPanorama(view_1_rgb(:,:,2),view_2_rgb(:,:,2),'projective',tForm);
panorama_blue=createPanorama(view_1_rgb(:,:,3),view_2_rgb(:,:,3),'projective',tForm);

panorama_color = cat(3,panorama_red,panorama_green,panorama_blue);
figure
imshow(imcrop(panorama_color,[0 160 1167 407]));
title("Panorama Color");

%% 2.2

function [panorama,tForm] = createPanorama(view_1,view_2,estimationType,tFormOverride)

if ~exist('tFormOverride','var')

    view_1_points = detectSURFFeatures(view_1);
    [view_1_features,view_1_valid_points]  = extractFeatures(view_1,view_1_points);

    view_2_points = detectSURFFeatures(view_2);
    [view_2_features,view_2_valid_points]  = extractFeatures(view_2,view_2_points);

    index_pairs = matchFeatures(view_1_features,view_2_features);


    view_1_matched_points = view_1_valid_points(index_pairs(:,1));
    view_2_matched_points = view_2_valid_points(index_pairs(:,2));
    figure(3);
    showMatchedFeatures(view_1,view_2,view_1_matched_points,view_2_matched_points);

    %% 2.3
    [tForm,view_2_inlier_points,view_1_inlier_points] = estimateGeometricTransform(view_2_matched_points,view_1_matched_points,estimationType);
else
    tForm = tFormOverride;
end
%% 2.4
x1_min = 1;
y1_min = 1;
[y1_max, x1_max]  = size(view_1);

%% 2.5
view_2_size = size(view_2);
[x2_range,y2_range] = outputLimits(tForm,[1 view_2_size(2)],[1 view_2_size(1)]);

%% 2.6
height = max(y1_max,int16(y2_range(2))) - min(y1_min,int16(y2_range(1)));
width = max(x1_max,int16(x2_range(2))) - min(x1_min,int16(x2_range(1)));
panorama = zeros(height,width);

%% 2.7
x_min = min(x1_min,x2_range(1));
y_min = min(y1_min,y2_range(1));
x_max = max(x1_max,x2_range(2));
y_max = max(y1_max,y2_range(2));
panoramaView = imref2d([height width],[x_min,x_max], [y_min,y_max]); 

%% 2.8
panorama1 = zeros(size(panorama));
ident_transform = affine2d(eye(3));
panorama1 = imwarp(view_1,ident_transform,'OutputView',panoramaView);

%% 2.9
panorama2 = zeros(size(panorama));
panorama2 = imwarp(view_2,tForm,'OutputView',panoramaView);
panorama2(:,1:x1_max)=0;

%% 2.10
panorama = panorama1 + panorama2;
end