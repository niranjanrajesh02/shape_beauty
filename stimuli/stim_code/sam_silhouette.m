function masks = sam_silhouette(img_paths, save_folder)
%   Function that takes an image and outputs a mask using the Segment Anything Model (SAM)
%
%   Required Toolboxes: Deep Learning, Computer Vision, Image
%   Processing for Segment Anything Model

%   Required Inputs:
%           img_paths = cell array of img paths to silhouette
%   Optional Inputs:
%           save_folder = Path to write silhouette image to
%           (default behaviour - does not save anything)

%   Example usage: mask = sam_silhouette(img_path, 4, 1, save_folder);


if ~exist("save_folder", "var"), save_folder = "no"; end


disp("Loading SAM ...");
sam_model = segmentAnythingModel;
start_ind = input("Start index: ");

disp("Getting Embeddings ...");
for i=start_ind:length(img_paths)
    img_path = img_paths{i};
    img = imread(img_path);
    image_embeds = extractEmbeddings(sam_model, img);
    
    % Image masking loop (REQUIRES USER INPUT)
    while true
        
        close all;

        imshow(img);
        points_resp = input("Input number of points? [y/n] ", "s");
        if strcmpi(points_resp, "y")
            n_foreground = input("Enter number of foreground points: ");
            n_background = input("Enter number of background points: ");
        else 
            n_foreground = 1;
            n_background = 0;
        end

        fg_pts = readPoints(img, n_foreground, "foreground");
        bg_pts = [];
        if n_background > 0
            bg_pts = readPoints(img, n_background, "background");
            close all;
        end
        
        disp("Generating Masks ...")
        masks = segmentObjectsFromEmbeddings(sam_model, image_embeds, size(img), ForegroundPoints=fg_pts', BackgroundPoints=bg_pts');
        im_mask = img.*uint8(masks);        
        
        figure
        tiledlayout(1,2)

        nexttile
        imshow(masks)
        title("Silhouette")

        nexttile
        imshow(im_mask)
        title("Isolated")

        
        redo_resp = input("Redo mask? [y/n]", "s");
        
        if strcmpi(redo_resp, "n")
            close all;
            break;
        end
        
        
        
        close all;
        
        
    end
    
    
    if ~strcmp(save_folder, "no")
        save_name = strsplit(img_path, '/');
        save_name = save_name{end};
        sil_save_path = [save_folder '/sil/' 'sil_' save_name ];
        iso_save_path = [save_folder '/iso/' 'iso_' save_name ];
        disp("Saving ...");
        imwrite(masks, sil_save_path);
        imwrite(im_mask, iso_save_path)
    end

    disp(strcat("Image ", num2str(i), "done"));
    
    end_resp = input("Would you like to continue? [y/n]", "s");

    if strcmpi(end_resp, "n")
        disp(strcat("Stopped at image ", num2str(i)));
        break;
    end

end
end


function pts = readPoints(image, n, point_type)
if nargin < 2
    n = Inf;
    pts = zeros(2, 0);
else
    pts = zeros(2, n);
end

imshow(image);     % display image
title(point_type)
xold = 0;
yold = 0;
k = 0;
hold on;           % and keep it there while we plot

while 1
    [xi, yi, but] = ginput(1);      % get a point
    if ~isequal(but, 1)             % stop if not button 1
        break
    end
    k = k + 1;
    pts(1,k) = xi;
    pts(2,k) = yi;
    
    if strcmp(point_type, "foreground")
        marker = 'go';
    elseif strcmp(point_type, "background")
        marker = 'ro';
    end
    
    if xold
        plot([xold xi], [yold yi], marker);  % draw as we go
    else
        plot(xi, yi, marker);         % first point on its own
    end
    
    if isequal(k, n)
        break
    end
    xold = xi;
    yold = yi;
end


hold off;
if k < size(pts,2)
    pts = pts(:, 1:k);
end
close all;
end