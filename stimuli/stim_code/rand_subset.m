% function that returns a random subset of a given size from a given stimulus set

stim_path = '../natobjectscolor/';
subset = get_rand_subset(stim_path, 25, true);


function subset = get_rand_subset(stim_path, subset_size, save_subset)
% get all the file names in the directory
files = dir(stim_path);
files = {files(3:end).name};
disp(['Found ' num2str(length(files)) ' files']);
% get the subset
subset = files(randperm(length(files), subset_size));

if save_subset
    % copy subset to a new directory
    subset_path = '../subset/';
    if exist(subset_path, 'dir')
        rmdir(subset_path, 's');
    end
    mkdir(subset_path);
    for i = 1:length(subset)
        copyfile([stim_path subset{i}], [subset_path subset{i}]);
        disp(['Copied ' subset{i}]);
    end
end

end