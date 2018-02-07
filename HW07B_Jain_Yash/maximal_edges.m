function maximal_edges()
    clc;
    close all;
    
    % adding paths so that all the images in the below set path can be used
    % directly in the program
    addpath( [ '..' filesep() 'TEST_IMAGES' filesep() ] );
    addpath( '../TEST_IMAGES/');
    addpath( '../../TEST_IMAGES/');
    
    % As I am asked to workk on the image - TBK_OLD_LANDMARK_Dr.jpgstd-1
    im = imread('TBK_OLD_LANDMARK_Dr.jpg');
    input_image = im2double(im);
    fltr = fspecial('gauss', 14,20); 
    im2 = imfilter( input_image, fltr, 'same', 'repl' );
    
    figure;
    imagesc(im2);
    colormap(gray);
     
    % Horizontal gradient sobel filter
    sobel_hz_gradient = [-1 0 1;
                         -2 0 2;
                         -1 0 1]/8;
    
    % Vertical gradient sobel filter
    sobel_vr_gradient = sobel_hz_gradient.';
    
    % Applied sobel filter on red channel to get vertical and horizontal
    % edges. Coputed edge magnitude and angle for red channel
    %% For red color channel 
    dfdx_R = imfilter(im2(:,:,1),sobel_hz_gradient,'same','repl');
    dfdy_R = imfilter(im2(:,:,1),sobel_vr_gradient,'same','repl');
    
    edge_mag_R = (dfdx_R.^2 + dfdy_R.^2).^(1/2);
    angle_R = atan2d( -dfdy_R, dfdx_R ); 
    
    threshold1 = 0.03;
    round_angles_R = round(angle_R/45)*45;  
    intermediate_out_R = remove_edges_below_threshold1(edge_mag_R,threshold1,round_angles_R);
    figure;
    imagesc(intermediate_out_R);
    title('Red Channel -> Image after applying Threshold1','Fontsize',15)                  
    colorbar; 
    %colormap(gray);
    imwrite(intermediate_out_R,'YashJain_R_After_Applying_Threshold1.JPEG');
    
    threshold2 = 0.20;
    final_R = hysterysis(intermediate_out_R,threshold1,threshold2);
    figure;
    imagesc(final_R);
    title('Red Channel -> Image after applying Hysterisis','Fontsize',15)                  
    colorbar; 
    %colormap(gray);
    imwrite(final_R,'YashJain_R_Final_Applying_Hysterysis.JPEG');
    
    
    %% For green color channel 
    dfdx_G = imfilter(im2(:,:,2),sobel_hz_gradient,'same','repl');
    dfdy_G = imfilter(im2(:,:,2),sobel_vr_gradient,'same','repl');
    
    edge_mag_G = (dfdx_G.^2 + dfdy_G.^2).^(1/2);
    angle_G = atan2d( -dfdy_G, dfdx_G ); 
    
    threshold1 = 0.03;
    round_angles_G = round(angle_G/45)*45;  
    intermediate_out_G = remove_edges_below_threshold1(edge_mag_G,threshold1,round_angles_G);
    figure;
    imagesc(intermediate_out_G);
    title('Green Channel -> Image after applying Threshold1','Fontsize',15)                  
    colorbar; 
    %colormap(gray);
    imwrite(intermediate_out_G,'YashJain_G_After_Applying_Threshold1.JPEG');
    
    threshold2 = 0.20;
    final_G = hysterysis(intermediate_out_G,threshold1,threshold2);
    figure;
    imagesc(final_G);
    title('Green Channel -> Image after applying Hysterisis','Fontsize',15)                  
    colorbar; 
    %colormap(gray);
    imwrite(final_G,'YashJain_G_Final_Applying_Hysterysis.JPEG');
  
    
    %% For Blue color channel
    dfdx_B = imfilter(im2(:,:,3),sobel_hz_gradient,'same','repl');
    dfdy_B = imfilter(im2(:,:,3),sobel_vr_gradient,'same','repl');
    
    edge_mag_B = (dfdx_B.^2 + dfdy_B.^2).^(1/2);
    angle_B = atan2d( -dfdy_B, dfdx_B ); 
    
    threshold1 = 0.03;
    round_angles_B = round(angle_B/45)*45;  
    intermediate_out_B = remove_edges_below_threshold1(edge_mag_B,threshold1,round_angles_B);
    figure;
    imagesc(intermediate_out_B);
    title('Blue Channel -> Image after applying Threshold1','Fontsize',15)                  
    colorbar; 
    %colormap(gray);
    imwrite(intermediate_out_B,'YashJain_B_After_Applying_Threshold1.JPEG');
    
    threshold2 = 0.20;
    final_B = hysterysis(intermediate_out_B,threshold1,threshold2);
    figure;
    imagesc(final_B);
    title('Blue Channel -> Image after applying Hysterisis','Fontsize',15)                  
    colorbar; 
    %colormap(gray);
    imwrite(final_B,'YashJain_B_Final_Applying_Hysterysis.JPEG');
