function outputImage = drawLinesOnImage(inputImage, numLines, outputFilename)
%DRAWLINESONIMAGE Allows user to draw multiple lines on an image.
%
%   outputImage = DRAWLINESONIMAGE(inputImage, numLines, outputFilename)
%
%   Inputs:
%     inputImage    - The image on which to draw lines. Can be a matrix
%                     (e.g., grayscale or RGB) or an empty array [] to
%                     create a blank image.
%     numLines      - The number of lines the user wants to draw.
%     outputFilename- (Optional) Filename to save the modified image.
%                     If empty or not provided, the image is not saved.
%
%   Output:
%     outputImage   - The image with drawn lines.

% Clear workspace and command window (optional, depends on usage context)
% clc; % Removed clc to avoid clearing calling program's command window

% Determine image dimensions based on inputImage or create a default blank
if isempty(inputImage)
    imageWidth = 3840;
    imageHeight = 745;
    % Create a blank image (e.g., black or white)
    % Using a black image here, you can change the color as needed.
    % For a grayscale image, use zeros(imageHeight, imageWidth, 'uint8');
    % For a color image (RGB), use zeros(imageHeight, imageWidth, 3, 'uint8');
    currentImage = zeros(imageHeight, imageWidth, 'uint8'); % Black image
else
    currentImage = inputImage;
    [imageHeight, imageWidth, numChannels] = size(currentImage);
    % Ensure image is uint8 for consistent plotting and saving, if not already
    if ~isa(currentImage, 'uint8')
        currentImage = im2uint8(currentImage);
    end
end

% Display the current image
figure; % Create a new figure window for drawing
imshow(currentImage);
title('Click points to draw multiple lines');
xlabel('X-coordinate');
ylabel('Y-coordinate');
hold on; % Allow plotting on top of the image for multiple lines

% --- Drawing multiple lines ---

% Validate numLines input
if ~isnumeric(numLines) || numLines < 1 || floor(numLines) ~= numLines
    error('Invalid input for numLines. Please provide a positive integer.');
end

fprintf('You will now draw %d lines.\n', numLines);

% Loop to draw each line
for i = 1:numLines
    fprintf('\nLine %d of %d: Please click on two points in the image window.\n', i, numLines);
    disp('The first click will be the start point, the second will be the end point.');

    % Get two points from user clicks
    [x, y] = ginput(2);

    % Extract coordinates for the two points
    x1 = x(1);
    y1 = y(1);
    x2 = x(2);
    y2 = y(2);

    % Display the selected points for the current line
    plot(x1, y1, 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Red circle for first point
    plot(x2, y2, 'go', 'MarkerSize', 10, 'LineWidth', 2); % Green circle for second point

    % Draw a line connecting the two points
    % The 'b-' means blue solid line
    plot([x1, x2], [y1, y2], 'b-', 'LineWidth', 3);

    fprintf('Line %d drawn from (%.1f, %.1f) to (%.1f, %.1f).\n', i, x1, y1, x2, y2);
end

% Turn off hold to prevent further plotting on this figure without re-holding
hold off;

% Add a final title
if numLines == 1
    finalTitle = sprintf('1 line drawn.');
else
    finalTitle = sprintf('%d lines drawn.', numLines);
end
title(finalTitle);

% Get the current frame from the figure to return as outputImage
% This captures the image *with* the drawn lines and markers
f = getframe(gcf); % Get the current figure as a frame
outputImage = f.cdata; % Extract the image data from the frame

% Close the figure window (optional, you might want to keep it open)
% close(gcf);

% --- Save the modified image if outputFilename is provided ---
if nargin >= 3 && ~isempty(outputFilename)
    try
        imwrite(outputImage, outputFilename);
        fprintf('Modified image saved to: %s\n', outputFilename);
    catch ME
        warning('Failed to save image to %s: %s\n', outputFilename, ME.message);
    end
end

end % End of function