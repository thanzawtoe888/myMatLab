% Main script to demonstrate drawing lines on an image using drawLinesOnImage function

% --- Configuration ---

% 1. Input Image:
%    - To use a blank image (3840x745), set inputImagePath to empty string:
%      inputImagePath = '';
%    - To load an existing image, provide its full path or relative path:
%      inputImagePath = 'path/to/your/image.jpg';
%      (Make sure the image file exists in your MATLAB path or current folder)
inputImagePath = 'frame_0000.jpg'; % Set to '' for a blank image, or 'your_image.jpg' for an existing one

% 2. Number of Lines to Draw:
%    Specify how many lines the user will be prompted to draw.
numLinesToDraw = 15; % Example: draw 2 lines

% 3. Output Filename (Optional):
%    - Provide a filename (e.g., 'drawn_image.png') to save the result.
%    - Set to empty string '' if you do not want to save the image.
outputSaveFilename = 'frame_0000_ref_lines.png';

% --- Main Logic ---

% Prepare the input image
if isempty(inputImagePath)
    fprintf('Creating a blank image (3840x745) as input.\n');
    inputImage = []; % Pass empty array to drawLinesOnImage to create a blank one
else
    fprintf('Attempting to load image from: %s\n', inputImagePath);
    try
        inputImage = imread(inputImagePath);
        fprintf('Image loaded successfully.\n');
    catch ME
        warning('Failed to load image from %s: %s\n', inputImagePath, ME.message);
        fprintf('Defaulting to a blank image instead.\n');
        inputImage = []; % Fallback to blank if loading fails
    end
end

% Call the drawLinesOnImage function
fprintf('\nCalling drawLinesOnImage function...\n');
drawnOutputImage = drawLinesOnImage(inputImage, numLinesToDraw, outputSaveFilename);

fprintf('\nFunction call completed.\n');

% Display the final output image (optional, as the function already shows it during drawing)
figure;
imshow(drawnOutputImage);
title('Final Output Image with All Lines');
fprintf('Displaying the final output image.\n');

% --- End of Main Script ---