function  HW02_Jain_Yash_part_02( )

    %
    %  Here is a list of file using a special Matlab system called a "Cell Array".
    %  Cell Arrays are nice because they can be anything at any place.
    %
    %  Effectively, they are structures of arbitrary information, of arbitrary lengths.
    %
    filename_list = { 
        'GRAY_GC01_7334.JPG',
        'GRAY_GC02_7354.JPG',
        'GRAY_GC04_7370.JPG',
        'GRAY_GC04_7371.JPG',
        'GRAY_GC04_7372.JPG',
        'GRAY_GC10_20170208_104521.JPG' };

    % You will want to do something to the images, other than display it:
    for img_counter = 1 : length( filename_list )
        
        fn  = filename_list{ img_counter };
        im = imread( fn );
        im = im2double(im);
        figure( 'Position', [10 10 1024 768] );
        imagesc( im );
        title(['Select gray card area for image: ',fn],'Fontsize',20,'Interpreter','none');
        [xs,ys] = ginput();
        
        im_selected = im(int16(ys(1)):int16(ys(2)),int16(xs(1)):int16(xs(2)),:);
        im_grayscale = rgb2gray(im_selected);
        
        figure( 'Position', [80 5 1024 768] ); 
        imhist( im_grayscale, 256 );
        title(['Histogram of gray scale image of selected area: ',fn],'Fontsize',20,'Interpreter','none');
        pause(4);
        
        figure( 'Position', [120 5 1024 768] ); 
        imagesc(im_grayscale);
        title(['Grayscale of selected part of image: ',fn],'Fontsize',20,'Interpreter','none');
        pause(5);
        
        gray_card_mean = mean(im_grayscale(:));
        gray_card_std = std(im_grayscale(:));
    
        fprintf('Mean for %s is %0.3f \n',fn,gray_card_mean)
        fprintf('STD for %s is %0.3f \n',fn,gray_card_std)
        fprintf('\n')
        
        close all;
    end
end


