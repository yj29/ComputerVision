function HW12_Jain_Yash(filename)
    clc
    close all;
    USE_POINTS = 1 
    
    % adding paths so that all the images in the below set path can be used
    % directly in the program
    addpath( [ '..' filesep() 'TEST_IMAGES' filesep() ] );
    addpath( '../TEST_IMAGES/');
    addpath( '../../TEST_IMAGES/');
    
    if nargin ~= 1
        filename = 'img_cantaloupe_slices_1246.jpg';
    end
    
    figure;
    im = im2double(imread(filename));
    imshow(im);
    title('Original Image','Fontsize',20);
    
    if USE_POINTS
        figure;
        im = im2double(imread(filename));
        imshow(im);
        title('Click on flesh (foreground region).. Hit return to end...\n','Fontsize',20);
        %collecting the foreground object flesh points
        [xCoordinateFlesh, yCoordinateFlesh] = ginput();

        figure;
        im = im2double(imread(filename));
        imshow(im);
        title('Click on skin (foreground region).. Hit return to end...\n','Fontsize',20);
        %collecting the foreground object skin points
        [xCoordinateSkin, yCoordinateSkin] = ginput();

        figure;
        im = im2double(imread(filename));
        imshow(im);
        title('Click on white board (background region).. Hit return to end...\n','Fontsize',20);
        %collecting the background object white board points
        [xCoordinateWhiteBoard, yCoordinateWhiteBoard] = ginput();

        save melon_points;
    else
        disp('Loading points..')
        load melon_points;
    end
   
    
    %Converting input image to suitable color channel
    im_lab = rgb2lab(im);
    im_aspace =im_lab(:,:,2);
    im_bspace =im_lab(:,:,3);

    %collecting the foreground object from the points selected
    foreground  = sub2ind( size(im_lab), round(yCoordinateFlesh), round(xCoordinateFlesh) );
    foregroundFleshAComponent        = im_aspace( foreground );
    foregroundFleshBComponent        = im_bspace( foreground );

    %collecting the foreground skin region from the points selected
    foregroundSkin  = sub2ind( size(im_lab), round(yCoordinateSkin), round(xCoordinateSkin) );
    foregroundSkinAComponent        = im_aspace( foregroundSkin );
    foregroundSkinBComponent        = im_bspace( foregroundSkin );
   
    %collecting the background white table region from the points selected
    backgroundWhiteBoard  = sub2ind( size(im_lab), round(yCoordinateWhiteBoard), round(xCoordinateWhiteBoard) );
    backgroundWhiteBoardAComponent        = im_aspace( backgroundWhiteBoard );
    backgroundWhiteBoardBComponent        = im_bspace( backgroundWhiteBoard );
   
    %concatenating the foreground and background 
    foregroundFlesh = [foregroundFleshAComponent foregroundFleshBComponent];
    backgroundSkin = [foregroundSkinAComponent foregroundSkinBComponent];
    backgroundWhiteBoard = [backgroundWhiteBoardAComponent backgroundWhiteBoardBComponent];

    %concatenating the A and B component of image.
    MelonImageAandBCompoment = [im_aspace(:) im_bspace(:)];

    %Calculating the mahalanobis distance for foreground(melon and skin)
    %and background(white board)
    MahalanobisDistanceForForeground = mahal(MelonImageAandBCompoment,foregroundFlesh );
    MahalanobisDistanceForForegroundSkin = mahal(MelonImageAandBCompoment,backgroundSkin);
    MahalanobisDistanceForBackgroundWhiteBoard = mahal(MelonImageAandBCompoment,backgroundWhiteBoard);
    
    %We are interested in only foreground region which is the orange fruit part
    %in this case. Select those foreground pixels whose value is less than 
    %skin background and white board background.
    edgeofskin = MahalanobisDistanceForForeground > MahalanobisDistanceForForegroundSkin & MahalanobisDistanceForBackgroundWhiteBoard > MahalanobisDistanceForForegroundSkin;

    out = reshape( edgeofskin, size(im_aspace,1), size(im_bspace,2) );
    figure;
    imshow(out);
    title('Output of supervised learning');
    
    er = [2,4,6,8] ;
    for i = er
       str = strel('disk',i);
        ero = imdilate(out,  str);
        figure;
        imagesc( ero );
        axis image;
        colormap(gray);
        message =['dilate ',num2str(i)];
        title(message, 'FontSize', 20, 'FontWeight', 'bold' ) 
    end
    
    % Find number of connected components to get number of slices of melon
    connected_components = bwconncomp(ero);
    mes = ['Number of melons in image = ' , num2str(connected_components.NumObjects)];
    disp(mes);
    
    % Perfrom erosion to clean noise
    er = [1] ;
    for i = 1:5
       str = strel('disk',1);
        out = imerode(out,  str);
        figure;
        imagesc( out );
        axis image;
        colormap(gray);
        message =['erode ',num2str(i)];
        title(message, 'FontSize', 20, 'FontWeight', 'bold' ) 
    end
    
    % Used regionprops to find the ploygons to plot
    [seperation,label] = bwlabel(out);
    polygons = regionprops(seperation,'ConvexHull','BoundingBox','Area');
    
    figure;
    imagesc(im);
    title('Final output')
    drawnow; 
    
    hold on;
    for index = 1:label 
        % Extracting the x and y coordinates of convexhull
        xCoordinates = polygons(index).ConvexHull(:,1);
        yCoordinates = polygons(index).ConvexHull(:,2);
         
        %image_temp = (seperation==index);
        % Plotting the boundaries with meganta color using coordinates
        % that we have found in previous step.
        plot(xCoordinates,yCoordinates,'m-','LineWidth',2);
    end  
end
