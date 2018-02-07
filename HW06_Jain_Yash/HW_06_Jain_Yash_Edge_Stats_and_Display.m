function HW_06_Jain_Yash_Edge_Stats_and_Display( fn_in, hw_part_number )
MARGIN          = 20;
CUTOFF_PERCENT  = 0.95;

    % Reading the image named fn_in using imread and 
    % at the same time converted that image to double using
    % im2double which changed the range of pixel values from 0 to 1[0-1]
    im_in  = im2double( imread( fn_in ) );
    
    % if its a color image(3D) then we extracting the green channel and
    % applying gaussian filter of dimension 5 * 5 with standard devaition value 1 to that extracted green channel.
    % Storing the output value in im_grn
    % By this we are trying to get more smooth image
    % else if image is already 2D then we are storing it in im_grn
    if ( length( size( im_in) ) == 3 )
        im_grn = imfilter( im_in(:,:,2), fspecial('gaussian', [5 5], 1 ) );
    else
        im_grn = im_in;
    end

    % This is a gaussian local avergaing filter of dimension 3 *3 as the mid value is largest 
    % and sum of all elements comes to 1
    % This will help smoothing the image and removing noise
    % Also we are replicating the edges while applying the filter
    % and size of output image as 'same'
    fltr            = [ 1 2 1 ;
                        2 4 2 ;
                        1 2 1 ] / 16;
    im_grn          = imfilter( im_grn, fltr, 'same', 'repl' );
    
    
    % Below are the soble filters which detects edges in image.
    % edge_detector_vt is vertical gradient sobel filter while
    % edge_detector_hz is horizontal gradient sobel filter
    edge_detector_vt = [ 1  2  1 ; 
                         0  0  0 ;
                        -1 -2 -1 ]/8;
    edge_detector_hz    = edge_detector_vt.';

    % Applying vertical and horizontal gradient sobel filter
    % By applying vertical grdient we will get horizontal edges
    % and by applying horizontal gradient we will get vertical edges
    edges_vt            = imfilter( im_grn, edge_detector_vt, 'same', 'repl' );
    edges_hz            = imfilter( im_grn, edge_detector_hz, 'same', 'repl' );
    
    % Finding the magnitude by using dIdX(edges_hz) and dIdY(edges_hz)
    % Magnitude is 'Magnitude = sqrt((dIdX)^2 + (dIdY)^2)'
    % Below is the MATLAB syntax for the above magnitude formula 
    % this will give us both vertical and horizontal component
    edge_mag            = ( edges_vt.^2 + edges_hz.^2 ).^(1/2);
    
    % By doing this we are adding margin of 20 pixels 
    % We are putting 0 to first 20 pixels on all borders of images.
    % All borders including top, bottom, left and right
    edge_mag( 1:MARGIN,         : )                = 0;
    edge_mag( end-MARGIN-1:end, : )                = 0;
    edge_mag( :,                1:MARGIN )         = 0;
    edge_mag( :,                end-MARGIN-1:end ) = 0;
    
    % Numel returns total number of elements present in the matrix (passed as parameter)
    % Here n_pixels stores the number of pixels present in im_green image. 
    n_pixels            = numel( im_grn );
    
    % max returns the largest value present in given input vector
    % We passed a colon(:) means all the values in matrix are given to max as single vector 
    % We gave bin size as 256 so the max value is divided by 256
    edge_mmax           = max( edge_mag(:) );
    edge_bin_inc        = edge_mmax / 256;          % Arrange for 256 bins.
    
    % For part 1 of homework we set the edge_bin_in to 0.0001 
    % We will use this bin size to store values in bind_edges
    %
    if hw_part_number > 1
        edge_bin_inc  	= 0.0001;
    end
    
    % Store all values from 0 to edge_mmax keeping in between difference of edge_bin_inc
    % value defined above.
    % Example :- edge_maxx = 11 and edge_bin_inc is 2 then
    % bin_edges = [0 2 4 6 8 10]
    bin_edges           = 0 : edge_bin_inc : edge_mmax; 

    % histcounts will partition the values in vector(edge_mag(:)) into bin_edges 
    % and then returns the count in each bin as well as bin edges
    % Here we are ignoring the bin edges here
    % Putting each edge magnitude in the respective bin
    [bin_counts, ~]     = histcounts( edge_mag(:), bin_edges );
   
    % cumsum takes the cumulative sum of elements in bit_counts and store
    % it in bin_cumulatives.
    % Example :- bin_counts = [1 2 3 4] then computing cumsum will give,
    % bin_cumulatives  = [1 3 6 10]
    bin_cumulatives     = cumsum( bin_counts );
   
    % Here we are computing the number of pixels that comes under the cut
    % of region.
    % When we multiply CUTOFF_PERCENT which is 0.95 to number of pixels
    % i.e. n_pixels,  we will the get 95% of n_pixels.
    % We are storing this value in ninty_five_pc_count
    ninty_five_pc_count = CUTOFF_PERCENT * n_pixels;
    
    % Working of find():
    % 1) find will return a vector of indexes of input elements where we have
    % non zero element value. 
    % 2) Second parameter n will return first n nonzero indices.
    % 3) Last attribute is direction, it can have 2 values
    %    'first' or 'last'. 'last' means it finds last n nonzero indices.
    %    Default value of direction is 'first'
    % 
    % In our case it will return only(since n=1) the first index(direction is first), where 
    % value of element of bin_cumulatives is greater than value of element of ninty_five_pc_count
    % this will give us stopping index
    stop_ind            = find( bin_cumulatives > ninty_five_pc_count, 1, 'first' );
    
    % By doing this we are picking the value at stop_ind positon of
    % bin_edges 
    % It will give the value at 95th%
    % Its like picking up threshold value which is 95% in this case.
    over_ninty_five_val = bin_edges( stop_ind );

    % We are putting 0 to all other elements whose values are less then
    % threshold which is 95% in this case.
    % Basically we are ignoring the edge values whose value is less then 95% of overall edge intensity
    % By doing this we are actually picking top 5% sharpest value edges
    edge_mag( edge_mag <= over_ninty_five_val ) = 0;
    
    f1 = figure('Position', [4 4 1024 768] );
    stem( bin_edges(1:end-1), bin_counts, 'MarkerFaceColor', 'b');
    set(gca(), 'Position', [0.05 0.05 0.9 0.9]);
    
    
    % axis() has 4 values. 
    % First two values will tell us the starting and ending range on x axis, 
    % next two tells us abour starting and ending range of y axis
    % Here we set starting value on x axis as 0 and it will go till 0.10
    % We did not mention anything about y axis so it will take default value for y axis
    % Then assign these values to axis
    new_axis        = axis();
    new_axis(1)     = 0;
    new_axis(2)     = 0.10;
    axis( new_axis );
    
    % hold on will hold all the values that we have set for axis in previous step
    % it will not allow to reset these values automatically.
    hold on;
     
    % It draws the vertical magenta line. The width of the line is given as
    % 1.5.
    % The first 2 parameters tells about the x axis range and y axis range
    % y axis range starts from 0 and ends to the default value of axis i.e. axis(4)
    plot( [1 1]*(over_ninty_five_val+edge_bin_inc/2), [0 new_axis(4)], 'm-', 'LineWidth', 1.5 );
    
    % We create figure window to show at 750,550 and size of figure window is 720 * 720
    % We prepare axis and show image with title of fontsize 20
    f2_posit    = [750 550 720 720];
    f2          = figure('Position', f2_posit );
    imagesc( edge_mag );
    set(gca(), 'Position', [0.05 0.05 0.9 0.9]);
    axis image;
    colormap( 'default' );
    colorbar;
    ttl =  [ fn_in ' '];
    ttl( ttl == '_' ) = ' ';
    title( ttl , 'FontSize', 20 );
    
    set(f2, 'Position', f2_posit );
    
end


