function HW04_Jain_Yash_main(image_name)
   addpath( '../TEST_IMAGES/' );
   addpath( '../../TEST_IMAGES/' );
   input_image = imread(image_name);
   % your_function_calls_here_to_other_functions
   % the rest of your homework goes in here?
    local_smear_routine( input_image );
    mat1 = round( fspecial( 'disk', 5 )*1000 );
    local_weighting_routine( input_image, mat1);
    mat2 = round( fspecial( 'gaus', 7, 3 )*1000 );
    local_weighting_routine( input_image, mat2);
end

function output_image =local_smear_routine(input_image)
    dimensions = size( input_image );
    if length( dimensions ) > 2 % It checks if we have 3D array(color image)
        % We don't need color information so if it is colored image we
        % convert it to grayscale image
        input_image = rgb2gray( input_image );
    end
    input_image = im2double(input_image);
    output_image = input_image; % Setting the default return value to input_image
    
    %dimensions(2) will actually give us number of columns in image
    %dimensions(1) will actually give us number of rows in image 
    %but in given code we stored in exact opposite manner so at the end I
    %interchanged the output_image( row, col ) to output_image( col, row )
    %to get correct output
    %value of ii and kk ranging from -1 to 1 i.e. -1,0,1
    for row = 2 : (dimensions(2) - 1)
        for col = 2 : (dimensions(1) - 1 )
            sum = 0;
            for ii = -1 : 1
                for kk = -1 : 1
                    sum = sum + input_image( col + ii, row + kk );
                end
            end
            output_image( col, row ) = sum / 9;
        end
    end
    figure;
    imagesc( output_image );
    colormap( gray );
    title('Local Smear Routine','Fontsize',15);
end


function output_image = local_weighting_routine( input_image, weights )
    wt_dims = size( weights ); % dimensions of the weights matrix, a MxM matrix.
    im_dims = size( input_image ); % dimensions of the image
    if length(im_dims) > 2 % What does this do?
        % add your comments here.
       input_image = rgb2gray( input_image );
    end
    
    input_image = im2double(input_image);
    
    output_image = input_image; % Set the default return values ?
    % set Q, R, S, T, etc? so that the following works.
    % You also need to compute W, the final normalization constant for the sum
    % Set S and T to mid length of weight(filter) matrix
    % Use the value of S and T to Q and R and 1 to it.
    S=ceil(wt_dims(2)/2)-1;
    T=ceil(wt_dims(1)/2)-1;
    Q=S+1;
    R=T+1;
    W=sum(weights(:)); % taking sum of all elements in weights ( as described in PDF )
    
    temp_Q = Q; % just keeping a copy of this to use while taking sum
    temp_R = R; % just keeping a copy of this to use while taking sum
    %disp(W)

    for row = Q : (im_dims(2) - Q - 1 )
        for col = R : (im_dims(1) - R - 1 )
            sum_total= 0;
            for ii = -S : S
                for kk = -T : T
                  sum_total = sum_total + input_image( col + ii, row + kk) * weights(ii+temp_Q,kk+temp_R);
                end
            end
            output_image( col, row ) = sum_total / W; %(W which is the correct normalization constant you decide );
        end
    end
    figure;
    imagesc( output_image ); 
    colormap( gray );
    title('Local Weighting Routine','Fontsize',15);
end