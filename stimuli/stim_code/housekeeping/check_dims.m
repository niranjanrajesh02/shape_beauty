img_dir_path = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\combined\";

% for each image in the directory check if the image is of the same size (234x234)

img_dir = dir(img_dir_path);
% remove . and .. from the list
img_dir = img_dir(3:end);

for i = 1:length(img_dir)
    img_name = img_dir(i).name;
    img_path = strcat(img_dir_path, img_name);
    img = imread(img_path);
    
    if size(img, 1) ~= 234 || size(img, 2) ~= 234
        disp(img_name);
    end
end
