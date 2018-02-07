function HW09_part6(filename)
    % Reading the input image 
    im = imread(filename);
    
    edges = find_edges(im);
    thresholdEdge = strengthEdge(edges);
    
    % Getting dimension of the input image
    dims = size( im );
    
    % Displaying the original image
    figure;
    imagesc(im);
    k = 40;
    
    % Taking the LAB color space of given input image
    im          = rgb2lab(im);
    
    % Applying gaussinan filter to get the smoothen edges
    fltr        = fspecial( 'gauss', 15, 4 );
    im          = imfilter( im, fltr, 'same', 'repl' );
    
    % Gathering the x and y corrdinates to pass
    [xs, ys]    = meshgrid( 1:dims(2), 1:dims(1) );
    
    first       = im(:,:,1);
    second      = im(:,:,2);
    third       = im(:,:,3);
    
    % Adjusting attributes
    xs1     = xs / 10 ; % balanceTheRange(xs);
    ys1     = ys / 10; % balanceTheRange(ys);
    first1   = first; % balanceTheRange(first);
    second1  = second; % balanceTheRange(second);
    third1   = third; % balanceTheRange(third);
    
    % Creating single attribute by combining l, a, b, x and y
    attributes  = [  double(first1(:)), double(second1(:)) ...
                    ,double(third1(:)),xs1(:), ys1(:)];
    
    % Applying k-means
    [cluster_id, centroids] = kmeans( attributes, k, 'MaxIter', 1 );
    % Creating image from the clustered output
    im_new      = reshape( cluster_id, dims(1), dims(2) );

    lab_colormap = centroids( :, 1:3 );
    rgb_colormap = lab2rgb( lab_colormap );
    
    %im_out = apply_borders(im_new,thresholdEdge);
    im_o = apply_borders(im_new,thresholdEdge);
    figure;
    imagesc( im_new );
    colorbar;
    colormap( rgb_colormap );
end

function res = apply_borders(im_out,out)
    dims = size(im_out);
    for ii = 1: dims(1)
        for jj = 1:dims(2)
            if(out(ii,jj)~=1)
                im_out(ii,jj) = 0;
            end
        end
    end
    
    avg =fspecial('average',4);
    im_out = imfilter(im_out,avg);
    res = im_out;
end

function edges = find_edges(im)
    FS = 18;

    edge_amount_to_add_back_in = 0.75;

    im_in               = im2double( im );

    figure('Position',[10 10 768 768] );
    imagesc( im_in );
    colormap(gray);
    title( 'Input Image', 'FontSize', FS  );

    std_set         = 1;

   
        std_dev         = std_set;
        gauss_filter    = fspecial( 'gauss', 15, std_dev );
        im_blurred      = imfilter( im_in, gauss_filter, 'same', 'replicate' );
        ttl             = sprintf('Gaussian local average, with \\sigma of %6.2f ', std_dev );
        
        %
        %  Compute an estimate of the edges as the blurred image
        %  minus the original image:
        %
        im_edges        = im_in - im_blurred;
        
        %
        %  Enhance the image, by adding some amount of the 
        %  estimated edges back on to the original image:
        %
        im_new          = im_in + edge_amount_to_add_back_in * im_edges;
        
        imagesc( im_new );
        colormap(gray);
        title( ttl, 'FontSize', FS );
        
        pause( 2 );
        edges = im_edges;
end

function res = strengthEdge(edges)
    max1 = max(edges(:));
    dims = size(edges);
    out = zeros(dims(1),dims(2));
    for ii = 1 : dims(1)
        for jj = 2 : dims(2)
            if edges(ii,jj) > max1/8
                out(ii,jj) = 0;
            else
                out(ii,jj) = 1;
            end
        end
    end
    figure;
    imagesc(out);
    colormap(gray);
    res = out;
end