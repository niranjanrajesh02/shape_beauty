import os
import numpy as np
import torch
import matplotlib.pyplot as plt
from PIL import Image
from dotenv import load_dotenv
from sam2_utils import *
import matplotlib.image

load_dotenv()

# select the device for computation
if torch.cuda.is_available():
    device = torch.device("cuda")
else:
    device = torch.device("cpu")
print(f"using device: {device}")


img_dir = os.getenv("IMG_DIR")
save_dir = os.getenv("SAVE_DIR")

image_paths = [f'{img_dir}/{f}' for f in os.listdir(img_dir) if f.endswith('.png')]

# load model
def get_sam_predictor():
    current_wd = os.getcwd()
    os.chdir(os.getenv("MODEL_DIR"))
    from sam2.build_sam import build_sam2
    from sam2.sam2_image_predictor import SAM2ImagePredictor 
    sam2_checkpoint = "./checkpoints/sam2_hiera_large.pt"
    model_cfg = "sam2_hiera_l.yaml"
    sam2_model = build_sam2(model_cfg, sam2_checkpoint, device=device)
    predictor = SAM2ImagePredictor(sam2_model)
    os.chdir(current_wd)
    return predictor


def silhouette_loop(img_paths, predictor):
    for img_path in img_paths:
        while True:
            img = Image.open(img_path)
            image = np.array(img.convert("RGB"))
            fg_points = get_img_points(img_path, type="foreground")
            bg_points = get_img_points(img_path, type="background")

            input_points = np.concatenate([fg_points, bg_points], axis=0)
            labels = [1] * len(fg_points) + [0] * len(bg_points)
            input_labels = np.array(labels)

            predictor.set_image(image)
            masks, scores, logits = predictor.predict(
            point_coords=input_points,
            point_labels=input_labels,
            multimask_output=True,
            )

            sorted_ind = np.argsort(scores)[::-1]
            masks = masks[sorted_ind]
            scores = scores[sorted_ind]
            logits = logits[sorted_ind]

            # PLOTTING SILs and ISOs
            fig, ax = plt.subplots(2, 3, figsize=(15, 10))
            for mask_i in range(3):
                mask = masks[mask_i]
                score = scores[mask_i]
                plt.subplot(2, 3, mask_i + 1)
                plt.imshow(mask, cmap='gray')
                plt.axis('off')
                plt.title(f"Mask {mask_i+1}, Score: {score:.3f}")


                plt.subplot(2, 3, mask_i + 4)
                isolated_image = np.zeros_like(image)
                for i in range(3):
                    isolated_image[:, :, i] = image[:, :, i] * mask

                plt.imshow(isolated_image)
                plt.axis('off')
                plt.title(f"Isolated Image {mask_i+1}")
            plt.show()
            


            # SAVING
            save_resp = input("Like the masks? (y/n): ")
            if save_resp == 'y':
                mask_i = int(input("Which mask to save? (1, 2, 3): "))
                mask = masks[mask_i - 1]
                # save mask and isolated image
                plt.imsave(f"{save_dir}/sil/{os.path.basename(img_path)}", mask, cmap='gray')
                mask_image = np.zeros_like(image)
                for i in range(3):
                    mask_image[:, :, i] = image[:, :, i] * mask

                plt.imsave(f"{save_dir}/iso/{os.path.basename(img_path)}", mask_image)

                print(f"Mask and isolated image saved for {os.path.basename(img_path)}.")
                continue_resp = input("Continue? (y/n): ")
                if continue_resp == 'y':
                    break
                else:
                    return
                
            else:
                continue




        
    return

if __name__ == "__main__":
    predictor = get_sam_predictor()
    silhouette_loop(image_paths, predictor)