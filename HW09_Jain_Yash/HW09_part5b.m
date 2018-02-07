function HW09_part5b(filename)
    % Reading the input image 
    im = imread(filename);
    
    %% Noise removal
        
    % Applying disk filter to the given image(local average)
    disk_filter = fspecial('disk',2);
    im_filtered_avg = imfilter(im,disk_filter);
   
    % Applying gaussian filter to the image to get more smoothened output
    gauss_filter = fspecial('gauss',5,1);
    im = imfilter(im_filtered_avg,gauss_filter);
        
    % Getting dimension of the input image
    dims = size( im );
    
     % Displaying the original image
     figure;
     imagesc(im);
     k = 128;
    
     % Taking the LAB color space of given input image
     im          = rgb2lab(im);
    
     % Gathering the x and y corrdinates to pass
     [xs, ys]    = meshgrid( 1:dims(2), 1:dims(1) );
    
     first       = im(:,:,1);
     second      = im(:,:,2);
     third       = im(:,:,3);
    
     % Adjusting attributes
     xs1     = xs / 5 ; % balanceTheRange(xs);
     ys1     = ys / 5; % balanceTheRange(ys);
     first1   = first; % balanceTheRange(first);
     second1  = second; % balanceTheRange(second);
     third1   = third; % balanceTheRange(third);
    
     % Creating single attribute by combining l, a, b, x and y
     attributes  = [  double(first1(:)), double(second1(:)) ...
                   ,double(third1(:)),xs1(:), ys1(:)];
        
     %% Euclidean distance        
     % Applying k-means
     [cluster_id, centroids] = kmeans( attributes, k, 'MaxIter', 1 );
     % Creating image from the clustered output
     im_new      = reshape( cluster_id, dims(1), dims(2) );

     lab_colormap = centroids( :, 1:3 );
     rgb_colormap = lab2rgb( lab_colormap );
      
     figure;
     imagesc( im_new );
     message = ['K = ', num2str(k),' Distance = Euclidean Distance'];
     title(message,'Fontsize',15);
     colorbar;
     colormap( rgb_colormap );
        
     %% Cityblock distance
     % Creating single attribute by combining l, a, b, x and y
     attributes  = [  double(first1(:)), double(second1(:)) ...
                    ,double(third1(:)),xs1(:), ys1(:)];
    
     % Applying k-means
     [cluster_id, centroids] = kmeans( attributes, k, 'MaxIter', 1 );
     % Creating image from the clustered output
     im_new      = reshape( cluster_id, dims(1), dims(2) );

     lab_colormap = centroids( :, 1:3 );
     rgb_colormap = lab2rgb( lab_colormap );
    
     figure;
     imagesc( im_new );
     message = ['K = ', num2str(k),' Distance = Cityblock  Distance'];
     title(message,'Fontsize',15);
     colorbar;
     colormap( rgb_colormap );
end