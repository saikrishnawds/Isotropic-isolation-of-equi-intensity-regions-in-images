close all
clear
img = imread("smileys.jpg");
img = rgb2gray(img);
figure
imshow(img)
h = fspecial('laplacian');
layer = 1;
sig = [];
imgl = [];
for sigma = 1:4:21
    k = floor(4*sigma+0.5);
    %g = fspecial('gaussian',k,sigma);
    l = (sigma^2*fspecial('log',k,sigma));
    %imgg = my_conv(img,g,4);
    temp = (double(my_conv(img,l,4)));
    imgl(:,:,layer) = temp;
    layer = layer + 1;
    sig = [sig sigma];
%     figure(2)
%     imshow(imgl,[]);
    %imgs = nms(imgl,img,sigma);
    %imshow(imgs)
    figure()
    imshow(imgl(:,:,layer-1),[]);
end
%%
close all
imshow(img)
nms(imgl,sig)
function img = nms(imgs,s)
    [row col lay] = size(imgs);
    count = 0;
    mm = max(max(imgs));
    %imgnms = zeros(row,col);
    for k = 2:length(s)
        for j = 2:col-1
            for i = 2:row-1
                if k == 1
                    temp = imgs(i-1:i+1,j-1:j+1,k:k+1);
                elseif k < length(s)
                    temp = imgs(i-1:i+1,j-1:j+1,k-1:k+1);
                else
                    temp = imgs(i-1:i+1,j-1:j+1,k-1:k);
                end
                [m rows] = max(temp);
                [m cols] = max(m);
                [m layer] = max(m);
                cols = cols(1,1,layer);
                rows = rows(1,cols,layer);
                if m > (0.3*mm(layer))
                    if rows == 2 && cols == 2
                        if ((k == 1 && layer == 1) || (k > 1 && layer == 2))
                        count = count + 1;
                        figure(1)
                        hold on
                        viscircles([j,i],s(k)*sqrt(2),'Color','r','LineWidth',0.2);
                        %img(i,j) = 255;
                        end
                    end
                end
            end
        end
    count
    end
end
%%
function s = p_wise_mult(ker,img)
    [row,col,ch] = size(img);
    s = zeros(1,ch);
    for k = 1:ch
        s(k) = sum(sum(ker.*img(:,:,k)));
    end
end
function img_conv = my_conv(img,ker,pad)
    [row_i, col_i, ch_i] = size(img);
    [row_k, col_k, ch_k] = size(ker);
    ker = flipud(fliplr(ker));
    r_s = row_k-1;
    c_s = col_k-1;
    r_ss = floor(0.5*(row_k-1));
    c_ss = floor(0.5*(col_k-1));
    r_se = floor(0.5*row_k);
    c_se = floor(0.5*col_k);
    
    img_pad = zeros(row_i + 2*r_s,col_i + 2*c_s,ch_i);
    [row_p, col_p, ch_p] = size(img_pad);
    img_pad(r_s + 1:row_p - r_s,c_s + 1:col_p - c_s,:) = img;
    
    if pad == 1
        img_final = img_pad;
    end
    if pad == 2
        for i = 1:r_s
            img_pad(i,:,:) = img_pad(r_s + 1,:,:);
            img_pad(row_p - r_s + i,:,:) = img_pad(row_p - r_s,:,:);
        end
        for i = 1:c_s
            img_pad(:,i,:) = img_pad(:,c_s + 1,:);
            img_pad(:,col_p - c_s + i,:) = img_pad(:,col_p - c_s,:);
        end
        img_final = img_pad;
    end
    if pad == 3
        for i = 1:r_s
            img_pad(i,:,:) = img_pad(2*r_s - i + 1,:,:);
            img_pad(row_p - r_s + i,:,:) = img_pad(row_p - r_s - i + 1,:,:);
        end
        for i = 1:c_s
            img_pad(:,i,:) = img_pad(:,2*c_s - i + 1,:);
            img_pad(:,col_p - c_s + i,:) = img_pad(:,col_p - c_s - i + 1,:);
        end
        img_final = img_pad;
    end
    if pad == 4
        for i = 1:r_s
            img_pad(i,:,:) = img_pad(row_p - 2*r_s + i,:,:);
            img_pad(row_p - r_s + i,:,:) = img_pad(r_s + i,:,:);
        end
        for i = 1:c_s
            img_pad(:,i,:) = img_pad(:,col_p - 2*c_s + i,:);
            img_pad(:,col_p - c_s + i,:) = img_pad(:,c_s + i,:);
        end
        img_final = img_pad;
    end
    
    img_new = zeros(row_p,col_p,ch_p);
    for i =  r_ss + 1: row_p - r_se
        for j = c_ss + 1 : col_p - c_se
            for k = 1:ch_p
                seg = img_final(i - r_ss : i + r_se, j - c_ss : j + c_se, k);
                img_new(i,j,k) = p_wise_mult(seg,ker);
            end
        end
    end
    img_conv = (img_new(r_s + 1: row_p - r_s,c_s + 1 : col_p - c_s,:));
end

