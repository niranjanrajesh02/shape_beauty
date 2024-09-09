import numpy as np
import matplotlib.pyplot as plt
import cv2
np.random.seed(3)

def show_mask(mask, ax, random_color=False, borders = True):
    if random_color:
        color = np.concatenate([np.random.random(3), np.array([0.6])], axis=0)
    else:
        color = np.array([30/255, 144/255, 255/255, 0.6])
    h, w = mask.shape[-2:]
    mask = mask.astype(np.uint8)
    mask_image =  mask.reshape(h, w, 1) * color.reshape(1, 1, -1)
    if borders:
        import cv2
        contours, _ = cv2.findContours(mask,cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE) 
        # Try to smooth contours
        contours = [cv2.approxPolyDP(contour, epsilon=0.01, closed=True) for contour in contours]
        mask_image = cv2.drawContours(mask_image, contours, -1, (1, 1, 1, 0.5), thickness=2) 
    ax.imshow(mask_image)

def show_points(coords, labels, ax, marker_size=375):
    pos_points = coords[labels==1]
    neg_points = coords[labels==0]
    ax.scatter(pos_points[:, 0], pos_points[:, 1], color='green', marker='*', s=marker_size, edgecolor='white', linewidth=1.25)
    ax.scatter(neg_points[:, 0], neg_points[:, 1], color='red', marker='*', s=marker_size, edgecolor='white', linewidth=1.25)   

def show_masks(image, masks, scores, point_coords=None, box_coords=None, input_labels=None, borders=True):
    for i, (mask, score) in enumerate(zip(masks, scores)):
        plt.figure(figsize=(10, 10))
        plt.imshow(image)
        show_mask(mask, plt.gca(), borders=borders)
        if point_coords is not None:
            assert input_labels is not None
            show_points(point_coords, input_labels, plt.gca())
        
        if len(scores) > 1:
            plt.title(f"Mask {i+1}, Score: {score:.3f}", fontsize=18)
        plt.axis('off')
        plt.show()


#

def click_event(event, x, y, flags, params={'coords':None, 'img':None, 'win_name':None}): 
	coords = params['coords']
	img = params['img']
	win_name = params['win_name']
	# checking for left mouse clicks 
	if event == cv2.EVENT_LBUTTONDOWN: 
		# displaying the coordinates 
		# on the Shell 
		# print(x, ' ', y) 
		coords.append([x, y])
		plot_x = x - 12
		plot_y = y + 8

		color = (0,255,0) if win_name=="IMG_FOREGROUND" else (0,0,255)
		# displaying the coordinates as a cross
		font = cv2.FONT_HERSHEY_SIMPLEX
		cv2.putText(img, '+', (plot_x,plot_y), font, 1, color, 2)
		cv2.imshow(win_name, img) 
        

	


def get_img_points(img_path, type=None):
    img = cv2.imread(img_path, 1) 
    
    coords = []
    win_name = 'IMG_FOREGROUND' if type=="foreground" else 'IMG_BACKGROUND'
	
    cv2.imshow(win_name, img)

	# setting mouse handler for the image 
	# and calling the click_event() function
    params = {'coords': coords, 'img': img, 'win_name': win_name}
    cv2.setMouseCallback(win_name, click_event, param=params) 


    # wait for a key to be pressed to exit 
    cv2.waitKey(0) 
    # print(coords)
    # close the window 
    cv2.destroyAllWindows() 
    return coords

