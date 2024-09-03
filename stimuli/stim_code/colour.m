img_dir = '../subset/';
file_names = {dir(img_dir).name}';
file_names = file_names(3:end);

for i=1:length(file_names)
    file_names{i} = [img_dir file_names{i}];
end

save_folder = '../subset_colour/';

% extract colour statistics of image

function patched_img = patch_shuffle_img(image, patch_size)
[rows, cols, ~] = size(image);
patched_img = zeros(rows, cols, 3);
for i = 1:patch_size:rows-patch_size
    for j = 1:patch_size:cols-patch_size
        patch = image(i:i+patch_size-1, j:j+patch_size-1, :);
        patch = reshape(patch, [patch_size^2, 3]);
        patch = patch(randperm(patch_size^2), :);
        patch = reshape(patch, [patch_size, patch_size, 3]);
        patched_img(i:i+patch_size-1, j:j+patch_size-1, :) = patch;
    end
end
end

img = imread(file_names{2});
imshow(img);
patched_img = patch_shuffle_img(img, 10);
imshow(patched_img);
