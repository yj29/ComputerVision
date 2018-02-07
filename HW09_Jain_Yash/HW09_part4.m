function HW09_part4(filename)
    im = imread(filename);
    figure;
    %subplot(2,3,1);
    imagesc(im);
    title('Orginal Image','Fontsize',8);
    
    % Converting rgc to various color spaces asked in question
    im_rgb      = im;
    im_hsv      = rgb2hsv(im);
    im_xyz      = rgb2xyz(im);
    im_ycbcr    = rgb2ycbcr(im);
    im_lab      = rgb2lab(im);
    
    im_array    = cell(5,1);
    im_array{1} = im_rgb;
    im_array{2} = im_hsv;
    im_array{3} = im_xyz;
    im_array{4} = im_ycbcr;
    im_array{5} = im_lab;
   
    name_of_colorspace = {'RGB','HSV','XYZ','YCBCR','LAB'};
    
    for index = 1: length(im_array) 
        k_values = 64;
        % passing in the filtered image with proper k value to rgb2ind function
        im_temp = im_array{index};
        [im_out,x] = rgb2ind(im_temp,k_values,'nodither');
    
        % Displaying th eoutput of rgb2ind 
        figure;
        imagesc(im_out);
        colormap(x);
        message = ['HW09->4, ColorSpace =' ,name_of_colorspace(index) ,'K value is',num2str(k_values)];
        title(message,'Fontsize',8);
    end

    
    % Looking at all the colorspaces I found that ycbcr is good for balls,
    % RGB is good for MACBETH and XYZ for pockets
    if(~isempty(strfind(filename,'BALLS')))
        disk_size = 7;
        gauss_size =4;
        gauss_sd = 0.25;
        
        im_ycbcr = rgb2ycbcr(im);
    
        im_y = im_ycbcr(:,:,1)/30;
        im_cb = im_ycbcr(:,:,2);
        im_cr = im_ycbcr(:,:,3);
        im_to_process = cat(3,im_y,im_cb,im_cr);
        
        %% Noise removal
        % Applying disk filter to the given image(local average)
        disk_filter = fspecial('disk',disk_size);
        im_filtered_avg = imfilter(im_to_process,disk_filter);
   
        % Applying gaussian filter to the image to get more smoothened output
        gauss_filter = fspecial('gauss',gauss_size,gauss_sd);
        im_filtered = imfilter(im_filtered_avg,gauss_filter);
    end
    if (~isempty(strfind(filename,'MACBETH')))
        disk_size = 7;
        gauss_size =4;
        gauss_sd = 0.25;
        
        im_rgb = im;
    
        im_r = im_rgb(:,:,1);
        im_g = im_rgb(:,:,2);
        im_b = im_rgb(:,:,3);
        im_to_process = cat(3,im_r,im_g,im_b);
        
        %% Noise removal
        %Applying disk filter to the given image(local average)
        disk_filter = fspecial('disk',disk_size);
        im_filtered_avg = imfilter(im_to_process,disk_filter);
   
        % Applying gaussian filter to the image to get more smoothened output
        gauss_filter = fspecial('gauss',gauss_size,gauss_sd);
        im_filtered = imfilter(im_filtered_avg,gauss_filter);
    end
   if(~isempty(strfind(filename,'POCKET')))
        disk_size   = 10;
        gauss_size  = 8;
        gauss_sd    = 3;
        
        im_hsv = rgb2hsv(im);
    
        im_x = im_hsv(:,:,1)*1;
        im_y = im_hsv(:,:,2)*5;
        im_z = im_hsv(:,:,3)*5;
        im_to_process = cat(3,im_x,im_y,im_z);
        
        %% Noise removal
        % Applying disk filter to the given image(local average)
        disk_filter = fspecial('disk',disk_size);
        im_filtered_avg = imfilter(im_to_process,disk_filter);
   
        % Applying gaussian filter to the image to get more smoothened output
        gauss_filter = fspecial('gauss',gauss_size,gauss_sd);
        im_filtered = imfilter(im_filtered_avg,gauss_filter);
    end
    
    
    
    %% Applying kmeans
    % k value is 64
    k_values = 64;
    
    % passing in the filtered image with proper k value to rgb2ind function
    [im_out,x] = rgb2ind(im_filtered,k_values,'nodither');
    
    % Displaying th eoutput of rgb2ind
    figure;
    imagesc(im_out);
    colormap(x);
    message = ['HW09->4,Best color cahnnel, K value is ',num2str(k_values)];
    title(message,'Fontsize',8);
end