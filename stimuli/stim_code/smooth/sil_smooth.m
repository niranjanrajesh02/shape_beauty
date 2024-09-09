close all;

img_path = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\sil\Image047_bee_20s.png";

img = imread(img_path);
img =  double(img(:, :, 1) ~= 0);

w = 10;
% mean filter
mean_filter = fspecial('average', [w w]);
mean_img = imfilter(img, mean_filter);

% median filter
median_img = medfilt2(img, [w w]);

% gaussian filter
gaussian_filter = fspecial('gaussian', [w w], 2);
gaussian_img = imfilter(img, gaussian_filter);

 
% threshold
thresh = 0.4;
mean_img = mean_img > thresh;
gaussian_img = gaussian_img > thresh;


figure;
subplot(1, 4, 1);
imshow(img);
title('Original Image');

subplot(1, 4, 2);
imshow(mean_img);
title('Mean Filter');

subplot(1, 4, 3);
imshow(median_img);
title('Median Filter');

subplot(1, 4, 4);
imshow(gaussian_img);
title('Gaussian Filter');

% save each image
imwrite(mean_img, 'smooth_results/mean_img.png');
imwrite(median_img, 'smooth_results/median_img.png');
imwrite(gaussian_img, 'smooth_results/gaussian_img.png');
imwrite(img, 'smooth_results/original_img.png');

% save plots
saveas(gcf, 'smooth_results/sil_smooth.png');