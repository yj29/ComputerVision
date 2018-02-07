% Author:- Prof. Thomas Kinsman
% Modified by:- Yash Jain
% I understood the the working of code and wrote the comments as per my
% understanding. Also modified it a little bit as per my understanding.
%
% I understood and used the the superpostion example professor took in the class

function HW10_Jain_Yash_part_b(fn)
    im = imread( fn );
    figure;
    imagesc(im);
    title('Original Image','Fontsize',15);
   
    % Convert image to LAB space
    % I tried with RGB and HSV channels as well, but LAB works out to be
    % the best.
    % More specifically b* color channel is the best. 
    im_lab = rgb2lab(im);
    im_l = im_lab(:,:,1);
    im_a = im_lab(:,:,2);
    temp = rgb2hsv(im);
    im_b = im_lab(:,:,3);
   
    % Applied gaussian filter to the input image to smoothen it 
    image_to_work = remove_noise(im_b);
    
    % Manually selecting grass path with these coordinates
   row_and_column_vector = 20:70;
    
    %  Get the grass patch in the image, from a pre-determined location:
    %  Subtract the mean value, to turn this into an edge detector.  
    %  That way correlation can be detected.
    grass_patch        = image_to_work( row_and_column_vector, row_and_column_vector );
    m            = mean( grass_patch(:) );                      
    filter       = grass_patch - m;
    
     %  Creating a local average filter
     %  the size of local avaerge filter is same as the grass pathc filter
     %  created in previous step
    local_avg_filter        = ones( size(grass_patch) ) / numel(grass_patch);
    
    % Taking the filter response for both avergae and the filter
    % created above(from grass patch)
    local_avg_filter_resp          = imfilter( image_to_work, local_avg_filter, 'same', 'repl' );
    img_wo_local_mean       = im_b - local_avg_filter_resp;
    computed_local_corr     = imfilter( img_wo_local_mean, filter, 'same', 'repl' );
    
    figure;
    imagesc(local_avg_filter_resp);
    title('Local average filter response','Fontsize',15);
    
    figure;
    imagesc(computed_local_corr);
    colormap(gray);
    title('Correlation output','Fontsize',15);
    
    % Computing the foreground and background 
    % Bacground is the texture of the patch selected (grass)
    % Remainign part is foreground
    foreground = image_to_work - computed_local_corr;
    background = computed_local_corr;
    
     % Compute mahalanobis distance of each pixel in image from the
    % foreground selected.
    mahal_fg    = mahal( image_to_work(:), foreground(:) );
    
     % Compute mahalanobis distance of each pixel in image from the
    % background selected.
    mahal_bg    = mahal( image_to_work(:), background(:) );
    
     %  Classify a Class using the condition if distance to FG is > distance to BG
    b_is_target_object      = (mahal_fg.^(1/2)*1.6) > (mahal_bg.^(1/2));
    
    % Creating image from the above matrix
    target_map_image        = reshape( b_is_target_object, size(image_to_work,1), size(image_to_work,2) );
    
    figure;
    imagesc(target_map_image);
    title('Final Output','Fontsize',15);
    colormap(gray);
    
    
    final_output =  im2uint8(target_map_image);
    imwrite(final_output,'HW10_Jain_Yash_part_b_output.jpg');
    
    %% Below code it tried the same logic combining H and S of HSV
       % But it did not work as I expected
    %{
    %
    %  Form a model of the foreground Mahalanobis distance:
    %
    foreground_dists  = mahal_fg.^(1/2);                  % NOTICE the sqrt.
    fg_dists_class0   = foreground_dists(b_is_target_object);
    dist_mean         = mean( fg_dists_class0 );
    dist_std_01       = std(  fg_dists_class0 );
    
    % Toss everything outside of one std, and re-adjust the mean value:
    b_inliers       = ( fg_dists_class0 <= (dist_mean + dist_std_01) ) & ( fg_dists_class0 >= (dist_mean - dist_std_01));
    the_inliers     = fg_dists_class0( b_inliers );
    dist_mean       = mean( the_inliers );
    

    %
    %  Use a distance to target variable as rules for inclusion:
    %
    threshold           = dist_mean;
    guess_class0        = foreground_dists >= threshold;
    out_image           = reshape( guess_class0, size(image_to_work,1), size(image_to_work,2) );
    figure;
    imagesc( out_image );
    colormap(gray);
    title('Foreground Classification Image ', 'FontSize', 15 );
    %}
    
    
    %{
    im_l = im_lab(:,:,1);
    im_a = im_lab(:,:,2);
    %temp = rgb2hsv(im);
    im_b = temp(:,:,1);
    %im_h = im_b;
    
    
    image_to_work = remove_noise(im_b);
    
    % Manually selecting grass path with these coordinates
    cols = 20:70;
    rows = 20:70; 
    
    image        = image_to_work( cols, rows );
    m            = mean( image(:) );                      
    filter       = image - m;
    
    local_avg_filter        = ones( size(image) ) / numel(image);
    
    
    local_avg_resp          = imfilter( image_to_work, local_avg_filter, 'same', 'repl' );
    img_wo_local_mean       = im_b - local_avg_resp;
    computed_local_corr     = imfilter( img_wo_local_mean, filter, 'same', 'repl' );
    
    figure, imagesc(local_avg_resp);
    figure, imagesc(computed_local_corr);
    colormap(gray);
    
    foreground_S = image_to_work - computed_local_corr;
    background_S = computed_local_corr;
    
    %%
    im_b = temp(:,:,2);
    im_s = im_b;
    
    image_to_work = remove_noise(im_b);
    
    % Manually selecting grass path with these coordinates
    cols = 20:70;
    rows = 20:70; 
    
    image        = image_to_work( cols, rows );
    m            = mean( image(:) );                      
    filter       = image - m;
    
    local_avg_filter        = ones( size(image) ) / numel(image);
    
    
    local_avg_resp          = imfilter( image_to_work, local_avg_filter, 'same', 'repl' );
    img_wo_local_mean       = im_b - local_avg_resp;
    computed_local_corr     = imfilter( img_wo_local_mean, filter, 'same', 'repl' );
    
    figure, imagesc(local_avg_resp);
    figure, imagesc(computed_local_corr);
    colormap(gray);
    
    foreground_H = image_to_work - computed_local_corr;
    background_H = computed_local_corr;
    
    % Creating attributes of background ,foreground and entire image
    foreground_ab       = [ foreground_H(:), foreground_S(:) ];              
    background_ab       = [ background_H(:), background_S(:) ];             
    im_ab               = [ im_h(:) im_s(:) ];     
    %%
    
    
    mahal_fg    = mahal( im_ab, foreground_ab);
    mahal_bg    = mahal( im_ab, background_ab );
    
    b_is_target_object      = (mahal_fg.^(1/2)*0.1) > (mahal_bg.^(1/2)*2);
    
    target_map_image        = reshape( b_is_target_object, size(image_to_work,1), size(image_to_work,2) );
    
    figure;
    imagesc(target_map_image);
    colormap(gray);

    %
    %  Form a model of the foreground Mahalanobis distance:
    %
    foreground_dists  = mahal_fg.^(1/2);                  % NOTICE the sqrt.
    fg_dists_class0   = foreground_dists(b_is_target_object);
    dist_mean         = mean( fg_dists_class0 );
    dist_std_01       = std(  fg_dists_class0 );
    
    % Toss everything outside of one std, and re-adjust the mean value:
    b_inliers       = ( fg_dists_class0 <= (dist_mean + dist_std_01) ) & ( fg_dists_class0 >= (dist_mean - dist_std_01));
    the_inliers     = fg_dists_class0( b_inliers );
    dist_mean       = mean( the_inliers );
    

    %
    %  Use a distance to target variable as rules for inclusion:
    %
    threshold           = dist_mean;
    guess_class0        = foreground_dists >= threshold;
    out_image           = reshape( guess_class0, size(image_to_work,1), size(image_to_work,2) );
    figure;
    imagesc( out_image );
    colormap(gray);
    title('Foreground Classification Image ', 'FontSize', 15 );
    %}
end

%% Funtion to apply gaussian filter to remove noise and smoothen the image
function out = remove_noise(im_b)
    FILTER_SIZE = 15;
    STDEV = 20;
    gauss_f = fspecial('gauss',FILTER_SIZE,STDEV);
    out = imfilter(im_b,gauss_f,'same','repl');
end