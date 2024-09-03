img_dir = '../subset/';
file_names = {dir(img_dir).name}'; 
file_names = file_names(3:end);

for i=1:length(file_names)
    file_names{i} = [img_dir file_names{i}];
end

save_folder = '../silhouettes_subset/';


mask = sam_silhouette(file_names, 2, 1, save_folder);