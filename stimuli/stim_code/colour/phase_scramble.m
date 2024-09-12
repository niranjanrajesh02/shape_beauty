
close all;

img_dir_path = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\iso\";
save_dir = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\phase_scrambled\";
img_dir = dir(img_dir_path);
% remove . and .. from the list
img_dir = img_dir(3:end);

for i = 1:length(img_dir)
    img_name = img_dir(i).name;
    img_path = strcat(img_dir_path, img_name);
    img = imread(img_path);
    
    % phase scramble
    scrambled_img = imscramble(img, 0.8);
    
    save_path = strcat(save_dir, img_name);
    imwrite(scrambled_img, save_path);
end

% scrambled_img = imscramble(img,scramble_strengths(i));
