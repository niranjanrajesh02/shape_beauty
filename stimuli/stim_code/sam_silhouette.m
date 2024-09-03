function masks = sam_silhouette(img_paths, n_foreground, n_background, save_folder)
%   Function that takes an image and outputs a mask using the Segment
%   Anything Model (SAM)

%   Required Toolboxes: Deep Learning, Computer Vision, Image
%   Processing for Segment Anything Model

%   Required Inputs:
%           img_paths = cell array of img paths to silhouette
%   Optional Inputs:
%           n_foreground = Number of foreground points to feed SAM
%           (default = 1)
%           n_background = Number of background points to feed SAM
%           (default = 0)
%           save_folder = Path to write silhouette image to
%           (default behaviour - does not save anything)

%   Example usage: mask = sam_silhouette(img_path, 4, 1, save_folder);


if ~exist("save_folder", "var"), save_folder = "no"; end
if ~exist("n_foreground", "var"),  n_foreground = 1; end
if ~exist("n_background", "var"), n_background = 0; end

disp("Loading SAM ...");
sam_model = segmentAnythingModel;

disp("Getting Embeddings ...");
for i=1:length(img_paths)
    img_path = img_paths{i};
    img = imread(img_path);
    image_embeds = extractEmbeddings(sam_model, img);
    
    % Image masking loop (REQUIRES USER INPUT)
    while true
        fg_pts = readPoints(img, n_foreground, "foreground");
        close all;
        
        bg_pts = [];
        if n_background > 0
            bg_pts = readPoints(img, n_background, "background");
            close all;
        end
        
        disp("Generating Masks ...")
        masks = segmentObjectsFromEmbeddings(sam_model, image_embeds, size(img), ForegroundPoints=fg_pts', BackgroundPoints=bg_pts');
        imshow(masks)
        
        redo_resp = input("Redo mask? [y/n]", "s");
        
        if strcmpi(redo_resp, "n")
            close all;
            break;
        end
        
        points_resp = input("Change number of points? [y/n] ", "s");
        
        if strcmpi(points_resp, "y")
            n_foreground = input("Enter number of foreground points: ");
            n_background = input("Enter number of background points: ");
        end
        close all;
        
        
    end
    
    points_resp = input("Change number of points? [y/n] ", "s");
    
    if strcmpi(points_resp, "y")
        n_foreground = input("Enter number of foreground points: ");
        n_background = input("Enter number of background points: ");
    end
    
    if ~strcmp(save_folder, "no")
        save_name = strsplit(img_path, '/');
        save_name = save_name{end};
        save_path = [save_folder 'sil_' save_name];
        disp(["Saving to ", save_path]);
        imwrite(masks, save_path)
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