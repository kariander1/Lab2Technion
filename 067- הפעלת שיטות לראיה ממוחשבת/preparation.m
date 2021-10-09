%% 2.1
original = imread('cameraman.tif');
figure(1);
imshow(original);
title("Original Cameraman");

%% 2.2

theta = 20;
scale_factor = 0.75;
distorted = imresize(imrotate(original,theta),scale_factor);

figure(2);
imshow(distorted,[]);
title("Distorted Cameraman");

%% 2.3

original_points = detectSURFFeatures(original);
[original_features,original_valid_points]  = extractFeatures(original,original_points);

distorted_points = detectSURFFeatures(distorted);
[distorted_features,distorted_valid_points]  = extractFeatures(distorted,distorted_points);


%% 2.4

index_pairs = matchFeatures(original_features,distorted_features);

%% 2.5
original_matched_points = original_valid_points(index_pairs(:,1));
distorted_matched_points = distorted_valid_points(index_pairs(:,2));
figure(3);
showMatchedFeatures(original,distorted,original_matched_points,distorted_matched_points);

%% 2.7

[tForm,original_inlier_points,distorted_inlier_points] = estimateGeometricTransform(original_matched_points,distorted_matched_points,'similarity');
%original_inlier_points = original_matched_points(inlierIdx,:);
%distorted_inlier_points = distorted_matched_points(inlierIdx,:);

figure(4);
showMatchedFeatures(original,distorted,original_inlier_points,distorted_inlier_points);

%% 2.8

scale_cos = tForm.T(1,1);
scale_sin = tForm.T(2,1);
tForm.T
scale = sqrt(scale_cos*scale_cos + scale_sin*scale_sin );
rotation = atan2(scale_sin,scale_cos)*180/pi;


%% 2.9

outputView = imref2d(size(original));
recovered = imwarp(distorted,invert(tForm),'OutputView',outputView);

figure(5);
imshow(recovered,[]);
title("Recovered Image");

