function HW11__Jain__Yash_MAIN( file_name )
    clc
    close all;
    
    addpath( '../TEST_IMAGES' );
    
    % Read image
    im = im2double(imread( file_name ));
    
    % Displaying original image 
    figure('Position',[10 10 1028 768]);
    imagesc( im );
    title('Original Image');
        
    % Smoothen image to remove unwanted noisy edges by applying gaussian filter
    gauss = fspecial('Gaussian',3,2);
    im_filtered = imfilter(im, gauss, 'same', 'repl');
    
    % Apply sobel filter to find the edges in the image
    sobel_vr_gradient = [-1 0 1;
                         -2 0 2;
                         -1 0 1] / 8;
                     
    sobel_hr_gradient = sobel_vr_gradient.';
    
    % Finding Sobel horizontal and vertical edges
    im_horizontal_edges = imfilter(im_filtered, sobel_vr_gradient, 'same', 'repl');
    im_vertical_edges = imfilter(im_filtered, sobel_hr_gradient, 'same', 'repl');
    
    % Finding Sobel Edge Magnitude and angle
    edge_mag = ((im_horizontal_edges).^2 + (im_vertical_edges).^2).^(1/2);
    edge_angle = atan2(im_vertical_edges, im_horizontal_edges);
    
    % I played with all 3 color channels in RGB space and found green as
    % the best channel
    im_channel = edge_mag(:,:,2);
  
    % Creating vector of Angles in range -135 to 135 with difference of 90 degrees 
    % as described in homework PDF
    angles_in_range = [-135 : 90 : 136];
    
    % For all values of angles_in_range
    for a = 1 :length( angles_in_range )
       angle_for_current_iteration = angles_in_range( a );
       
       % Considering -22 to +22 degree tolearance as disccussed in PDF
       low_tolerance_in_degree = angle_for_current_iteration - 22;
       high_tolerance_in_degree = angle_for_current_iteration + 22;
       
       % Since all the angle values we have obtained by sobel are in
       % radinans we need to convert the working angle in radians
       low_tolerance_in_radians = deg2rad(low_tolerance_in_degree);
       high_tolerance_in_radians = deg2rad(high_tolerance_in_degree);
       
       % consider only those angle values that are in range of low_tolerance to high_tolerance.
       % Rest all values are 0.
       % Do this in a desired color channel (I played with all 3 color channels of RGB and found green works the best)
       edge_angles_of_a_channel = edge_angle(:,:,2);
       edge_angles_of_a_channel(edge_angles_of_a_channel < low_tolerance_in_radians ) = 0;
       edge_angles_of_a_channel(edge_angles_of_a_channel > high_tolerance_in_radians) = 0;
       
       % Select only the edge angles that we are in range
       edge_angles_only_in_range = edge_angles_of_a_channel ~= 0;
       
       %{
       % I tried this method but it did not work propely
       edge_mag_only_in_range = edge_mag(edge_angles_only_in_range);
       max_mag = max(edge_mag_only_in_range);
       threshold = max_mag / 5;
       edge_temp = im_channel;
       edge_temp(edge_mag_only_in_range < threshold) = 0;
       interested_range_edge_mag = (edge_temp > 0); %& edge_angles_only_in_range;
       %}
       
       % Select all the edge magnitude corresponding to selected angles in
       % above step.
       % Since we have selected the range of angles to work with, we have
       % to choose the edge magnitude corresponding to the same range.
       % For hough we need to paas the strongest edges, so I will capturte
       % the top 8% of edges.
       best_edge_mag_pixels = findBestEdges(im_channel, edge_angles_only_in_range);
        
       % Combining both gthe angles and magnitude of edges computed above
       % to get edges
       edges = (best_edge_mag_pixels > 0) & edge_angles_only_in_range;
    
       % Referred from MATALB documentation
       % Hough method will in detecting the hough lines. The function uses the parametric representation of a line: rho = x*cos(theta) + y*sin(theta).
       % The function returns rho, which is the distance from the origin to the line along a vector perpendicular to the line,
       % and theta, the angle in degrees(theta) between the x-axis and this vector. The function also returns
       % the Standard Hough Transform, H, which is a parameter space matrix whose rows and columns correspond to rho
       % and theta values respectively. 
       % Input parameter consist of strongest edges, Rhoresolution which tells us about the spacing of
       % Hough transform bins along the rho axis and Theta will tell us the Theta value for the
       % corresponding column of the output matrix.
        [H,T,R] = hough( edges, 'RhoResolution', 1, 'Theta',  -90:2:89 );
    
       % Referred MATLAB documentaion
       % Houghpeaks will find peaks in Hough transform matrix.
       % The first parameter it takes is the H that we got from hough()
       % Second parameter will specify the maximum number of peaks to identify.  By default, its value is 1.
       % If you increase the value of second parameter means you will get more number of peaks and hence 
       % increase the number of lines detected by houghlines.
       % Threshold parameter will specify the minimum value that should be taken as a peak.
       % Third parameter is a size of suppression neighborhood which is the neighborhood around each
       % peak that is set to zero after the peak is identified.
       peaks   = houghpeaks(H,10,'threshold',ceil( 0.3 * max(H(:))),'NHoodSize',[5 5]);
    
       % Referred MATLAB documentaion
       % Houghlines will find the line segments based on hough transform method.
       % It takes as input the Theta and rho are values returned by the hough method. Also peaks is a matrix
       % returned by the houghpeaks function. It has the  row and column
       % information of hough bins which we can use to searhc lines.
       % It returns the lines in a structure array and the length of this array is 
       % equal to the number of merged line segments found in the image.
       % 'Fillgap' : Fill the gaps found in the edges and 'MinLenght' takes the minimum length of a line.
       lines     = houghlines( edges, T, R, peaks,'FillGap', 130,'MinLength',320 );
    
       % showing brigthest edges
       figure;
       imagesc( edges );
       message = sprintf('Brightest angles selected for angle (in degrees) = %4.1f', angles_in_range( a ));
       title( message, 'FontSize', 15 );
       colormap(gray);
    
       % Drawing image where we will plot lines
       figure;
       imagesc( im );
       colormap(gray);
       axis image;
       
       % Putting hold on will help in retaining current plots while adding new plots
       hold on;
       message = sprintf('Hough Lines for image at angle(in degrees) = %4.1f ', angles_in_range( a ));
       title( message, 'FontSize', 15 );
    
       % Iterate through all the lines obtained  
       for line_idx = 1 : length(lines)
           % Plotting the hough line extracted using houghlines method.
           hold on;
           vertex1     = lines(line_idx).point1;
           vertex2     = lines(line_idx).point2;
           plot( [ vertex1(1) vertex2(1) ], [ vertex1(2) vertex2(2) ], 'c-', 'LineWidth', 3 );
          
           % Logic to find the votes
           % find the distance of  line formed by vertex1 and vertex2 with
           % other edge points in image.
           % After running this loop we will have all voting points
           % Then out of this loop find which one has got maximum votes and
           % that will be the intersection point of all the lines.
           % Then plot those cooridnates(code below)
       end
    
    %{
        % Showing the image and then plot the vanishing point in the image
        figure;
        imagesc( im );
        message = 'Vanishing Point';
        title( message, 'FontSize', 15 );
       
       % Put hold and then plot the vanishing point(coordinates x and y) in
       % the image displayed above 
        hold on;
        plot( x, y, 'ro', 'LineWidth', 1, 'MarkerSize', 22 );
        plot( x, y, 'g+', 'LineWidth', 1, 'MarkerSize', 22 );
        plot( x, y, 'bx', 'LineWidth', 1, 'MarkerSize', 22 );
     %}
    end
end

%% Find the brightest edges
function brightest_edges = findBestEdges(im_channel,edge_angles_only_in_range)

        edge_mag_corresponding_to_selected_angle = im_channel( edge_angles_only_in_range );
        
        % sort all the edges
        [ sorted_values ]   = sort( edge_mag_corresponding_to_selected_angle(:) );                
        
        % Find the brightest edge pixels from the selected edges in above step
        % Taking top 8% of edges.(Best edges or strongest edges) 
        temp_brightest_pixels =  round( numel( edge_mag_corresponding_to_selected_angle ) * (1-0.08) );
        
        % Find the threshold value
        threshold_of_brightness    = sorted_values( temp_brightest_pixels );
        best_edge_pixels      = im_channel;
        
        % All values other than brightest pixels are set to 0
        best_edge_pixels(im_channel < threshold_of_brightness) = 0; 
        
        brightest_edges = best_edge_pixels;
end