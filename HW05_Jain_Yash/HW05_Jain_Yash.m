function HW05_Jain_Yash()
    addpath( '../TEST_IMAGES/' );
    addpath( '../../TEST_IMAGES/' );
    
    im = im2double(imread('Parent_Drop_off.jpg'));
    
    %Converting the image to grayscale(2D) if its a colored image(3D)
    if(length(size(im))>2)
        im = rgb2gray(im);
    end
    
    %Creating a cell of dimension 9 * 3
    output_cell = cell(9,3);
    
    %Storing all filters
    filterA = [ 1 2 1 ; 0 0 0 ; -1 -2 -1 ] / 8;
    filterB = [ 1 0 -1 ; 2 0 -2 ; 1 0 -1 ] / 8;
    filterC = [ 1 0 0 0 -1 ; 2 0 0 0 -2 ; 1 0 0 0 -1 ] / 16;
    filterD = [ 1 0 0 0 0 0 0 0 -1 ; 2 0 0 0 0 0 0 0 -2 ; 1 0 0 0 0 0 0 0 -1 ] / 32;
    filterE = [ 0 -1 0 ; -1 4 -1 ; 0 -1 0 ];
    filterF = fspecial('laplacian', 1);
    filterG = fspecial('log');
    
    output_cell = prepare_output_cell(output_cell);
    
    %Creating an array of al the filters
    filter = {filterA,filterB,filterC,filterD,filterE,filterF,filterG};
    
    %Applying manual filter one by one
    for index = 1 : length(filter)
        output_cell = apply_filter(im,filter{index},index,output_cell);
    end
    
    %Applying imfilter one by one
    for index = 1 : length(filter)
        tic
        im_out = imfilter(im,filter{index},'same','repl');
        elapsed_time = toc;
        output_cell{index+2,2} = elapsed_time;
        title_message = sprintf('Elapsed Time (imfilter) : %f',elapsed_time);
        figure;
        imshow(im_out);
        title(title_message,'Fontsize',15);
        pause(1);
    end
    
    %Display the ooutput cell created which has all the time values
    output_cell
end


function output_cell = apply_filter(im,fltr,index,output_cell)
    wt_dims = size( fltr ); % dimensions of the filter
    im_dims = size( im ); % dimensions of the image
   
    output_image = im; %default value
    % set Q, R, S, T, etc? so that the following works.
    % You also need to compute W, the final normalization constant for the sum
    % Set S and T to mid length of weight(filter) matrix
    % Use the value of S and T to Q and R and 1 to it.
    S=ceil(wt_dims(1)/2)-1;
    T=ceil(wt_dims(2)/2)-1;
    Q=S+1;
    R=T+1;
    
    tic
    for row = Q : (im_dims(1) - Q )
        for col = R : (im_dims(2) - R )
            sum_total= 0;
            for ii = -S : S
                for kk = -T : T
                  sum_total = sum_total + im( row + ii, col + kk) * fltr( ii + Q , kk + R );
                end
            end
            output_image( row, col ) = sum_total;
        end
    end
    elapsed_time = toc;
    output_cell{index+2,3} = elapsed_time;
    figure;
    imshow( output_image ); 
    title_message = sprintf('Elapsed Time(Manual filter) : %f',elapsed_time);
    title(title_message,'Fontsize',15);
    pause(1)
end


function output_cell = prepare_output_cell(output_cell)
    output_cell{1,1} = 'Filters';
    output_cell{1,2} = 'Time of imfilter()';
    output_cell{1,3} = 'Time of manual filter';
    output_cell{2,1} = '---------------------';
    output_cell{2,2} = '---------------------';
    output_cell{2,3} = '---------------------';
    output_cell{3,1} = 'filterA';
    output_cell{4,1} = 'filterB';
    output_cell{5,1} = 'filterC';
    output_cell{6,1} = 'filterD';
    output_cell{7,1} = 'filterE';
    output_cell{8,1} = 'filterF';
    output_cell{9,1} = 'filterG'; 
end