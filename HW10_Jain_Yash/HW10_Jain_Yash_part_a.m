% Author:- Prof. Thomas Kinsman
% Modified by:- Yash Jain
% I understood the the working of code and wrote the comments as per my
% understanding. Also modified it a little bit as per my understanding.

function HW10_Jain_Yash_part_a( fn )
    % Read input image
    im_rgb = imread( fn );
    
    figure('Position',[10 10 1024 768]);
    imshow( im_rgb );
    title('Original Image','Fontsize',15);
    
    % Funtion to select the foreground and background manually
    [x_foreground, y_foreground, x_background, y_background] = select_foreground_background();
    
    % Converting to lab and extracting a* and b* channles from lab colorspace
    im_lab      = rgb2lab( im_rgb );  
    im_a        = im_lab(:,:,2);
    im_b        = im_lab(:,:,3);
    
    % out = sub2ind(matrix_size,rowSub,colSub)
    % sub2ind returns the linear index equivalent to row subscript(rowSub)
    % and colsubscript(colSub)
    % Using this we are extracting forground and background indices
    foreground_indices  = sub2ind( size(im_a), round(y_foreground), round(x_foreground) );
    background_indices  = sub2ind( size(im_a), round(y_background), round(x_background) );
  
    % Recollecting the pixels corresponding to background and forground
    % indices from a and b channel.
    foreground_a        = im_a( foreground_indices );
    foreground_b        = im_b( foreground_indices );
    background_a        = im_a( background_indices );
    background_b        = im_b( background_indices );
    
    % Plotting all the background and foreground pixels selected.
    % 
    figure('Position',[100 10 1024 768]);
    plot( foreground_a, foreground_b, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 16 );
    hold on;
    plot( background_a, background_b, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 16  );
    xlabel( 'a* ', 'FontSize', 24, 'FontWeight', 'bold' );
    ylabel( 'b* ', 'FontSize', 24, 'FontWeight', 'bold' );
    
    % Creating attributes of background ,foreground and entire image
    foreground_ab       = [ foreground_a, foreground_b ];              
    background_ab       = [ background_a, background_b ];             
    im_ab               = [ im_a(:) im_b(:) ];                         
   
    % Compute mahalanobis distance of each pixel in image from the
    % foreground selected.
    mahal_foreground    = mahal( im_ab, foreground_ab );
    
    % Compute mahalanobis distance of each pixel in image from the
    % background selected.
    mahal_background    = mahal( im_ab, background_ab );
   
    %  Classify a Class using the condition if distance to FG is < distance to BG
    b_is_target_object_class      = (mahal_foreground.^(1/2)) < (mahal_background.^(1/2));
    
    %  Prepare a model of the foreground Mahalanobis distance
    %  NOTE:  We must take the Square Root
    foreground_dists        = mahal_foreground.^(1/2);                 
    fg_dists_class0   = foreground_dists(b_is_target_object_class);
    dist_mean       = mean( fg_dists_class0 );
    dist_std_01     = std(  fg_dists_class0 );
    
    % Toss everything outside of one std, and re-adjust the mean value:
    b_inliers       = ( fg_dists_class0 <= (dist_mean + dist_std_01) ) & ( fg_dists_class0 >= (dist_mean - dist_std_01));
    the_inliers     = fg_dists_class0( b_inliers );
    dist_mean       = mean( the_inliers );
    
    %  Use a distance to target variable as rules for inclusion
    threshold           = dist_mean;
    guess_class0          = foreground_dists <= threshold;
    out_image           = reshape( guess_class0, size(im_a,1), size(im_a,2) );
    figure;
    imagesc( out_image );
    title('Foreground Classification Image ', 'FontSize', 15 );
    
    final_output =  im2uint8(out_image);
    imwrite(final_output,'HW10_Jain_Yash_part_a_output.jpg');
end


%% Select background and foreground points manually
function [x_foreground, y_foreground, x_background, y_background] = select_foreground_background()
    fprintf('SELECT FOREGROUND OBJECT:\n');
    fprintf('Click on points to capture positions:  Hit return to end...\n');
    [x_foreground, y_foreground] = ginput();

    fprintf('SELECT BACKGROUND OBJECT:\n');
    fprintf('Click on points to capture positions:  Hit return to end...\n');
    [x_background, y_background] = ginput();
end