from PIL import Image
import os

iso_dir = "../stim_sets/seg2_set/2.1_tricky/iso_black"

dest_dir = "../stim_sets/seg2_set/2.1_tricky/sil"

iso_imgs = os.listdir(iso_dir)


# create copies of isolated images and then silhouette them. if the copy image's pixel is not black, turn it white. these are rgb images.

for img_n in iso_imgs:
    img_path = os.path.join(iso_dir, img_n)
    img = Image.open(img_path)
    new_img = img.copy()
    
    # silhouette the image
    for x in range(img.width):
        for y in range(img.height):
            r, g, b = img.getpixel((x, y))
            if (r,g,b) != (0,0,0):
                new_img.putpixel((x, y), (255, 255, 255))

    new_img.save(os.path.join(dest_dir, img_n))

    