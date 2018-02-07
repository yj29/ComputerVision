function HW03_Jain_Yash()
    filename_list1 = { 'TBK_Kite.jpg', ...
        'TBK_BRICKS.JPG',...
        'Aries_Merritt__shirt_at_olympics.jpeg', ...
        'Chelsea_and_Hillery_Clintons_Selfies.jpg', ...
        'ALIASING__Obama_in_striped_shirt__Getty_Images_enhanced.jpg', ...
       'Might_or_Might_NOT.jpg'};
   
   filename_list2 ={'TBK_Kite.jpg','kod_kid.png','kod_parrots.png',...
                     'Might_or_Might_NOT.jpg'};
   
   for img_counter = 1 : length( filename_list1 )
        fn  = filename_list1{ img_counter };
        Check_Resizing_Nearest(fn);
   end
   close all
   
   for img_counter = 1 : length( filename_list1 )
        fn  = filename_list1{ img_counter };
        Check_Resizing_Default(fn);
   end
   close all
   
   for img_counter = 1 : length( filename_list2 )
        fn  = filename_list2{ img_counter };
        CHECK_QUANTIZATION_HW(fn);
   end
   close all
   
   HW03_part3();
   pause(4)
   close all
   
   HW03_part4();
   pause(4)
   close all
end

function Check_Resizing_Nearest( fn )
    sampling_factor = [ 1 2 4 8 16 24 32 48 50 52 56 64 ];
    im = imread(fn);
    for index = 1:length(sampling_factor(:))
        dims = size( im );
        original_image_size = dims( 1:2 );
        newSize = round( original_image_size / sampling_factor(index) );
        im_small = imresize( im, newSize, 'nearest' );
        im_restored = imresize(im_small, original_image_size, 'nearest');
        imshow(im_restored);
        message = sprintf('Sub-Sampling(with nearest) factor is %d ',sampling_factor(index));
        title( message, 'FontSize', 18 );
        pause(1)
    end
end

function Check_Resizing_Default( fn )
    sampling_factor = [ 1 2 4 8 16 24 32 48 50 52 56 64 ];
    im = imread(fn);
    for index = 1:length(sampling_factor(:))
        dims = size( im );
        original_image_size = dims( 1:2 );
        newSize = round( original_image_size / sampling_factor(index) );
        im_small = imresize( im, newSize);
        im_restored = imresize(im_small, original_image_size);
        imshow(im_restored);
        message = sprintf('Sub-Sampling(without nearest) factor is %d ',sampling_factor(index));
        title( message, 'FontSize', 18 );
        pause(1)
    end
end

function CHECK_QUANTIZATION_HW(fn)
    quantization_factor = [ 1 2 4 8 16 32 40 50 64 ];
    im = imread(fn);
    for index = 1:length(quantization_factor(:))
        new_im 	= round( im / quantization_factor(index) );
        im_restored 	= new_im * quantization_factor(index);
        imshow(im_restored);
        message = sprintf('Quantization factor is %d ',quantization_factor(index));
        title( message, 'FontSize', 18 );
        pause(1)
    end
end

function HW03_part3( )
    im = imread('Might_or_Might_NOT.jpg');
    im = im2double(im);
    %im_gray = rgb2gray(im);
    
    %im_new_cube_root = im_gray.^(1/3);
    %im_new_square = im_gray.^(2);
    
    imadjust_img=imadjust(im);
    histeq_img = histeq(im);
    adapthisteq_img = adapthisteq(im);
    
    figure('Position',[10 10 1024 768]);
    subplot(1,2,1)
    imshow(imadjust_img);
    title('Using imadjust','Fontsize',20);
    subplot(1,2,2)
    imhist(imadjust_img);
    
    figure('Position',[50 50 1024 768]);
    subplot(1,2,1)
    imshow(histeq_img);
    title('Using histeq','Fontsize',20);
    subplot(1,2,2)
    imhist(histeq_img);
  
    figure('Position',[90 90 1024 768]);
    subplot(1,2,1)
    imshow(adapthisteq_img);
    title('Using adapthisteq','Fontsize',20);
    subplot(1,2,2)
    imhist(adapthisteq_img);    
    pause(4)
end

function HW03_part4( )
    im = imread('Integrated_Circuit_sm.jpg');
    im = im2double(im);
    im_gray = rgb2gray(im);
    
    %im_new_cube_root = im_gray.^(1/3);
    %im_new_square = im_gray.^(2);
    
    imadjust_img=imadjust(im_gray);
    histeq_img = histeq(im_gray);
    adapthisteq_img = adapthisteq(im_gray);
    
    figure('Position',[10 10 1024 768]);
    subplot(1,2,1)
    imshow(imadjust_img);
    title('Using imadjust','Fontsize',20);
    subplot(1,2,2)
    imhist(imadjust_img);
    
    figure('Position',[50 50 1024 768]);
    subplot(1,2,1)
    imshow(histeq_img);
    title('Using histeq','Fontsize',20);
    subplot(1,2,2)
    imhist(histeq_img);
  
    figure('Position',[90 90 1024 768]);
    subplot(1,2,1)
    imshow(adapthisteq_img);
    title('Using adapthisteq','Fontsize',20);
    subplot(1,2,2)
    imhist(adapthisteq_img);    
    pause(4)
end