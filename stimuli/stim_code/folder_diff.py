import os
import shutil

source_dir = "../stim_sets/selected_set"
dest_dir = "../stim_sets/segmentation_set/sil"
save_dir = "../stim_sets/seg2_set/2.1_tricky/nat"
source_files = os.listdir(source_dir)
dest_files = os.listdir(dest_dir)

for file in source_files:
    if file not in dest_files:
        print(file)
        img_path = os.path.join(source_dir, file)
        # copy the image to save directory
        shutil.copy(img_path, save_dir)
