function HW02_Jain_Yash( )

    % This can call a function that takes no parameters...
    % The function could be another function in this same
    % file, or it could be in a separate file.
    HW02_Jain_Yash_part_01( );
    
    % This calls a function in a separate file:
    HW02_Jain_Yash_part_02( );
    
end


function  HW02_Jain_Yash_part_01( )

    %
    %  Here is a list of file using a special Matlab system called a "Cell Array".
    %  Cell Arrays are nice because they can be anything at any place.
    %
    %  Effectively, they are structures of arbitrary information, of arbitrary lengths.
    %
    filename_list = { 'ANPR_IMG_2387.jpg', ...
        'Macbeth_7457.jpg', ...
        'Michelle_Carter_first_us_shot_put_gold_winner_2016__credit_Alexander_Hassenstein_via_Getty_Images_2016.jpg', ...
        'TBK_Kite.jpg', ...
        'peppers.png' };

    % This demonstrates going through a cell array to get the contents of each cell:
    for img_counter = 1 : length( filename_list )
        fn  = filename_list{ img_counter };
        HW02_Jain_Disp_Color_Spaces(fn);
        close all;
    end
end

function HW02_Jain_Disp_Color_Spaces( fn )
   im = imread( fn );
        im = im2double(im);
        figure( 'Position', [10 10 1024 768] );
        %imshow( im );
        
        subplot(2,2,1);
        imagesc(im);
        title('RGB Image','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,2);
        imagesc(im(:,:,1));
        title('Red channel','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,3);
        imagesc(im(:,:,2));
        title('Green channel','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,4);
        imagesc(im(:,:,3));
        title('Blue channel','Fontsize',20);
        axis image;
        axis off;
        pause(3)
   
        im_hsv = rgb2hsv(im);
        figure( 'Position', [30 30 1024 768] );
        subplot(2,2,1);
        imagesc(im_hsv);
        title('HSV Image','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,2);
        imagesc(im_hsv(:,:,1));
        title('Hue','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,3);
        imagesc(im_hsv(:,:,2));
        title('Saturation','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,4);
        imagesc(im_hsv(:,:,3));
        title('Value','Fontsize',20);
        axis image;
        axis off;
        pause(3)
    
        im_lab = rgb2lab(im);
        figure( 'Position', [50 50 1024 768] );
        subplot(2,2,1);
        imagesc(im_lab);
        title('LAB Image','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,2);
        imagesc(im_lab(:,:,1));
        title('First channel(LAB)','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,3);
        imagesc(im_lab(:,:,2));
        title('Second Channel(LAB)','Fontsize',20);
        axis image;
        axis off;
    
        subplot(2,2,4);
        imagesc(im_lab(:,:,3));
        title('Third Channel(LAB)','Fontsize',20);
        axis image;
        axis off;
        pause(6);
      
end








