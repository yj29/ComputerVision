function HW06_Jain_Yash( )
addpath( [ '..' filesep() 'TEST_IMAGES' filesep() ] );

%
%  This might generate a warning, but leave it in:
%
%  Adding path of input images directory
%  filesep returns file seperator for the platform.
addpath( [ '..' filesep() '..' filesep() 'TEST_IMAGES' filesep() ] );

%
% Demonstrates walking through a cell array:
%
% Cell array created to store file names
% File names are stored in cell down from line 37 to 40 
file_list_of_names_cell  = cell(18,1);

file_list_of_names = { ...
    'peppers.png', ...
    'cameraman.tif', ...
    'ANPR_Yellow_IMG_0764.JPG', ...
    'TBK_OLD_LANDMARK_Dr.jpg', ...
    'TBK_Yellow_Cart_Sign.JPG', ...
    'TBK_Orange_Balloon_Infinity.JPG', ...
    'Parent_Drop_off.jpg', ...
    'TBK_B70_IN_SUN_0900.JPG', ...
    'TBK_Road_Home_frm_CVPR_2012.jpg', ...
    'TBK_Buckle_Up_Next_Million_Miles_DSCF0372.jpg', ...
    'TBK_CAMO_FAILURE.JPG', ...
    'TBK_BRICKS.JPG', ...
    'TBK_Science_Frog.jpg', ...
    'TBK_Kite.JPG', ...
    'TBK_IMG_20150804_BEST_TRAFFIC_CONE.jpg', ...
    'TBK_relaxing_jaguar_wallpaper.jpg', ...
    'TBK_WALL_IMG_1066.JPG', ...
    'TBK_wood_work.JPG'  };

    % Reading file names array and storing it in cell array
    for idx=1:length(file_list_of_names)
        file_list_of_names_cell{idx,1} = file_list_of_names{idx};
    end
    
    for hw_part_number = 1:2
        
        fprintf('WORKING ON HOMEWORK PART NUMBER:  %2d\n', hw_part_number);
        
        for idx=1:length(file_list_of_names_cell)
            % If you index a cell array using parenthesis, (), you get a copy of the cell,
            % which is worthless to us.  We want the CONTENTS of the cell so we can work with it.
            %
            % To get the contents of a cell array, use braces, {}.
            fn = file_list_of_names_cell{idx};

            % Calling method from other file of the homework and
            % passing filename(fn) and hw_part_number to the method
            % 
            HW_06_Jain_Yash_Edge_Stats_and_Display( fn, hw_part_number );

            disp('pausing...');
            pause(2);

            % gcf returns the current figure so close will close the
            % current figure
            close( gcf );
            close( gcf );
        end
    end

end

