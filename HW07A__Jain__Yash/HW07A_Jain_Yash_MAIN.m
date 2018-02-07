function HW07A_Jain_Yash_MAIN(filePath)
    % clearing the console
    clc
    % closing all other windows
    close all
   
    % Turn off this warning "Warning: Image is too big to fit on screen. displaying at some% "
    warning('off', 'Images:initSize:adjustingMag');

    % adding paths so that all the images in the below set path can be used
    % directly in the program
    addpath( [ '..' filesep() 'TEST_IMAGES' filesep() ] );
    addpath( '../TEST_IMAGES/');
    addpath( '../../TEST_IMAGES/');
    
    % Test if given parameter filePath is file or folder
    % NOTE:- Put folder in the same working directory
    % FOLDER OF IMAGES SHOULD NOT BE IN TEST_IMAGES RATHER .m AND FOLDER
    % SHOULD BE AT SAME LEVEL
    isFile = isFileOrFolder(filePath);
    if isFile == true
        actualLogic(filePath);
    else
       listOfFiles = dir(filePath);
       for index = 1:length(filePath)
           nameOfFile = listOfFiles(index).name;
           % To eliminate . and ..
           if length(nameOfFile)>3
               actualLogic(strcat(strcat(filePath,'/'),nameOfFile));
           end
       end
    end
 
end

function isFile=isFileOrFolder(filePath)
    if isequal(exist(filePath,'file'),2) 
        disp('Its a file')
        isFile = true;
    elseif isequal(exist(filePath,'dir'),7)
       disp('Its a directory so program will run for all the files in dir');
       isFile = false;
    end
end

function actualLogic(filename)
    MIN_AREA_THRESHOLD =20000;
    MAX_AREA_THRESHOLD = 63000;
    % Initialized count vector to 0.
    % Its size is 7, first 6 are for number of 1's, 2's, 3's, 4's, 5's, 6's
    % and last one is to store the count of unknowns.
    countVector = [0,0,0,0,0,0,0];
    
    % Reading the input image.
    im = imread(filename);
    
    % Calculating the dimension of image and if its tall then rotating.
    dims = size(im);
    if(dims(1) > dims(2))
        im = imrotate(im,90);
    end    
    
    localAverageFilter = fspecial('Average',10);
    im = imfilter(im,localAverageFilter);
    
    % Showing the input image.
    figure;
    imshow(im);
    title('Input image','Fontsize',15)
    
    % Extracting the red channel because this will remove the red logo of
    % dice brand(Bicycle).
    im_red = im(:,:,1); 
    
    % Global image threshold using Otsu's method.
    % It will help to clear the dice so that we can read the details.
    level = graythresh(im_red);
    
    % Using the threshold value obtained by Otso, converted image to
    % binary.
    im_t = im2bw(im_red,level);
    imshow(im_t);
    title('Binary Image','Fontsize',15);
   
    % Created morphological structure of disk with size 11.
    % Applied it to erode the binary image.
    % By eroding, it will rmove the small white spots(noise).
    struct = strel('disk',11);
    im_e = imerode(im_t,struct);
    imshow(im_e);
    title('Eroded Image','Fontsize',15);
    
    % Displaying the input file name.
    fileMessage = ['INPUT FILE is ' ,filename];
    disp(fileMessage);
    
    % Label connected components in 2-D binary image.
    % it will extract almost all the dices in our case.
    % it may extract some false positive cases, that we are handling later
    % in the code.
    [seperation,label] = bwlabel(im_e);
    
    % Measure properties like Area, ConvexArea, BoundingBox, ConvexHull 
    % of image regions. 
    % In our case we are extracting ConvexHull, BoundingBox and Area.
    % ConvexHull  :- To get the coordinates of polygon to draw red
    %                boundary.
    % BoundingBox :- To get boundaries of dice which I am using to crop the
    %                image and select only region which has dice.
    % Area        :- To threshold the min and max area to minimize false dice
    %                 selection.
    polygons = regionprops(seperation,'ConvexHull','BoundingBox','Area');
  
    %Initialize the coune of dice to 0.
    countOfDice =0;
    
    % Tp update the figure windows and process callbacks.
    drawnow; 
    
    hold on;
    for index = 1:label 
        area = polygons(index).Area();
        %if(area < MIN_AREA_THRESHOLD | area > MAX_AREA_THRESHOLD)
        %    continue;
        %end
        
        % Extracting the x and y coordinates of convexhull(boundaries of
        % dice).
        xCoordinates = polygons(index).ConvexHull(:,1);
        yCoordinates = polygons(index).ConvexHull(:,2);
         
        %image_temp = (seperation==index);
        % Plotting the boundaries of dice with red color using coordinates
        % that we have found in previous step.
        plot(xCoordinates,yCoordinates,'r','LineWidth',2);
        
        % increase the count by 1.
        countOfDice = countOfDice + 1;
    end  
    
    % For every label crop the dice then find the number of dots.
    for index = 1: label
        im_dice = imcrop(im_e, polygons(index).BoundingBox);
        countVector = findNumberOfDots(im_dice,countVector);
    end
    hold off 
    
    numberOfDice = ['Number of dice/dices :',num2str(countOfDice)];
    disp(numberOfDice);
    
    % calling method to display the total statistical values,
    % definition of this funtion is below.
    display(countVector);
