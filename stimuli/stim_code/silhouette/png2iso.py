from PIL import Image
import os


source_dir = "../stim_sets/seg2_set/2.1_tricky/iso"
dest_dir = "../stim_sets/seg2_set/2.1_tricky/iso_black"

source_imgs = os.listdir(source_dir)

for img_n in source_imgs:
    img_path = os.path.join(source_dir, img_n)
    img = Image.open(img_path).convert("RGBA")
    black_bg = Image.new("RGBA", img.size, (0, 0, 0, 255))
    black_bg.paste(img, (0, 0), img)
    rgb_img = black_bg.convert("RGB")
    rgb_img.save(os.path.join(dest_dir, img_n))
    print(f"Saved {img_n} with black background")
