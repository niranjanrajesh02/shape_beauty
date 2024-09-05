gpuDevice(1);
img_dir = '../stim_set/';
file_names = {dir(img_dir).name}'; 
file_names = file_names(3:end);

for i=1:length(file_names)
    file_names{i} = [img_dir file_names{i}];
end

save_folder = '../segmentation_set/';


mask = sam_silhouette(file_names, save_folder);