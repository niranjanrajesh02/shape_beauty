close all;

% Keeps nat images that are present in iso images
iso_dir_path = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\iso\";
nat_dir_path = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\nat\";

iso_dir = dir(iso_dir_path);
nat_dir = dir(nat_dir_path);

% remove . and .. from the list
iso_dir = iso_dir(3:end);
nat_dir = nat_dir(3:end);

% iterate over all nat_dir images and delete if the image is not present in iso_dir
for i = 1:length(nat_dir)
    nat_img_name = nat_dir(i).name;
    nat_img_path = strcat(nat_dir_path, nat_img_name);
    
    % check if the image is present in iso_dir
    iso_img_name = strcat(nat_img_name(1:end-4), '.png');
    iso_img_path = strcat(iso_dir_path, iso_img_name);
    
    if ~isfile(iso_img_path)
        delete(nat_img_path);
    end
end