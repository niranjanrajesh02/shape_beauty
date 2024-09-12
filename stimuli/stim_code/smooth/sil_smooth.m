close all;

img_dir_path = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\sil\";
save_dir_path = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\sil_smooth\";

img_dir = dir(img_dir_path);
% remove . and .. from the list
img_dir = img_dir(3:end);

% iterate over all images in the directory and create gaussian with w=15 and sigma=2 and save the images

for i = 1:length(img_dir)
    img_name = img_dir(i).name;
    img_path = strcat(img_dir_path, img_name);
    img = imread(img_path);
    img =  double(img(:, :, 1) ~= 0);
    
    w = 15;
    sigma = 2;
    img_gaussian = imgaussfilt(img, sigma, "FilterSize", w);
    
    save_path = strcat(save_dir_path, img_name);
    imwrite(img_gaussian, save_path);
end






% img = imread(img_path);
% img =  double(img(:, :, 1) ~= 0);

% figure;
% subplot(1, 4, 1);
% imshow(img);
% title('Original Image');


% subplot(1, 4, 2);
% w = 5;
% sigma = 2;

% % gaussian filter
% img_gaussian1 = imgaussfilt(img, sigma, "FilterSize", w);
% imshow(gaussian_img);
% title(['Gaussian Filter', ' w = ', num2str(w), ' sigma = ', num2str(sigma)]);

% subplot(1, 4, 3);
% w = 9;
% sigma = 2;
% img_gaussian2 = imgaussfilt(img, sigma, "FilterSize", w);
% imshow(img_gaussian2);
% title(['Gaussian Filter', ' w = ', num2str(w), ' sigma = ', num2str(sigma)]);

% subplot(1, 4, 4);
% w = 15;
% sigma = 2;
% img_gaussian3 = imgaussfilt(img, sigma, "FilterSize", w);
% imshow(img_gaussian3);
% title(['Gaussian Filter', ' w = ', num2str(w), ' sigma = ', num2str(sigma)]);
% show fig


% save each image
% imwrite(mean_img, 'smooth_results/mean_img.png');
% imwrite(median_img, 'smooth_results/median_img.png');
% imwrite(gaussian_img, 'smooth_results/gaussian_img.png');
% imwrite(img, 'smooth_results/original_img.png');

% save plots
% saveas(gcf, 'smooth_results/sil_smooth.png');