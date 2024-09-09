img_paths = [
    "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\iso\Image046_bee_19s.png",
    "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\iso\Image158_extinguisher_12s.png",
    "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\iso\Image376_starfish_15n_thingsmeg.png"
];
close all;

save_dir = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_code";

for img_i=1:3
    img_path = img_paths(img_i);
    img = imread(img_path);


    scramble_strengths = [0,  0.2,  0.4, 0.6,  0.8,  1.0];


    figure;
    % make figure larger
    set(gcf, 'Position', get(0, 'Screensize'));
    
    for i = 1:length(scramble_strengths)
        subplot(2,length(scramble_strengths),i), imshow(img), title('Original');
        subplot(2,length(scramble_strengths),i+length(scramble_strengths)), imhist(img), title('Original');
    end

    for i = 1:length(scramble_strengths)
        hebart_scramble = imscramble(img,scramble_strengths(i));
        subplot(2,length(scramble_strengths),i), imshow(hebart_scramble), title(['Phase-scrambled  ', num2str(scramble_strengths(i))]);
        subplot(2,length(scramble_strengths),i+length(scramble_strengths)), imhist(hebart_scramble), title(['Phase-scrambled  ', num2str(scramble_strengths(i))]);
        ylim([0 10000])
    end

    [~, img_name, ~] = fileparts(img_path);
    img_save_path = strcat(img_name, '_scrambles.png');
    % save fig as png without tight layout
    saveas(gcf, fullfile(save_dir, img_save_path), 'png');
end
