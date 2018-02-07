function HW09_part3(filename)
    im = imread(filename);
    figure;
    imagesc(im);
    title('Orginal Image','Fontsize',15);
    if(~isempty(strfind(filename,'BALLS')))
        % Applied local averaging to clean the image
        disk_filter = fspecial('disk',7);
        im_filtered_avg = imfilter(im,disk_filter);
    
        % Applied gaussian filter to further remove the noise
        gauss_filter = fspecial('gauss',4,0.3);
        im_filtered = imfilter(im_filtered_avg,gauss_filter);

        k_values = [3,4,5,16,32];
    
        for index = 1 : length(k_values(:))
            [im_out,x] = rgb2ind(im_filtered,k_values(index),'nodither');
            figure;
            imagesc(im_out);
            colormap(x);
            message = ['Homework09-> PART-3, K value is ',num2str(k_values(index))];
            title(message,'Fontsize',15);
        end
    end
    if (~isempty(strfind(filename,'MACBETH')))
        % Applied local averaging to clean the image
        disk_filter = fspecial('disk',2);
        im_filtered_avg = imfilter(im,disk_filter);
    
        % Applied gaussian filter to further remove the noise
        gauss_filter = fspecial('gauss',4,0.5);
        im_filtered = imfilter(im_filtered_avg,gauss_filter);

        k_values = [15,40,64,100];
    
        for index = 1 : length(k_values(:))
            [im_out,x] = rgb2ind(im_filtered,k_values(index),'nodither');
            figure;
            imagesc(im_out);
            colormap(x);
            message = ['Homework09-> PART-3, K value is ',num2str(k_values(index))];
            title(message,'Fontsize',15);
        end
    end
end