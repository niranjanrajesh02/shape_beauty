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