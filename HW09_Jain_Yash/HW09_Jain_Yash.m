function HW09_Jain_Yash()
    clc
    close all
    
    % adding paths so that all the images in the below set path can be used
    % directly in the program
    addpath( [ '..' filesep() 'TEST_IMAGES' filesep() ] );
    addpath( '../TEST_IMAGES/');
    addpath( '../../TEST_IMAGES/');
    
   
    %% Part3
    disp('Part 3....')
    %im = imread('BALLS_FOUR_5244_shrunk.jpg');
    HW09_part3('BALLS_FOUR_5244_shrunk.jpg');
    
    %im = imread('MACBETH_HW09_shrunk.jpg');
    HW09_part3('MACBETH_HW09_shrunk.jpg');
    pause(3);
    disp('Done with part3...')
    close all;
    
    %% Part4
    disp('Part 4....')
    %im = imread('BALLS_FOUR_5244_shrunk.jpg');
    HW09_part4('BALLS_FOUR_5244_shrunk.jpg');
    
    %im = imread('MACBETH_HW09_shrunk.jpg');
    HW09_part4('MACBETH_HW09_shrunk.jpg');
    
    %im = imread('POCKET_CHANGE_4825_shrunk.jpg');
    HW09_part4('POCKET_CHANGE_4825_shrunk.jpg');
    pause(3);
    disp('Done with part 4...')
    close all;
    
    
    %% Part 5a
    disp('Part 5a....')
    HW09_part5a('MACBETH_HW09_shrunk.jpg');
    pause(3);
    disp('Done with part 5a...')
    close all;
      
    %% Part 5b
    disp('Part 5b....')
    HW09_part5b('POCKET_CHANGE_4825_shrunk.jpg');
    pause(3);
    disp('Done with part 5b...')
    close all;
  
    %% Part 6
    disp('Part 6....')
    HW09_part6('mypic2.jpg');
    pause(3);
    disp('Done with part 5b...')
    close all;
end


