img_path = "D:\Niranjan_Work\aesthetics\shape_beauty\stimuli\stim_sets\segmentation_set\sil\Image047_bee_20s.png";
I = imread(img_path);
sf = 3; %upscaling factor
sz = size(I);
xg = 1:sz(1);
yg = 1:sz(2);
F = griddedInterpolant({xg,yg},double(I));
F.Method = 'cubic';
xq = (1:(1/sf)*(0.53):sz(1))'; %scale to upscaling factor*1px/nm
yq = (1:(1/sf)*(0.53):sz(2))';
I_re = im2bw(uint8(F({xq,yq})),0.5);
I_c = I_re;%To control area changes smoothing
%Below follows an iterative filtering algorithm for this application. The
%edges are continuously blurred and rethreshholded. If particles are
%deleted or merged the code will fail executing.
sz = size(I_re);
L1 = bwlabel(I_re);
N = max(L1,[],'all');
windowSize = 19;% Here some filtering, slight blurring then rethreshold to get rid of edges
for k = 1:10 %k iterations
    L1 = bwlabel(I_re);
    I_b= zeros(sz);
    %The following retrieves each feature and saves it in temp array
    for i = 1:N
        I_temp = zeros(sz);
        I_b1 = I_temp;
        for j = 1:sz(1)
            for jj = 1:sz(2)
                if L1(j,jj) == i
                    I_temp(j,jj) = I_re(j,jj);
                end
            end
        end
        %The following corrects windowsize for small particles
        if sum(I_temp(:) >0 ) < 1*(windowSize^2)*pi*sf^2 
            window = round(windowSize/3);
           % disp('window resized')
        else
            window = windowSize;
        end
        kernel = ones(window)/window^2;
        I_b1 = conv2(I_temp, kernel, 'same'); %Filtering by 2dconvolution
        %The following prevents merging of particles or to the edge by adding a zero
        for j = 1:sz(1)
            for jj = 1:sz(2)
                if I_b(j,jj)==0 && I_b1(j,jj) > 0
                    I_b(j,jj) = I_b1(j,jj);
                elseif I_b(j,jj)~=0 && I_b1(j,jj) ~= 0
                    I_b(j,jj) = 0; 
                elseif j == sz(1) || jj == sz(2)
                    I_b(j,jj) = 0; 
                end
            end
        end
    end
    I_re = I_b > 0.5;
end
I_2 = I_re;
%Remove pixels sticking out
I_2 = ~I_2;
I_2 = bwmorph(I_2,'majority');
I_2 = ~I_2;
I_2 = bwmorph(I_2,'majority');


% resize to 234x234
% I_2 = imresize(I_2, [234 234]);

imshow(img);
axis image;
imshow(I_2);
axis image;