end

 
% This method will find the number of dots on a dice.
function countVector = findNumberOfDots(im_dice,countVector)
     % Creating the morpholical structure to dilate the image.
     % By dilaing it will set apart the dots of dice which are conected together
     % by previous erosion operation.
     st = strel('disk',22);
     im_temp = imdilate(im_dice,st);
     
     % By taking imcomplement I will make 0's to 1's and vice versa.
     % By doing this I will have white dots and black dice.
     % The reason for doing this is because we can use this image to
     % seperate 'white' dots from black background 'dice'.
     im_temp = imcomplement(im_temp);
     
     % Suppress light structures connected to image border.
     % This helps bwlabel to not detect false edges while seperating dots
     % and dice.
     im_temp = imclearborder(im_temp);
     [labeledImage, numofDots] = bwlabel(im_temp);
     
     %If the dice count comes to 0 or greater than 6, then add it to
     % unknown, process otherwise.
     if numofDots > 6 | numofDots == 0 
        countVector(7) =countVector(7)+1;
     else
        % add the counter for that number of dots which is used later to
        % show the output.
        t1 = countVector(numofDots);
        t1 = t1+1;
        countVector(numofDots) = t1;
     end
end 
 
% Display the number of dots and total dots using cell array.
function display(countVector)
    ones =0;
    twos=0;
    threes=0;
    fours=0;
    fives=0;
    sixes=0;
    unknown = 0;
    total=0;
    
    % Calculated count of 1's, 2's, 3's, 4's, 5's, 6's and unknown.
    for index =1:length(countVector) 
        if index == 1 & countVector(index)>0
            ones = ones + countVector(index);
        end
        
        if index == 2  & countVector(index)>0
            twos = twos +countVector(index);  
        end
        
        if index == 3 & countVector(index)>0
            threes = threes +countVector(index);
        end
        
        if index == 4 & countVector(index)>0
            fours = fours +countVector(index);
        end
        
        if index == 5 & countVector(index)>0
            fives = fives +countVector(index);
        end
        
        if index == 6 & countVector(index)>0
            sixes = sixes +countVector(index); 
        end
        
        if index == 7 & countVector(index)>0
            unknown = unknown +countVector(index); 
        end
    end
    
    % Created cell array and added all values to it
    cell = {};
    cell{1,1} = 'NUMBERS';
    cell{1,2} = 'COUNT';
    
    cell{2,1} = 'Number of ones';
    cell{3,1} = 'Number of twos';
    cell{4,1} = 'Number of threes';
    cell{5,1} = 'Number of fours';
    cell{6,1} = 'Number of fives';
    cell{7,1} = 'Number of sixes';
    cell{8,1} = 'Number of unknowns';
    
    cell{2,2} = ones;
    cell{3,2} = twos;
    cell{4,2} = threes;
    cell{5,2} = fours;
    cell{6,2} = fives;
    cell{7,2} = sixes;
    cell{8,2} = unknown;
    
    total = total + (1*ones);
    total = total + (2*twos);
    total = total + (3*threes);
    total = total + (4*fours);
    total = total + (5*fives);
    total = total + (6*sixes);
    
    % Total number of dots
    cell{9,1} = 'TOTAL DOTS';
    cell{9,2} = total;
    cell
end