end

%% Hysterysis
function final = hysterysis(intermediate_out_R,threshold1,threshold2)
    dims = size(intermediate_out_R);
    
    % keep running this loop till we are getting changes
    while true
        didChange = false;
        for ii = 2 : dims(1)-1 
            for jj = 2 :dims(2)-1  
                if intermediate_out_R(ii,jj) > threshold2
                    % keep this pixl as its value is higher then threshold2
                end
                
                % If the value of a pixel is between threshold1 and
                % threshold2 then check for surrounding pixels 
                if intermediate_out_R(ii,jj) > threshold1 && intermediate_out_R(ii,jj) < threshold2
                    % If surrounding pixels have some edge value then
                    % brighten the current pixel to enhance edges
                    if intermediate_out_R(ii,jj+1)>0 || intermediate_out_R(ii-1,jj+1)>0 || intermediate_out_R(ii-1,jj)>0 || ...
                        intermediate_out_R(ii-1,jj-1)>0 || intermediate_out_R(ii,jj-1)>0 || intermediate_out_R(ii+1,jj-1)>0 || ...
                        intermediate_out_R(ii+1,jj)>0 || intermediate_out_R(ii+1,jj+1)>0
                            % keep that edge pixel
                            intermediate_out_R(ii,jj) = threshold2;
                            didChange = true;
                    % else reject it by changing the pixel value to 0
                    else
                        intermediate_out_R(ii,jj) = 0;
                        %didChange = true;
                    end
                end
            end
        end
        if (didChange == false)
            final = intermediate_out_R;
            break;
        end
    end
end

%% Applying threshold
function intermediate_out = remove_edges_below_threshold1(edge_mag,threshold1,angle)
    temp = edge_mag;
    dims = size(temp);
    
    % Loops through entire image to check below conditions
    for ii = 2 : dims(1)-1 
        for jj = 2 :dims(2)-1  
                % Finding appropriate row and column based on their angle values to perform operation.  
                if angle(ii,jj) == 0 || angle(ii,jj) == -180 || angle(ii,jj) == 180
                    tempi1 = ii;
                    tempi2 = ii;
                    tempj1 = jj-1;
                    tempj2 = jj+1;
                elseif angle(ii,jj) == 45 || angle(ii,jj) == -135
                    tempi1 = ii-1;
                    tempi2 = ii+1;
                    tempj1 = jj+1;
                    tempj2 = jj-1;
                elseif angle(ii,jj) == 90 || angle(ii,jj) == -90
                    tempi1 = ii+1;
                    tempi2 = ii-1;
                    tempj1 = jj;
                    tempj2 = jj;
                elseif angle(ii,jj) == 135 || angle(ii,jj) == -45
                    tempi1 = ii-1;
                    tempi2 = ii+1;
                    tempj1 = jj-1;
                    tempj2 = jj+1;
                end
                % chekcing if the selected 2 pixels have smaller values
                % then the current pixel and if current pixel is atleast
                % threshold1 else reject that current pixel by setting its
                % value to 0
                if ((edge_mag(ii,jj) >= edge_mag(tempi1,tempj1)) && (edge_mag(ii,jj) >= angle(tempi2,tempj2)) && (edge_mag(ii,jj) >= threshold1))
                    continue;
                else
                    temp(ii,jj) = 0;
                end
        end    
    end
    % saving final outpur to returning variable
    intermediate_out = temp;
end